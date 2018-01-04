//
//  NSString+category.h
//  mengmoCate
//
//  Created by tasama on 17/12/19.
//  Copyright © 2017年 Heyhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (category)

//获取字符串在UI上的宽度
- (CGFloat)stringWidthWithFont:(UIFont *)font andMaxHeight:(CGFloat)height;

//获取字符串在UI上的高度
- (CGFloat)stringHeightWithFont:(UIFont *)font andMaxWidth:(CGFloat)width;

//字符串MD5编码
- (NSString *)getStringByMd5Code;

// 检测是否包含表情符
+ (BOOL)stringContainsEmoji:(NSString *)string;

/// 根据最大字节数，获取字符串
- (NSString *)subsrtingToBytes:(NSUInteger)bytes;

//json转字典
- (NSDictionary *)jsonToDictionary;

//获取首字母
- (NSString *)firstCharactor;

//获取句子中所有单词的首字母组成缩写
- (NSString *)allFirstSingleCharactor;

//判断是否纯字母
- (BOOL)isLetter;

//判断是否纯数字
- (BOOL)isPureInt;

//判断银行卡
- (BOOL)checkCardNo;

//判断是否是电话号码
- (BOOL)numberIsLegal;

// 截取URL中的参数
- (NSMutableDictionary *)getURLParameters;

@end
