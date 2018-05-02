//
//  PlayerView.m
//  TAVideoPlayerDemo
//
//  Created by tasama on 18/1/4.
//  Copyright © 2018年 MoemoeTechnology. All rights reserved.
//

#import "PlayerView.h"

@interface PlayerView () {
    
    id <TAPlayerTransportDelegate> _delegate;
}

@property (weak, nonatomic) IBOutlet UIButton *playerBtn;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (nonatomic, assign) NSTimeInterval duration;

@end

@implementation PlayerView

- (void)setTitle:(NSString *)title {
    
}

- (void)playbackComplete {
    
    
}

- (void)setScrubbingTime:(NSTimeInterval)time {
    
}

- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration {
    
    self.duration = duration;
    float value = time / duration;
    [self.slider setValue:value];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.delegate turnScreen];
}

- (void)setDelegate:(id<TAPlayerTransportDelegate>)delegate {
    
    _delegate = delegate;
}

- (id<TAPlayerTransportDelegate>)delegate {
    
    return _delegate;
}


- (IBAction)playBtn:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (!sender.selected) {
        
        [self.delegate play];
    } else {
        
        [self.delegate pause];
    }
}

- (IBAction)slider:(UISlider *)sender {
    
    NSTimeInterval time = sender.value * self.duration;
    [self.delegate scrubbedToTime:time];
}

- (IBAction)sliderTouchDown:(UISlider *)sender {
    
    [self.delegate scrubbingDidStart];
}

- (IBAction)sliderTouchUp:(UISlider *)sender {
    
    [self.delegate scrubbingDidEnd];
}

@end
