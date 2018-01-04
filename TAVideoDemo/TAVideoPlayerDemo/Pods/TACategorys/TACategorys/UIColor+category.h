//
//  UIColor+category.h
//  mengmoCate
//
//  Created by tasama on 17/12/19.
//  Copyright © 2017年 Heyhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (category)

//返回16进制颜色（带alpha）
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

//返回16进制颜色（不带alpha）
+ (UIColor *)colorWithHexString:(NSString *)color;

//给View染上渐变色
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromHexColorStr toColor:(UIColor *)toHexColorStr;

//返回从startColor到endColor的中间色，rate范围0~1，0为startColor，1为endColor
+ (UIColor *)changeWithRate:(CGFloat)rate andStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor;

//返回渐变色的图片
+ (UIImage *)drawChangingColorWithSize:(CGSize)size fromColor:(UIColor *)fromHexColorStr toColor:(UIColor *)toHexColorStr withLocation:(CGPoint)startPoint toLocation:(CGPoint)endPoint;


@end
