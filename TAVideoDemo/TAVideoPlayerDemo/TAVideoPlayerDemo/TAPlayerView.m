//
//  TAPlayerView.m
//  TAVideoPlayerDemo
//
//  Created by tasama on 18/1/4.
//  Copyright © 2018年 MoemoeTechnology. All rights reserved.
//

#import "TAPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface TAPlayerView ()

@property (nonatomic, strong) UIView *transportView;

@end

@implementation TAPlayerView

+ (Class)layerClass {
    
    return [AVPlayerLayer class];
}

- (instancetype)initWithPlayer:(AVPlayer *)player andTransport:(UIView <TAPlayerTransport> *)transportView {
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [(AVPlayerLayer *)[self layer] setPlayer:player];
        
        [self addSubview:transportView];
        self.transportView = transportView;
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.transportView.frame = self.bounds;
}

@end
