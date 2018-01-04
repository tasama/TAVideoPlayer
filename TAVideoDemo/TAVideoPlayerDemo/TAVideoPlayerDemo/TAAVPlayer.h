//
//  TAAVPlayer.h
//  TAVideoPlayerDemo
//
//  Created by tasama on 18/1/4.
//  Copyright © 2018年 MoemoeTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAPlayerTransport.h"

static NSString * const TAAVPlayerStatus = @"status";
static const NSString *PlayerItemStatusContext;


@interface TAAVPlayer : UIView

@property (nonatomic, strong) NSURL *url;

- (instancetype)initWithTransportView:(UIView <TAPlayerTransport>*)transportView;

- (instancetype)initWithUrl:(NSURL *)url andTransportView:(UIView <TAPlayerTransport>*)transportView;

@end
