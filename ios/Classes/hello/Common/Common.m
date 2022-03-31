/**
 * Copyright © Sud.Tech
 * https://sud.tech
 */

#import "Common.h"
#import <AFNetworking/AFNetworking.h>
#import "UIColor+RW.h"
#import <SudMGP/SudMGP.h>
#import <CommonCrypto/CommonDigest.h>
#import "AppConfig.h"

@implementation GameLoadModel
@end


@implementation Common
/// 获取用户名
+ (NSString *)getUserName {
    return [self MD5ForLower8Bate:[self getUUID]];
}

+ (int)getHashCode:(NSString *)string {
    int hash = 0;
    for (int i = 0; i < string.length; i++) {
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        char *unicode = (char *)[s cStringUsingEncoding:NSUTF8StringEncoding];
        int charactorUnicode = 0;
        size_t length = strlen(unicode);
        for (int n = 0; n < length; n ++) {
            charactorUnicode += (int)((unicode[n] & 0xff) << (n * sizeof(char) * 8));
        }
        hash = hash * 31 + charactorUnicode;
    }
    return hash;
}

/// 获取uuid
+ (NSString *)getUUID {
    return [UIDevice currentDevice].identifierForVendor.UUIDString;;
}

// 8位小写
+(NSString *)MD5ForLower8Bate:(NSString *)str {
    NSString *md5Str = [self MD5ForLower32Bate:str];
    NSString  *string = [md5Str substringWithRange:NSMakeRange(8, 8)];
    return string;
}

// 32位 小写
+(NSString *)MD5ForLower32Bate:(NSString *)str{
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }

    return digest;
}

#pragma mark - =======login=======
/// 登录到接入方服务器
+ (void)loginWithUserId:(NSString *)userid resultCallbckBlock:(void(^)(NSString *code, NSError *error, int retCode))resultCb {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 是否允许无效证书, 默认为NO
        manager.securityPolicy.allowInvalidCertificates = YES;
        // 是否校验域名, 默认为YES
        manager.securityPolicy.validatesDomainName = NO;
    /// 这里的user_id是设置游戏中用户名，由接入方传入,这里uuid只是示例
    NSDictionary * param = @{@"user_id" : [self getUserName]};
    [manager POST:LOGIN_URL parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [responseObject objectForKey:@"data"];
        /// 这里的code用于登录游戏sdk服务器
        NSString * code = [dic objectForKey:@"code"];
        int retCode = (int)[[dic objectForKey:@"ret_code"] longValue];
        resultCb(code, nil, retCode);
        [self invalidateHttpSession:manager];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        resultCb(nil, error, -1);
        [self invalidateHttpSession:manager];
    }];
    
}

+ (void)invalidateHttpSession:(AFHTTPSessionManager *)manager{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [manager invalidateSessionCancelingTasks:YES];
    });
}

#pragma mark -产生随机字符串
+ (NSString *)generateRandomStringByLength:(int)length
{
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRST";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (int i = 0; i < length; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString * charString = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:charString];
    }
    return resultStr;
}


#pragma mark - 字典 json字符串互转
+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)turnStringToDictionary:(NSString *)turnString {
    NSData *turnData = [turnString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *turnDic = [NSJSONSerialization JSONObjectWithData:turnData options:NSJSONReadingMutableLeaves error:nil];
    return turnDic;
}

+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string color:(NSString*)color {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor RW_colorWithHexString:color] range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string uiColor:(UIColor *)color {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

+ (UILabel *)getSDKVersionLabel {
    UILabel * versionLabel = [[UILabel alloc]init];
    versionLabel.text = [Common getSDKVersion];
    versionLabel.font = [UIFont boldSystemFontOfSize:10];
    versionLabel.textColor = [UIColor whiteColor];
    versionLabel.textAlignment = NSTextAlignmentRight;
    return versionLabel;
}

+ (NSString *)getSDKVersion {
    return [NSString stringWithFormat:@"v%@",[SudMGP getVersion]];
}

+ (NSDictionary *)getErrorMap {
    return  @{
        // 通用错误
        @"100000" : @"通用错误",
        @"100001" : @"http 缺失code 参数",
        @"100002" : @"http 缺失roomID 参数",
        @"100003" : @"http 缺失appID 参数",
        @"100004" : @"http 缺失openID 参数",
        @"100005" : @"code 效验失败或者过期",
        @"100006" : @"sdk 请求错误",
        @"100007" : @"sdk 参数错误",
        @"100008" : @"数据库查询错误",
        @"100009" : @"数据库插入错误",
        @"100010" : @"数据库修改错误",
        // 业务错误
        @"100100" : @"登陆错误",
        @"100200" : @"加入房间错误",
        @"100201" : @"战斗时房间不能加入",
        @"100202" : @"房间人数已满",
        @"100203" : @"重复加入",
        @"100204" : @"位置上有人",
        @"100300" : @"退出错误",
        @"100301" : @"不在游戏位",
        @"100302" : @"准备或游戏状态不能退出",
        @"100400" : @"准备错误",
        @"100401" : @"取消准备错误",
        @"100500" : @"开始游戏错误",
        @"100501" : @"游戏已开始",
        @"100502" : @"队长才能开始游戏",
        @"100503" : @"有人未准备",
        @"100504" : @"开始游戏的人数不足",
        @"100600" : @"踢人错误",
        @"100601" : @"队长才能踢人",
        @"100602" : @"战斗房间不能踢人",
        @"100700" : @"换队长错误",
        @"100800" : @"逃跑错误",
        @"100801" : @"逃跑时游戏已结束",
        @"100802" : @"逃跑时玩家已不在游戏中",
        @"100900" : @"解散错误",
        @"100901" : @"解散时游戏已结束",
        @"100902" : @"队长才能解散",
    };
}

+ (NSArray <NSString *>*)getDisPlayAppIds {
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < [self getAppIds].count; i ++) {
        NSString * string = [NSString stringWithFormat:@"appId:%@",[self getAppIds][i]];
        [array addObject:string];
    }
    return [array copy];
}

+ (NSArray <NSString *>*)getAppIds {
    return @[APP_ID];
}

+ (NSArray <NSString *>*)getAppKeys {
    return @[APP_KEY];
}

+ (NSArray *)getLanguages {
    return @[@"zh-CN", @"zh-HK", @"zh-MO", @"zh-SG", @"zh-TW", @"en-US", @"en-GB", @"ms-BN", @"ms-MY", @"vi-VN", @"th-TH", @"ko-KR", @"ja-JP", @"es-ES", @"id-ID", @"ar-SA", @"zh-zh"];
}

+ (NSArray *)getGameNames {
    NSArray * gameNameArray = @[@"碰碰我最强", @"飞镖达人", @"你画我猜", @"五子棋", @"飞行棋", @"黑白棋", @"短道速滑", @"数字转轮", @"石头剪刀布", @"数字炸弹"];
    return gameNameArray;
}

/// 这个需要释放，否则内存泄漏
+ (int64_t *)getGameIds {
    int64_t gameMgIdArray[] = {MG_ID_BUMPER, MG_ID_KNIFE, MG_ID_DRAW_AND_GUESS, MG_ID_GOBANG, MG_ID_LUDO, MG_ID_REVERSI, MG_ID_SKATING, MG_ID_ROLL, MG_ID_RSP, MG_ID_NUMBER_BOMB};
    NSInteger size = [self getGameNames].count * sizeof(int64_t);
    int64_t * result = malloc(size);
    memcpy(result, gameMgIdArray, size);
    return result;
}

+ (uint64_t)getMgIdByGameName:(NSString *)gameName {
    NSArray <GameLoadModel *>* gameModels = [self getGameModels];
    for (NSUInteger i = 0; i < gameModels.count; i ++) {
        GameLoadModel * gameModel = gameModels[i];
        if ([gameModel.gameName isEqual:gameName]) {
            return gameModel.mgId;
        }
    }
    return 0;
}

+ (NSArray <GameLoadModel *>*)getGameModels {
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSArray * gameNameArray = [self getGameNames];
    int64_t * gameMgIdArray = [self getGameIds];
    for (NSUInteger i = 0; i < gameNameArray.count; i ++) {
        GameLoadModel * model = [[GameLoadModel alloc]init];
        model.gameName = gameNameArray[i];
        model.mgId = gameMgIdArray[i];
        [array addObject:model];
    }
    free(gameMgIdArray);
    return array;
}


@end
