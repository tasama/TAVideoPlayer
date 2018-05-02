//
//  TAAVPlayer.m
//  TAVideoPlayerDemo
//
//  Created by tasama on 18/1/4.
//  Copyright © 2018年 MoemoeTechnology. All rights reserved.
//

#import "TAAVPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "TAPlayerView.h"
#import "FBKVOController.h"

#define REFRESH_INTERVAL 0.5

@interface TAAVPlayer () <TAPlayerTransportDelegate> {
    
    FBKVOController *_kvoCtrl;
    BOOL _isFullScreen;
    CGRect _originalBounds;
    CGPoint _originalCenter;
    CGRect _fullScreenBounds;
    CGPoint _fullScreenCenter;
}

@property (nonatomic, strong) UIView <TAPlayerTransport>* transport;

@property (nonatomic, strong) AVAsset *asset;

@property (nonatomic, strong) AVPlayerItem *item;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) TAPlayerView *playerView;

@property (nonatomic, strong) id timeObserver;

@property (nonatomic, strong) id timeEndObserver;

@property (nonatomic, assign) float lastPlayRate;

@property (nonatomic, weak) UIView *parentView;

@end

@implementation TAAVPlayer

#pragma mark - init

- (instancetype)initWithTransportView:(UIView<TAPlayerTransport> *)transportView {
    
    if (self = [super init]) {
        
        _transport = transportView;
        _kvoCtrl = [FBKVOController controllerWithObserver:self];
        _fullScreenBounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        _fullScreenCenter = CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0f, [UIScreen mainScreen].bounds.size.height / 2.0f);
    }
    return self;
}

- (instancetype)initWithUrl:(NSURL *)url andTransportView:(UIView<TAPlayerTransport> *)transportView {
    
    if (self = [self initWithTransportView:transportView]) {
        
        self.url = url;
    }
    return self;
}

#pragma mark - UI
    
- (void)layoutSubviews {
    
    [super layoutSubviews];
    _playerView.frame = self.bounds;
}

#pragma mark - Observe
- (void)playerPlayStatus:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_item.status == AVPlayerItemStatusReadyToPlay) {
            
            [self addPlayerItemTimeObserver];
            [self addItemEndObserverForPlayerItem];
            
            CMTime duration = _item.duration;
            [self.transport setCurrentTime:CMTimeGetSeconds(kCMTimeZero) duration:CMTimeGetSeconds(duration)];
            [self.player play];
            
        } else {
            
            NSLog(@"Error, Failed to load video");
        }
    });
}

#pragma mark - Private

- (void)prepareToPlay {
    
    if (self.timeObserver) {
        
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
    _item = [[AVPlayerItem alloc] initWithAsset:_asset];
    [_kvoCtrl observe:_item keyPath:TAAVPlayerStatus options:0 action:@selector(playerPlayStatus:)];
    _player = [[AVPlayer alloc] initWithPlayerItem:_item];
    _playerView = [[TAPlayerView alloc] initWithPlayer:_player andTransport:_transport];
    [self addSubview:_playerView];
    [_transport setDelegate:self];
}

- (void)addPlayerItemTimeObserver {
    
    CMTime interval = CMTimeMakeWithSeconds(REFRESH_INTERVAL, NSEC_PER_SEC);
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    __weak TAAVPlayer *weakPlayer = self;
    void (^callBack) (CMTime time) = ^(CMTime time) {
        
        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        NSTimeInterval duration = CMTimeGetSeconds(weakPlayer.item.duration);
        
        [weakPlayer.transport setCurrentTime:currentTime duration:duration];
    };
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:queue usingBlock:callBack];
}

- (void)addItemEndObserverForPlayerItem {
    
    NSString *name = AVPlayerItemDidPlayToEndTimeNotification;
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    __weak TAAVPlayer *weakPlayer = self;
    void (^callBack) (NSNotification *note) = ^(NSNotification *notification) {
        
        [weakPlayer.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
           
            [weakPlayer.transport playbackComplete];
        }];
    };
    self.timeEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:name object:self.item queue:queue usingBlock:callBack];
}

#pragma mark - Delegate

- (void)play {
    
    [self.player play];
}

- (void)pause {
    
    self.lastPlayRate = self.player.rate;
    [self.player pause];
}

- (void)stop {
    
    [self.player setRate:0.0f];
    [self.transport playbackComplete];
}

- (void)jumpedToTime:(NSTimeInterval)time {
    
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
}

- (void)scrubbingDidStart {
    
    self.lastPlayRate = self.player.rate;
    [self.player pause];
    [self.player removeTimeObserver:self.timeObserver];
}

- (void)scrubbedToTime:(NSTimeInterval)time {
    
    [self.item cancelPendingSeeks];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
}

- (void)scrubbingDidEnd {
    
    [self addPlayerItemTimeObserver];
    if (self.lastPlayRate > 0.0f) {
        
        [self.player play];
    }
}

- (void)turnScreen {
    
    if (!_isFullScreen) {
        
        _isFullScreen = YES;
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        _originalBounds = self.bounds;
        _originalCenter = self.center;
        _parentView = self.superview;
        [self removeFromSuperview];
        [window addSubview:self];
        [UIView animateWithDuration:.3f animations:^{
           
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.bounds = _fullScreenBounds;
            self.center = _fullScreenCenter;
        }];
    } else {
        
        _isFullScreen = NO;
        [_parentView addSubview:self];
        [UIView animateWithDuration:.3f animations:^{
            
            self.transform = CGAffineTransformIdentity;
            self.bounds = _originalBounds;
            self.center = _originalCenter;
        }];
    }
}

#pragma mark - Getter & Setter

- (void)setUrl:(NSURL *)url {
    
    _url = url;
    _asset = [AVAsset assetWithURL:url];
    [self prepareToPlay];
}

#pragma mark - dealloc

- (void)dealloc {
    
    if (self.timeObserver) {
        
        [self.player removeTimeObserver:self.timeObserver];
    }
    
    if (self.timeEndObserver) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self.timeEndObserver name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
}

@end
