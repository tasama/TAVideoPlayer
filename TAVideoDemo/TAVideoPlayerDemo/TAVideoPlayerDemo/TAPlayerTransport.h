//
//  TAPlayerTransport.h
//  TAVideoPlayerDemo
//
//  Created by tasama on 18/1/4.
//  Copyright © 2018年 MoemoeTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TAPlayerTransportDelegate <NSObject>

- (void)play;

- (void)pause;

- (void)stop;

- (void)scrubbingDidStart;

- (void)scrubbedToTime:(NSTimeInterval)time;

- (void)scrubbingDidEnd;

- (void)jumpedToTime:(NSTimeInterval)time;

- (void)turnScreen;

@end

@protocol TAPlayerTransport <NSObject>

@property (nonatomic, weak) id <TAPlayerTransportDelegate> delegate;

- (void)setTitle:(NSString *)title;

- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;

- (void)setScrubbingTime:(NSTimeInterval)time;

- (void)playbackComplete;

@end
