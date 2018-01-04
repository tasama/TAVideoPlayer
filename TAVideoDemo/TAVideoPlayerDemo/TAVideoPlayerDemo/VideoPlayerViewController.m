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

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    self.player.frame = CGRectMake(0, 0, 375, 200);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.player.url = [NSURL URLWithString:@"http://pl-ali.youku.com/playlist/m3u8?vid=XMzI4NzgxMTcxNg%3D%3D&type=flv&ups_client_netip=74cc6421&ups_ts=1515055926&utid=l4upETzYNnwCAXTMZCGG%2FIb7&ccode=050F&psid=c80ee68edef42e83cc90c24cc0e321c2&duration=189&expire=18000&ups_key=cbcb818ccda1c6b67426bffa4e2865ab"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (TAAVPlayer *)player {
    
    if (!_player) {
        
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"PlayerView" owner:nil options:nil].lastObject;
        _player = [[TAAVPlayer alloc] initWithTransportView:view];
    }
    return _player;
}

@end
