/**
 * Copyright © Sud.Tech
 * https://sud.tech
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (RW)
#pragma mark - Hash
///=============================================================================
/// @name Hash
///=============================================================================

/**
 Returns a lowercase NSString for md5 hash.
 */
- (nullable NSString *)md5String;

/**
 Returns a lowercase NSString for sha256 hash.
 */
- (nullable NSString *)sha256String;

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (nullable NSString *)sha1String;

/**
 对self进行AES加密（返回加密后的Base64字符）
 
 @param key   A key length of 16, 24 or 32 (128, 192 or 256bits).
 @param iv    An initialization vector length of 16(128bits).
 Pass nil when you don't want to use iv.
 
 @return      An NSString encrypted, or nil if an error occurs.
 */
- (nullable NSString *)aesEncryptWithKey:(NSString *)key iv:(nullable NSString *)iv;

/**
 对self进行AES解密（self为Base64字符）
 
 @param key   A key length of 16, 24 or 32 (128, 192 or 256bits).
 @param iv    An initialization vector length of 16(128bits).
 Pass nil when you don't want to use iv.
 
 @return      An NSString encrypted, or nil if an error occurs.
 */
- (nullable NSString *)aesDecryptWithkey:(NSString *)key iv:(nullable NSString *)iv;

#pragma mark - Encode and decode
///=============================================================================
/// @name Encode and decode
///=============================================================================

/**
 Returns an NSString for base64 encoded.
 */
- (nullable NSString *)base64EncodedString;

/**
 Returns an NSString from base64 encoded string.
 @param base64EncodedString string.
 */
+ (nullable NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString;

/**
 URL encode a string in utf-8.
 @return the encoded string.
 */
- (NSString *)stringByURLEncode;

/**
 URL decode a string in utf-8.
 @return the decoded string.
 */
- (NSString *)stringByURLDecode;

#pragma mark - Drawing
///=============================================================================
/// @name Drawing
///=============================================================================

/**
 *  获取文本标签size
 *  截断方式为NSLineBreakByWordWrapping, 对齐方式默认为NSTextAlignmentLeft
 *  @param font          字体
 *  @param size          限定范围
 *
 *  @return 返回文本标签实际size
 */
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

/**
 *  获取文本标签size
 *  对齐方式为NSTextAlignmentLeft
 *  @param font          字体
 *  @param size          限定范围
 *  @param lineBreakMode 截断方式
 *
 *  @return 返回文本标签实际size
 */
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size withLineBreakingMode:(NSLineBreakMode)lineBreakMode;

/**
 *  获取文本标签size
 *
 *  @param font          字体
 *  @param size          限定范围
 *  @param lineBreakingMode 截断方式
 *  @param textAlignment 文字对齐类型
 *
 *  @return 返回文本标签实际size
 */
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size withLineBreakingMode:(NSLineBreakMode)lineBreakingMode withTextAlignment:(NSTextAlignment)textAlignment;


/**
 Returns the width of the string if it were to be rendered with the specified
 font on a single line.
 
 @param font  The font to use for computing the string width.
 
 @return      The width of the resulting string's bounding box. These values may be
 rounded up to the nearest whole number.
 */
- (CGFloat)widthForFont:(UIFont *)font;

/**
 Returns the height of the string if it were rendered with the specified constraints.
 
 @param font   The font to use for computing the string size.
 
 @param width  The maximum acceptable width for the string. This value is used
 to calculate where line breaks and wrapping would occur.
 
 @return       The height of the resulting string's bounding box. These values
 may be rounded up to the nearest whole number.
 */
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;


#pragma mark - Utilities
///=============================================================================
/// @name Utilities
///=============================================================================

/**
 Returns a new UUID NSString
 e.g. "D1178E50-2A4D-4F1F-9BD3-F6AAB00E06B1"
 */
+ (NSString *)stringWithUUID;

/**
 Trim blank characters (space and newline) in head and tail.
 @return the trimmed string.
 */
- (NSString *)stringByTrim;

/**
 nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 */
- (BOOL)isNotBlank;

/**
 Returns YES if the target string is contained within the receiver.
 @param string A string to test the the receiver.
 
 @discussion Apple has implemented this method in iOS8.
 */
- (BOOL)containsString:(NSString *)string;

/**
 Returns YES if the target string is contained within the receiver.
 @param string A string to test the the receiver.
 @param mask NSStringCompareOptions
 
 */
- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)mask;

/**
 Returns YES if the target string is hasPrefix within the receiver.
 default NSCaseInsensitiveSearch
 @param string A string to test the the receiver.
 
 */
- (BOOL)hasInsensitivePrefix:(NSString *)string;

/**
 Returns YES if the target string is hasPrefix within the receiver.
 @param string A string to test the the receiver.
 @param mask NSStringCompareOptions
 
 */
- (BOOL)hasPrefix:(NSString *)string options:(NSStringCompareOptions)mask;

/**
 Returns YES if the target CharacterSet is contained within the receiver.
 @param set  A character set to test the the receiver.
 */
- (BOOL)containsCharacterSet:(NSCharacterSet *)set;

/**
 Returns an NSData using UTF-8 encoding.
 */
- (NSData *)dataValue;

/**
 Returns NSMakeRange(0, self.length).
 */
- (NSRange)rangeOfAll;

/**
 Returns an NSDictionary/NSArray which is decoded from receiver.
 Returns nil if an error occurs.
 
 e.g. NSString: @"{"name":"a","count":2}"  => NSDictionary: @[@"name":@"a",@"count":@2]
 */
- (id)jsonValueDecoded;

+ (NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;


//密码需8-16位，至少包含字母、数字、符号2种组合
+(BOOL)checkIsHaveNumAndLetter:(NSString*)sting;

/**
 中国电信号段为：133、149、153、173、177。还有180、181、189、199。

 中国联通号段：130、131、132、145、155、156、166、171、175、176、185、186、166。

 中国移动号段：134(0-8)、135、136、137、138、139、147、150、151、152、157、158、159、172、178、182、183、184、187、188、198
 */
///判断是否为手机号
- (BOOL)isPhoneNum;

///判断是否包含中文
- (BOOL)isContainsChinese;

///包含特殊字符Special characters
- (BOOL)isContainsSpecialCharacters;

///是否是纯数字
+ (BOOL)isAllNumText:(NSString *)str;

///纯中文字符串
+ (BOOL)isChineseCharacter:(NSString*)source;

///纯英文字符串
+ (BOOL)isEnglishCharacter:(NSString*)source;

///纯特殊字符
+ (BOOL)isAllCharacterString:(NSString *)string;

/// 包含emoji
+ (BOOL)stringContainsEmoji:(NSString *)string;


///去除字符串两端的空格和换行符
- (NSString *)RW_stringByTrimmingCharacters;

/// 汉字转成拼音的方法
+ (NSString *)chineseTransformToPinyin:(NSString *)chinese;

@end

NS_ASSUME_NONNULL_END
