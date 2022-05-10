//
//  ZegoMGManager.h
//  zego_sudmpg_plugin
//
//  Created by TralyFang on 2022/3/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZegoMGManager : NSObject
@property (nonatomic, copy)   NSString *            roomId;
/// 当前用户的游戏id
@property (nonatomic, copy)   NSString *            userId;
/// 当前用户登录的code
@property (nonatomic, copy)   NSString *            APP_Code;
@property (nonatomic, copy)   NSString                 * APP_Code_expireDate;

@property (nonatomic, copy)   NSString                 * appId;
@property (nonatomic, copy)   NSString                 * appKey;
@property (nonatomic, assign) int64_t                    mgId;
@property (nonatomic, copy)   NSString                 * language;
@property (nonatomic, assign) BOOL                      isTestEnv;
// 游戏缩进的安全边距
@property (nonatomic, assign) double gameViewTop;
@property (nonatomic, assign) double  gameViewBottom;
/// 游戏UI配置
//@property (nonatomic, strong) GameUIConfigurationModel * configurationModel;


+ (instancetype)instance;
@end

NS_ASSUME_NONNULL_END
