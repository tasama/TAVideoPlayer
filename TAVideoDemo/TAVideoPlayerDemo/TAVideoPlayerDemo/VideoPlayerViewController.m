//
//  VideoPlayerViewController.m
//  TAVideoPlayerDemo
//
//  Created by tasama on 18/1/4.
//  Copyright © 2018年 MoemoeTechnology. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <UIView+Layout.h>
#import "TAAVPlayer.h"

@interface VideoPlayerViewController ()

@property (nonatomic, strong) TAAVPlayer *player;

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.player];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.player performSelector:@selector(turnScreen)];
}

- (TAAVPlayer *)player {
    
    if (!_player) {
        
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"PlayerView" owner:nil options:nil].lastObject;
        _player = [[TAAVPlayer alloc] initWithUrl:[NSURL URLWithString:@"https://media.w3.org/2010/05/sintel/trailer.mp4"] andTransportView:(UIView <TAPlayerTransport> *)view];
        
        _player.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300.0f);
        _player.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0f, (150.0f + 64.0f));
    }
    return _player;
}

@end
