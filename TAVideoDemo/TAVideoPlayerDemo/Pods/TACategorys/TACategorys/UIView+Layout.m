//
//  UIView+Layout.m
//  XXX
//
//  Created by tasama on 18/1/4.
//  Copyright © 2018年 MoemoeTechnology. All rights reserved.
//

#import "UIView+Layout.h"

@implementation UIView (Layout)

- (void)setMWidth:(CGFloat)mWidth {
    
    CGSize size = self.bounds.size;
    size.width = mWidth;
    self.bounds = CGRectMake(0, 0, size.width, size.height);
}

- (CGFloat)mWidth {
    
    return self.bounds.size.width;
}

- (void)setMHeight:(CGFloat)mHeight {
    
    CGSize size = self.bounds.size;
    size.height = mHeight;
    self.bounds = CGRectMake(0, 0, size.width, size.height);
}

- (CGFloat)mHeight {
    
    return self.bounds.size.height;
}

- (void)setMLeft:(CGFloat)mLeft {
    
    CGPoint origin = self.frame.origin;
    origin.x = mLeft;
    
    self.frame = CGRectOffset(self.bounds, origin.x, origin.y);
}

- (CGFloat)mLeft {
    
    return self.frame.origin.x;
}

- (void)setMRight:(CGFloat)mRight {
    
    CGPoint origin = self.frame.origin;
    origin.x = mRight - self.bounds.size.width;
    
    self.frame = CGRectOffset(self.bounds, origin.x, origin.y);
}

- (CGFloat)mRight {
    
    return self.frame.origin.x + self.bounds.size.width;
}

- (void)setMTop:(CGFloat)mTop {
    
    CGPoint origin = self.frame.origin;
    origin.y = mTop;
    
    self.frame = CGRectOffset(self.bounds, origin.x, origin.y);
}

- (CGFloat)mTop {
    
    return self.frame.origin.y;
}

- (void)setMBottom:(CGFloat)mBottom {
    
    CGPoint origin = self.frame.origin;
    origin.y = mBottom - self.bounds.size.height;
    
    self.frame = CGRectOffset(self.bounds, origin.x, origin.y);
}

- (CGFloat)mBottom {
    
    return self.frame.origin.y + self.bounds.size.height;
}

@end
