/**
 * Copyright © Sud.Tech
 * https://sud.tech
 */

#import <Foundation/Foundation.h>



@interface GameLoadModel : NSObject
@property (nonatomic, copy)   NSString * gameName;
@property (nonatomic, assign) uint64_t   mgId;
@end


NS_ASSUME_NONNULL_BEGIN
@class UILabel;
/// 登录接入方服务器url
#warning 登录接入方服务器url修改地址
static NSString* LOGIN_URL = @"https://fat-mgp-hello.sudden.ltd/login/v2";

@interface Common : NSObject
/// 获取用户名
+ (NSString *)getUserName;
/// 字典转JSON
/// @param dic 字典
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
/// JSON转字典
/// @param turnString JSON
+ (NSDictionary *)turnStringToDictionary:(NSString *)turnString;
/// 登录到接入方服务器
/// @param userid   用户id
/// @param resultCb 回调
+ (void)loginWithUserId:(NSString *)userid resultCallbckBlock:(void(^)(NSString *code, NSError *error, int retCode))resultCb;

/// 按照长度生成随机字符串
/// @param length 长度
+ (NSString *)generateRandomStringByLength:(int)length;

/// 获取带颜色的NSMutableAttributedString
/// @param string string
/// @param color color
+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string color:(NSString *)color;

/// 获取带颜色的NSMutableAttributedString
/// @param string string
/// @param color UIColor
+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string uiColor:(UIColor *)color;


/// 获取游戏错误表
+ (NSDictionary *)getErrorMap;

/// 获取sdk版本Label
+ (UILabel *)getSDKVersionLabel;

/// 获取支持语言
+ (NSArray *)getLanguages;

/// 获取游戏名列表
+ (NSArray *)getGameNames;

/// 获取appid展示列表（添加了环境名字）
+ (NSArray <NSString *>*)getDisPlayAppIds;

/// 获取appid列表
+ (NSArray <NSString *>*)getAppIds;

/// 获取appkey列表
+ (NSArray <NSString *>*)getAppKeys;

/// 获取游戏列表
+ (NSArray <GameLoadModel *>*)getGameModels;

/// 通过游戏名获取游戏mgid
+ (uint64_t)getMgIdByGameName:(NSString *)gameName;

+ (int)getHashCode:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
