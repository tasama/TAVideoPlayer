//
//  NSString+category.m
//  mengmoCate
//
//  Created by tasama on 17/12/19.
//  Copyright © 2017年 Heyhou. All rights reserved.
//

#import "NSString+category.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (category)

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

- (CGFloat)stringWidthWithFont:(UIFont *)font andMaxHeight:(CGFloat)height {
    if (kStringIsEmpty(self))
    {
        return 0.0;
    }
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
    return rect.size.width;
}

- (CGFloat)stringHeightWithFont:(UIFont *)font andMaxWidth:(CGFloat)width {
    
    if (kStringIsEmpty(self))
    {
        return 0.0;
    }
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
    return rect.size.height;
}

- (NSString *)getStringByMd5Code {
    
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}


- (NSString *)subsrtingToBytes:(NSUInteger)bytes {
    
    /*
     *  UTF8 编码规则
     *
     *  1. 单字节的字符，字节的第一位设为0，对于英语文本，UTF-8码只占用一个字节，和ASCII码完全相同；
     *  2. n个字节的字符(n>1)，第一个字节的前n位设为1，第n+1位设为0，后面字节的前两位都设为10，这n个字节的其余空位填充该字符unicode码，高位用0补足。
     *
     *  0xxxxxxx
     *  110xxxxx 10xxxxxx
     *  1110xxxx 10xxxxxx 10xxxxxx
     *  11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
     *  111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
     *  1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
     *  11111110 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
     *
     */
    
    NSMutableData *mData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    if (mData.length > bytes) {
        
        mData = [mData subdataWithRange:NSMakeRange(0, bytes)];
    }
    
    Byte lastByte;  //最后一个字节
    
    NSUInteger length = mData.length;
    
    [mData getBytes:&lastByte range:NSMakeRange(length - 1, 1)];
    
    //  单字节字符
    if (lastByte < 0x80 /*0x 1000 0000*/) {
        
        return [[NSString alloc] initWithData:mData encoding:NSUTF8StringEncoding];
    }// 多字节字符起始字节，直接丢弃
    else if (lastByte > 0xc0 /*0x 1100 0000*/) {
        
        mData = [mData subdataWithRange:NSMakeRange(0, length - 1)];
        
        return [[NSString alloc] initWithData:mData encoding:NSUTF8StringEncoding];
    }
    else {
        //  从最后一字节往前查找最后一个字符首字节
        int offset = 1;
        
        do {
            
            offset ++;
            [mData getBytes:&lastByte range:NSMakeRange(length - offset, 1)];
            
        } while (lastByte <= 0xbf /*0x 1011 1111*/);
        
        //  大小为offset的字符的首字节最大值（第offset位置0）
        Byte tmpByte = (0xff >> (offset + 1)) | (0xff << (8 - offset));
        
        //  截取字符串不完整，丢弃最后一个字符部分内容
        if (lastByte > tmpByte) {
            
            mData = [mData subdataWithRange:NSMakeRange(0, length - offset)];
        }
        
        return [[NSString alloc] initWithData:mData encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

- (NSDictionary *)jsonToDictionary {
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSString *)firstCharactor {
    
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:self];
    
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = [str stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    //转化为大写拼音
    NSString *pinYin = [[self polyphoneStringPinyinString:pinyinString] uppercaseString];
    
    // 截取大写首字母
    NSString *firstString = pinYin.copy;
    if (pinYin.length > 1) {
        
        firstString = [pinYin substringToIndex:1];
    }
    // 判断姓名首位是否为大写字母
    NSString * regexA = @"^[A-Z]$";
    NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
    // 获取并返回首字母
    return [predA evaluateWithObject:firstString] ? firstString : @"#";
}

/**
 多音字处理
 */
- (NSString *)polyphoneStringPinyinString:(NSString *)pinyinString
{
    if ([self hasPrefix:@"长"]) { return @"chang";}
    if ([self hasPrefix:@"沈"]) { return @"shen"; }
    if ([self hasPrefix:@"厦"]) { return @"xia";  }
    if ([self hasPrefix:@"地"]) { return @"di";   }
    if ([self hasPrefix:@"重"]) { return @"chong";}
    return pinyinString;
}

- (NSString *)allFirstSingleCharactor {
    
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:self];
    
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = [str stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    NSString *pinYin = [[self polyphoneStringPinyinString:pinyinString] uppercaseString];
    
    NSArray *arrString = [pinYin componentsSeparatedByString:@" "];
    
    NSMutableString *allString = @"".mutableCopy;
    
    if ([arrString count] > 1) {
        
        for (NSString *str in arrString) {
            
            [allString appendString:str.firstCharactor];
        }
    } else {
        
        NSString *firstSting = arrString.firstObject;
        
        if (!kStringIsEmpty(firstSting)) {
            [allString appendString:firstSting.firstCharactor];
        }
    }
    //获取并返回首字母
    return allString.copy;
}

- (BOOL)isLetter {
    
    if ([self characterAtIndex:0] <= 90 && [self characterAtIndex:0] >= 65) {
        
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断银行卡
- (BOOL)checkCardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[self length];
    int lastNum = [[self substringFromIndex:cardNoLength-1] intValue];
    
    NSString *cardNo = [self substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}
/**
 判断是否是电话号码
 */
- (BOOL)numberIsLegal
{
    NSString *regex = @"^1[3|4|5|6|7|8][0-9]\\d{8}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isValid = [predicate evaluateWithObject:self];
    
    return isValid;
}

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getURLParameters {
    
    // 查找参数
    NSRange range = [self rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [self substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}
@end
