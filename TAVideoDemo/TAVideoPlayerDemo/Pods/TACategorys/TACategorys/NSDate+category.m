//
//  NSDate+category.m
//  mengmoCate
//
//  Created by tasama on 17/12/19.
//  Copyright © 2017年 Heyhou. All rights reserved.
//

#import "NSDate+category.h"

@implementation NSDate (category)

+ (NSString *)currentTimeWithFormatter:(NSString *)formatter {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *forma = [[NSDateFormatter alloc] init];
    forma.dateFormat = formatter;
    
    return [forma stringFromDate:date];
}

- (NSString *)timeWithFormatter:(NSString *)formatter {
    
    NSDateFormatter *forma = [[NSDateFormatter alloc] init];
    forma.dateFormat = formatter;
    return [forma stringFromDate:self];
}

/**
 *  是否为今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    // 2014-04-30
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}

- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

+ (NSString *)dateStringChangeFromDateNum:(NSInteger )dateNum andFormat:(NSString *)format;
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateNum];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = format;
    return [fmt stringFromDate:date];
}

+ (NSString *)dateStringAboutCurrentTime {
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeStamp =[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", timeStamp];
    
    return timeString;
}

@end
