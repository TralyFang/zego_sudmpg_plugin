/**
 * Copyright © Sud.Tech
 * https://sud.tech
 */

#import "NSString+RW.h"
#import "NSData+RW.h"


@implementation NSString (RW)

 -(NSString *)md5String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5String];
}

- (NSString *)sha256String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha256String];
}

- (NSString *)sha1String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1String];
}

- (nullable NSString *)aesEncryptWithKey:(NSString *)key iv:(nullable NSString *)iv {
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    data = [data aesEncryptWithKey:[key dataUsingEncoding:NSUTF8StringEncoding]
                                iv:[iv dataUsingEncoding:NSUTF8StringEncoding]];
    //一般使用Base64, 使用UTF-8,一般会返回nil
    return [data base64EncodedString];
}

- (nullable NSString *)aesDecryptWithkey:(NSString *)key iv:(nullable NSString *)iv {
    NSData * data = [NSData dataWithBase64EncodedString:self];
    data = [data aesDecryptWithkey:[key dataUsingEncoding:NSUTF8StringEncoding]
                                iv:[iv dataUsingEncoding:NSUTF8StringEncoding]];
    NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}

- (NSString *)base64EncodedString {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
}

+ (NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString {
    NSData *data = [NSData dataWithBase64EncodedString:base64EncodedString];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)stringByURLEncode {
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
   
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)self,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)stringByURLDecode {
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
#pragma clang diagnostic pop
    }
}

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self textSizeWithFont:font constrainedToSize:size withLineBreakingMode:NSLineBreakByWordWrapping];
}

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size withLineBreakingMode:(NSLineBreakMode)lineBreakMode {
    return [self textSizeWithFont:font constrainedToSize:size withLineBreakingMode:NSLineBreakByWordWrapping withTextAlignment:NSTextAlignmentLeft];
}

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size withLineBreakingMode:(NSLineBreakMode)lineBreakingMode withTextAlignment:(NSTextAlignment)textAlignment
{
    CGSize textSize;
    
    NSMutableParagraphStyle *style = nil;
    style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = lineBreakingMode;
    style.alignment = textAlignment;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    attributes[NSFontAttributeName] = font;
    [attributes setValue:style forKey:NSParagraphStyleAttributeName];
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        textSize = [self sizeWithAttributes:attributes];
    }
    else {
        //NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（译者注：字体大小+行间距=行高）
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGRect rect = [self boundingRectWithSize:size
                                         options:option
                                      attributes:attributes
                                         context:nil];
        textSize = rect.size;
    }
    
    return textSize;
}

- (CGFloat)widthForFont:(UIFont *)font {
    CGSize size = [self textSizeWithFont:font constrainedToSize:CGSizeMake(HUGE, HUGE)];
    return size.width;
}


- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self textSizeWithFont:font constrainedToSize:CGSizeMake(width, HUGE)];
    return size.height;
}


+ (NSString *)stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

- (NSString *)stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (BOOL)isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containsString:(NSString *)string {
    if (string == nil) return NO;
    return [self rangeOfString:string].location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)mask{
    if (string == nil) return NO;
    return [self rangeOfString:string options:mask].location != NSNotFound;
}

- (BOOL)hasInsensitivePrefix:(NSString *)string{
    if (string == nil) return NO;
    NSString *commonStr = [self commonPrefixWithString:string options:NSCaseInsensitiveSearch];
    if ([commonStr caseInsensitiveCompare:string] == NSOrderedSame) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)hasPrefix:(NSString *)string options:(NSStringCompareOptions)mask{
    if (string == nil) return NO;
    NSString *commonStr = [self commonPrefixWithString:string options:mask];
    if ([commonStr caseInsensitiveCompare:string] == NSOrderedSame) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)containsCharacterSet:(NSCharacterSet *)set {
    if (set == nil) return NO;
    return [self rangeOfCharacterFromSet:set].location != NSNotFound;
}

- (NSData *)dataValue {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSRange)rangeOfAll {
    return NSMakeRange(0, self.length);
}

- (id)jsonValueDecoded {
    return [[self dataValue] jsonValueDecoded];
}


-(NSString*)coverBodyWithLength:(NSInteger)length
{
    NSMutableString* body = [NSMutableString new];
    for(int i=0;i<length;i++)
    {
        [body appendString:@"*"];
    }
    return body;
}

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for(int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if(value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}
+(NSString *)jsonStringWithObject:(id) object{
    NSString *value =nil;
    if(!object) {
        return value;
    }
    if([object isKindOfClass:[NSString class]]) {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString jsonStringWithArray:object];
    }
    return value;
}

+(NSString *) jsonStringWithString:(NSString *) string{
    return[NSString stringWithFormat:@"\"%@\"",
           [[string stringByReplacingOccurrencesOfString:@"\n"withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
           ];
}

+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for(id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if(value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}


+ (BOOL)checkIsHaveNumAndLetter:(NSString *)sting{
    
//如果要限定特殊字符，例如，特殊字符的范围为 !#$%^&* ，那么可以这么改
//        ^(?![\d]+$)(?![a-zA-Z]+$)(?![!#$%^&*]+$)[\da-zA-Z!#$%^&*]{8,16}$
        
//表示不包含emoji表情、汉字，以及空格与回车，里面的符合可以自动补充或删除；
        NSString *regex = @"^(?![\\d]+$)(?![a-zA-Z]+$)(?![^\\da-zA-Z]+$).{8,16}$";
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [regextestmobile evaluateWithObject:sting];
    
    
//    正则表达式：1、(?!.*[！·（）{}【】“”：；，》￥、。‘’——\\s-……%\\n])  表示的是不含中文的特殊字符，以及空格与回车，里面的符合可以自动补充或删除；
//
//    2、(?=.*[a-zA-Z])   表示含小写或大写的英文字母
//
//    3、(?=.*\\d)  表示必须匹配到数字
//
//    4、(?=.*[~!@#$%^&*()_+`\\-={}:\";'<>?,.\\/])   表示含英文的特殊字符，里面的符合可以自动补充或删除
//
//    5、[^\\u4e00-\\u9fa5]  表示不允许有中文  ；表示允许有中文的，即：[\\u4e00-\\u9fa5]
//
//    6、{6,12}  表示长度要求，6~12位
//    表示的是不含中文的特殊字符，以及空格与回车，里面的符合可以自动补充或删除；
//    NSString *regex = @"^(?!.*[！·（）{}【】“”：；，》￥、。‘’——\\s-……%\\n])(?=.*[a-zA-Z])(?=.*\\d)(?=.*[~!@#$%^&*()_+`\\-={}:\";'<>?,.\\/])[^\\u4e00-\\u9fa5]{8,16}$";
    

//
//    //数字条件
//    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
//
//    //符合数字条件的有几个字节
//    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:sting
//                                                                        options:NSMatchingReportProgress
//                                                                          range:NSMakeRange(0, sting.length)];
//    //英文字条件
//    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
//
//    //英文特殊字符条件
//    NSRegularExpression *specialRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[~!@#$%^&*()_+`\\-={}[]:\";'<>?,.\\/！·（）{}【】“”：；，》￥、。‘’——\\s-……%\\n]" options:NSRegularExpressionCaseInsensitive error:nil];
//
//    //符合英文字条件的有几个字节
//    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:sting options:NSMatchingReportProgress range:NSMakeRange(0, sting.length)];
//    if (tNumMatchCount == sting.length) { //全部符合数字，表示沒有英文
//        return 1;
//
//    } else if (tLetterMatchCount == sting.length) { //全部符合英文，表示沒有数字
//        return 2;
//
//    } else if (tNumMatchCount + tLetterMatchCount == sting.length) { //符合英文和符合数字条件的相加等于密码长度
//        return 3;
//
//    }else {  //可能包含标点符号的情況，或是包含非英文的文字
//        return 4;
//    }
}


- (BOOL)isPhoneNum
{
    NSString *MOBILE = @"^1(3[0-9]|4[579]|5[0-35-9]|6[6]|7[0-35-9]|8[0-9]|9[89])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:self];
}

-(BOOL)isContainsChinese{
    
    for(int i=0; i< [self length];i++)
    {
        int a = [self characterAtIndex:i];
        if( a > 0x4E00 && a < 0x9FFF)
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isContainsSpecialCharacters{
    
       NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
       NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
       if (![emailTest evaluateWithObject:self]) {
           return YES;
       }
       return NO;
}

//是否是纯数字
+ (BOOL)isAllNumText:(NSString *)str{
 
    NSString *regex =@"[0-9]*";

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];

    if ([pred evaluateWithObject:str]) {

        return YES;

    }

    return NO;

}

+ (BOOL)isChineseCharacter:(NSString*)source {

    NSString *regex = @"^[\\u4E00-\\u9FEA]+$";

    return ([source rangeOfString:regex options:NSRegularExpressionSearch].length>0);

}

+ (BOOL)isEnglishCharacter:(NSString*)source {

    NSString *upperRegex = @"^[\\u0041-\\u005A]+$";

    NSString *lowerRegex = @"^[\\u0061-\\u007A]+$";

    BOOL isEnglish = (([source rangeOfString:upperRegex options:NSRegularExpressionSearch].length>0) || ([source rangeOfString:lowerRegex options:NSRegularExpressionSearch].length>0));

    return isEnglish;

}

+ (BOOL)isAllCharacterString:(NSString *)string
{
    NSString *regex = @"[~`!@#$%^&*()_+-=[]|{};':\",./<>?]{,}/";//规定的特殊字符，可以自己随意添加
    
    //计算字符串长度
    NSInteger str_length = [string length];
    
    NSInteger allIndex = 0;
    for (int i = 0; i<str_length; i++) {
        //取出i
        NSString *subStr = [string substringWithRange:NSMakeRange(i, 1)];
        if([regex rangeOfString:subStr].location != NSNotFound)
        {  //存在
            allIndex++;
        }
    }
    
    if (str_length == allIndex) {
        //纯特殊字符
        return YES;
    }
    else
    {
        //非纯特殊字符
        return NO;
    }
}

/// 包含emoji
+ (BOOL)stringContainsEmoji:(NSString *)string{

        __block BOOL returnValue = NO;
        [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences

        usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        const unichar hs = [substring characterAtIndex:0];
            NSLog(@"hs:%c",hs);
        if (0xd800 <= hs && hs <= 0xdbff){

            if (substring.length > 1){
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f918){
                    returnValue = YES;
                }
            }
        }else if (substring.length > 1){

            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3 || ls == 0xFE0F || ls == 0xd83c){
                returnValue = YES;
            }
        }else{
            if (0x2100 <= hs && hs <= 0x27ff){

                if (0x278b <= hs && 0x2792 >= hs){
                    returnValue = NO;
                }else{
                    returnValue = YES;
                }

            }else if (0x2B05 <= hs && hs <= 0x2b07){
                returnValue = YES;
            }else if (0x2934 <= hs && hs <= 0x2935){
                returnValue = YES;
            }else if (0x3297 <= hs && hs <= 0x3299){
                returnValue = YES;
            }else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50 || hs == 0xd83e){
                returnValue = YES;
            }
        }

        }];

    return returnValue;
}


- (NSString *)RW_stringByTrimmingCharacters{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString *)chineseTransformToPinyin:(NSString *)chinese{
    CFStringRef hanzi = (__bridge CFStringRef)(chinese);
        CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, hanzi);
     
        // Boolean CFStringTransform(CFMutableStringRef string, CFRange *range, CFStringRef transform, Boolean reverse);
        //string 为要转换的字符串
        // range 要转换的范围，NULL 则为全部
        //transform 要进行怎么样的转换    //kCFStringTransformMandarinLatin 将汉字转拼音
        //reverse 是否支持逆向转换
        CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
        
        //kCFStringTransformStripDiacritics去掉声调
        CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
        
        NSString * pinyin = (NSString *) CFBridgingRelease(string);
        //将中间分隔符号去掉
        pinyin = [pinyin stringByReplacingOccurrencesOfString:@" " withString: @""];
        
    return pinyin;
}

@end
