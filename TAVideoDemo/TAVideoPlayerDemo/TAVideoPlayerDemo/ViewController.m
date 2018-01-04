//
//  ViewController.m
//  TAVideoPlayerDemo
//
//  Created by tasama on 18/1/4.
//  Copyright © 2018年 MoemoeTechnology. All rights reserved.
//

#import "ViewController.h"
#import "VideoPlayerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (IBAction)jumpToVideo:(id)sender {
    
    VideoPlayerViewController *videoPlayer = [[VideoPlayerViewController alloc] init];
    [self.navigationController pushViewController:videoPlayer animated:YES];
}

@end
