//
//  UIColor+category.m
//  mengmoCate
//
//  Created by tasama on 17/12/19.
//  Copyright © 2017年 Heyhou. All rights reserved.
//

#import "UIColor+category.h"

@implementation UIColor (category)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}

+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromHexColorStr toColor:(UIColor *)toHexColorStr{
    
    if (!fromHexColorStr || !toHexColorStr) {
        
        return nil;
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromHexColorStr.CGColor,(__bridge id)toHexColorStr.CGColor];
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1, 1);
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}

+ (UIColor *)changeWithRate:(CGFloat)rate andStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor {
    
    CGColorRef startColorRef = startColor.CGColor;
    NSUInteger numComponents = CGColorGetNumberOfComponents(startColorRef);
    
    CGFloat startG = 0.0f;
    CGFloat startB = 0.0f;
    if (numComponents == 2) {
        
        startG = CGColorGetComponents(startColorRef)[0];
        startB = CGColorGetComponents(startColorRef)[0];
    } else {
        
        startG = CGColorGetComponents(startColorRef)[1];
        startB = CGColorGetComponents(startColorRef)[2];
    }
    CGFloat startA = CGColorGetComponents(startColorRef)[numComponents - 1];
    CGFloat startR = CGColorGetComponents(startColorRef)[0];
    
    CGColorRef endColorRef = endColor.CGColor;
    numComponents = CGColorGetNumberOfComponents(endColorRef);
    
    CGFloat endG = 0.0f;
    CGFloat endB = 0.0f;
    if (numComponents == 2) {
        
        endG = CGColorGetComponents(endColorRef)[0];
        endB = CGColorGetComponents(endColorRef)[0];
    } else {
        
        endG = CGColorGetComponents(endColorRef)[1];
        endB = CGColorGetComponents(endColorRef)[2];
    }
    CGFloat endA = CGColorGetComponents(endColorRef)[numComponents - 1];
    CGFloat endR = CGColorGetComponents(endColorRef)[0];
    
    CGFloat a = startA + rate * (endA - startA);
    CGFloat r = startR + rate * (endR - startR);
    CGFloat b = startB + rate * (endB - startB);
    CGFloat g = startG + rate * (endG - startG);
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (UIImage *)drawChangingColorWithSize:(CGSize)size fromColor:(UIColor *)fromHexColorStr toColor:(UIColor *)toHexColorStr withLocation:(CGPoint)startPoint toLocation:(CGPoint)endPoint {
    
    UIGraphicsBeginImageContext(size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    
    //绘制Path
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddRect(path, NULL, rect);
    //    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMinY(rect));
    //    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    //    CGPathAddLineToPoint(path, NULL, CGRectGetMaxY(rect), CGRectGetMinX(rect));
    //    CGPathCloseSubpath(path);
    
    //绘制渐变
    [self drawLinearGradient:gc path:path startColor:fromHexColorStr.CGColor endColor:toHexColorStr.CGColor];
    
    //注意释放CGMutablePathRef
    CGPathRelease(path);
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


@end
