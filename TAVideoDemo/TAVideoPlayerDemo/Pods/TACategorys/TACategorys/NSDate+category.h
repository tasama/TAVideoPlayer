//
//  NSDate+category.h
//  mengmoCate
//
//  Created by tasama on 17/12/19.
//  Copyright © 2017年 Heyhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (category)

//获取当前时间字符串（formatter为字符串格式）
+ (NSString *)currentTimeWithFormatter:(NSString *)formatter;

//nsdate转化为字符串（formatter为字符串格式）
- (NSString *)timeWithFormatter:(NSString *)formatter;

//是否今天
- (BOOL)isToday;

//是否为昨天
- (BOOL)isYesterday;

//是否为今年
- (BOOL)isThisYear;

//把时间戳转换为时间字符串
+ (NSString *)dateStringChangeFromDateNum:(NSInteger )dateNum andFormat:(NSString *)format;

//获取当前时间的时间戳
+ (NSString *)dateStringAboutCurrentTime;

@end
