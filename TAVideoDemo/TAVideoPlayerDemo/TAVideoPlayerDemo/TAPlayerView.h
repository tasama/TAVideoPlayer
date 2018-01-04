//
//  TAPlayerView.h
//  TAVideoPlayerDemo
//
//  Created by tasama on 18/1/4.
//  Copyright © 2018年 MoemoeTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TAPlayerTransport.h"

@interface TAPlayerView : UIView

- (instancetype)initWithPlayer:(AVPlayer *)player andTransport:(UIView <TAPlayerTransport> *)transportView;

@end
