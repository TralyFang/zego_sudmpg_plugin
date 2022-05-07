//
//  GameView.m
//  zego_sudmpg_plugin
//
//  Created by TralyFang on 2022/3/30.
//

#import "GameView.h"
/// SudMGPSDK
#import <SudMGP/ISudFSMMG.h>
#import <SudMGP/ISudFSTAPP.h>
#import <SudMGP/SudMGP.h>
#import <SudMGP/ISudFSMStateHandle.h>

#import "ZegoMGManager.h"
#import "Common.h"
#import "AppConfig.h"
#import "GameUtils.h"
#import "GameUIConfigurationModel.h"

@interface GameView () <ISudFSMMG>
{
    FlutterMethodChannel *_channel;
    int _retryCount;// 重试次数，最多3次
}
@property (nonatomic, strong) id<ISudFSTAPP>        fsmAPP2MG;
/// 错误码表
@property (nonatomic, strong) NSDictionary *        errorMap;
@end

@implementation GameView
#pragma mark - ======= Init =======
/**
 * 初始化游戏SDK
 *
 * @param appID          NSString        项目的appID
 * @param appKey         NSString        项目的appKey
 * @param isTestEnv      Boolean         是否是测试环境，true:测试环境, false:正式环境
 * @param mgID           NSInteger       游戏ID，如 碰碰我最强:1001；飞刀我最强:1002；你画我猜:1003
 */
- (void)initGameSDKWithAppID:(NSString *)appID appKey:(NSString *)appKey isTestEnv:(Boolean)isTestEnv mgID:(int64_t)mgID {
    [SudMGP initSDK:appID appKey:appKey isTestEnv:isTestEnv listener:^(int retCode, const NSString *retMsg) {
        if (retCode == 0) {
            
            NSLog(@"ISudFSMMG:initGameSDKWithAppID:初始化游戏SDK成功");
            
//            UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
            
            // SudMGPSDK初始化成功 加载MG
            [self loadMG:ZegoMGManager.instance.userId roomId:ZegoMGManager.instance.roomId code:ZegoMGManager.instance.APP_Code mgId: mgID language:ZegoMGManager.instance.language fsmMG:self rootView:self];
        } else {
            /// 初始化失败, 可根据业务重试
            NSLog(@"ISudFSMMG:initGameSDKWithAppID:初始化游戏SDK失败:%d retMsg=%@", retCode, retMsg);
        }
    }];
}

#pragma mark - ======= LifeCycle =======



- (instancetype)initWithFrame:(CGRect)frame channel:(FlutterMethodChannel *)channel {
    
    self = [super initWithFrame:frame];
    /// 错误码表初始化
    self.errorMap = [Common getErrorMap];
    _channel = channel;
    
    
    [self gameSetup];
    /// TODO: 这里需要去掉，直接使用我们的服务器生成的code
//    /// 登录到接入方服务器
//    _retryCount = 0;
//    [self login];
    
    return self;
    
}

- (void)login {
//    if (_retryCount >= 3) {
//        return;
//    }
//    [Common loginWithUserId:ZegoMGManager.instance.userId resultCallbckBlock:^(NSString * _Nonnull code, NSError * _Nonnull error, int retCode) {
//        if (retCode == 0) {
//            NSLog(@"ISudFSMMG:loginWithUserId:登录到接入方服务器成功！");
//            ZegoMGManager.instance.APP_Code = code;
//            [self gameSetup];
//        }else {
//            NSLog(@"ISudFSMMG:loginWithUserId:登录到接入方服务器失败:%@",error);
//            self->_retryCount ++;
//            [self login];
//        }
//    }];
}

#pragma mark - ======= Delegate =======

#pragma mark =======ISudFSMMG Delegate=======
/**
 * 游戏日志
 */
-(void)onGameLog:(NSString*)dataJson {
    NSLog(@"ISudFSMMG:onGameLog:%@", dataJson);
    NSDictionary * dic = [Common turnStringToDictionary:dataJson];
    [self handleRetCode:[dic objectForKey:@"errorCode"] errorMsg:[dic objectForKey:@"msg"]];
}

/**
 * 游戏开始
 */
-(void)onGameStarted {
    NSLog(@"ISudFSMMG:onGameStarted:游戏开始");
}

/**
 * 游戏销毁
 */
-(void) onGameDestroyed {
    NSLog(@"ISudFSMMG:onGameDestroyed:游戏开始");
}

/**
 * Code过期
 * @param dataJson {"code":"value"}
 */
-(void)onExpireCode:(id<ISudFSMStateHandle>)handle dataJson:(NSString*)dataJson {
    NSLog(@"ISudFSMMG:onExpireCode:Code过期");
    
    [_channel invokeMethod:MG_EXPIRE_APP_CODE arguments:@"" result:^(id  _Nullable result) {
        NSString *code = result;
        
        [self updateGameCode:code];
    }];
    
    /// TODO: Code更新
    // 请求业务服务器刷新令牌
    
    /// 不能copy此代码，接入时需要刷新使用新的令
    [Common loginWithUserId:ZegoMGManager.instance.userId resultCallbckBlock:^(NSString * _Nonnull code, NSError * _Nonnull error, int retCode) {
        
        if (error) {
            NSLog(@"ISudFSMMG:onExpireCode:获取code失败");
            return;
        }
        // 调用小游戏接口更新令牌
        [self updateGameCode:code];
    }];
    // 回调结果
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(0), @"ret_code", @"success", @"ret_msg", nil];
    [handle success:[Common dictionaryToJson:dict]];
}

/**
 * 获取游戏View信息
 * @param handle 回调句柄
 * @param dataJson {}
 */
-(void)onGetGameViewInfo:(id<ISudFSMStateHandle>)handle dataJson:(NSString*)dataJson {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat scale = [[UIScreen mainScreen] nativeScale];
    
    CGFloat top = 110 * scale;
    CGFloat width = rect.size.width * scale;
    CGFloat height = rect.size.height * scale;
    NSDictionary *rectDict = [NSDictionary dictionaryWithObjectsAndKeys:@(top), @"top", @(0), @"left", @(top), @"bottom", @(0), @"right", nil];
    NSDictionary *viewDict = [NSDictionary dictionaryWithObjectsAndKeys:@(width), @"width", @(height), @"height", nil];
    NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@(0), @"ret_code", @"return form APP onGetGameViewInfo", @"ret_msg", viewDict, @"view_size", rectDict, @"view_game_rect", nil];
    /// 回调
    [handle success:[Common dictionaryToJson:dataDict]];
}

/**
 * 获取游戏配置
 * @param handle 回调句柄
 * @param dataJson {}
 */
-(void)onGetGameCfg:(id<ISudFSMStateHandle>)handle dataJson:(NSString*)dataJson {
    
    NSLog(@"onGetGameCfg===%@", dataJson);
    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    dict[@"ret_code"] = @(0);
//    dict[@"ret_msg"] = @"return form APP onGetGameCfg";
    NSDictionary * dict = [GameUIConfigurationModel getDefaultModel].getDictionary;
    NSString *dataJsonRet = @"";
    NSData *dataJsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    if (dataJsonData != nil) {
        dataJsonRet = [[NSString alloc]initWithData:dataJsonData encoding:NSUTF8StringEncoding];
    }
    [handle success:dataJsonRet];
}

/**
 * 游戏状态变化
 * @param handle 回调句柄
 * @param state 游戏状态
 * @param dataJson 回调json
 */
-(void)onGameStateChange:(id<ISudFSMStateHandle>) handle state:(NSString*) state dataJson:(NSString*) dataJson {
    NSLog(@"ISudFSMMG:onGameStateChange:游戏->APP:state:%@",state);
}

/**
 * 游戏玩家状态变化
 * @param handle 回调句柄
 * @param userId 用户id
 * @param state  玩家状态
 * @param dataJson 回调JSON
 */
-(void)onPlayerStateChange:(nullable id<ISudFSMStateHandle>) handle userId:(NSString*) userId state:(NSString*) state dataJson:(NSString*) dataJson {
    NSLog(@"ISudFSMMG:onPlayerStateChange:游戏->APP:游戏玩家状态变化:userId: %@ --state: %@ --dataJson: %@", userId, state, dataJson);

    /// 状态解析
    NSString *dataStr = @"";
    if ([state isEqualToString:MG_COMMON_PLAYER_IN]) {
        dataStr = @"玩家: 加入状态";
        [self handleState_MG_COMMON_PLAYER_IN_WithUserId:userId dataJson:dataJson];
    } else if ([state isEqualToString:MG_COMMON_PLAYER_READY]) {
        dataStr = @"玩家: 准备状态";
        [self handleState_MG_COMMON_PLAYER_READY_WithUserId:userId dataJson:dataJson];
    } else if ([state isEqualToString:MG_COMMON_PLAYER_CAPTAIN]) {
        dataStr = @"玩家: 队长状态";
        [self handleState_MG_COMMON_PLAYER_CAPTAIN_WithUserId:userId dataJson:dataJson];
    } else if ([state isEqualToString:MG_COMMON_PLAYER_PLAYING]) {
        dataStr = @"玩家: 游戏状态";
        [self handleState_MG_COMMON_PLAYER_PLAYING_WithUserId:userId dataJson:dataJson];
    } else if ([state isEqualToString:MG_DG_SELECTING]) {
        dataStr = @"你画我猜 玩家: 选词中";
        [self handleState_MG_DG_SELECTING_WithUserId:userId dataJson:dataJson];
    } else if ([state isEqualToString:MG_DG_PAINTING]) {
        dataStr = @"你画我猜 玩家: 作画中";
        [self handleState_MG_DG_PAINTING_WithUserId:userId dataJson:dataJson];
    } else if ([state isEqualToString:MG_DG_ERRORANSWER]) {
        dataStr = @"你画我猜 玩家: 错误答";
        [self handleState_MG_DG_ERRORANSWER_WithUserId:userId dataJson:dataJson];
    } else if ([state isEqualToString:MG_DG_TOTALSCORE]) {
        dataStr = @"你画我猜 玩家: 总积分";
        [self handleState_MG_DG_TOTALSCORE_WithUserId:userId dataJson:dataJson];
    } else if ([state isEqualToString:MG_DG_SCORE]) {
        dataStr = @"你画我猜 玩家: 本次积分";
        [self handleState_MG_DG_SCORE_WithUserId:userId dataJson:dataJson];
    }else {
        NSLog(@"ISudFSMMG:onPlayerStateChange:未做解析状态:%@", MG_DG_SCORE);
    }
    NSLog(@"ISudFSMMG:onPlayerStateChange:dataStr:%@", dataStr);
    /// 回调
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(0), @"ret_code", @"return form APP onPlayerStateChange", @"ret_msg", nil];
    [handle success:[Common dictionaryToJson:dict]];
}

#pragma mark - ======= Get&&Set =======
- (void)gameSetup {
    ///初始化游戏sdk
    [self initGameSDKWithAppID:ZegoMGManager.instance.appId appKey:ZegoMGManager.instance.appKey isTestEnv:ZegoMGManager.instance.isTestEnv mgID:ZegoMGManager.instance.mgId];
    
    /// 子视图设置
    [self subViewSetup];
    
    /// 加入游戏
    [self notifySelfInState:YES seatIndex:-1];
}

- (void)gameUnsetup {
    [self destroyMG];
    [self subViewUnSetup];
}

- (void)subViewSetup {
    [self seatViewSetup];
    [self publicMessageViewSetup];
    [self envLabelSetup];
    [self hideBtnSetup];
}

- (void)subViewUnSetup {
    
}

- (void)envLabelSetup {

}

- (void)hideBtnSetup {

}

/// 麦位View设置
- (void)seatViewSetup {

}

/// 公屏消息View设置
- (void)publicMessageViewSetup {

}


#pragma mark - ======= Target Action =======
- (void)onHitButtonClick:(id)sender {
    [self notifyChangeTextHitState];
}

- (void)backButtonClick:(UIButton *)btn {
    [self destroyMG];
}

#pragma mark - ======= Public =======
#pragma mark - ======= Private =======

/// 销毁MG
- (void)destroyMG {
    [self.fsmAPP2MG destroyMG];
}
/// 加载游戏MG
/// @param userId 用户唯一ID
/// @param roomId 房间ID
/// @param code 游戏登录code
/// @param mgId 游戏ID
/// @param language 支持简体"zh-CN "    繁体"zh-TW"    英语"en-US"   马来"ms-MY"
/// @param fsmMG 控制器
/// @param rootView 游戏根视图
- (void)loadMG: (NSString *)userId roomId: (NSString *)roomId code: (NSString *)code mgId: (int64_t) mgId language: (NSString *)language fsmMG:(id)fsmMG rootView: (UIView*)rootView {
    self.fsmAPP2MG = [SudMGP loadMG:userId roomId:roomId code:code mgId:mgId language:language fsmMG:fsmMG rootView:rootView];
}

/// 更新code
/// @param code 新的code
- (void)updateGameCode:(NSString *)code {
    [self.fsmAPP2MG updateCode:code listener:^(int retCode, const NSString *retMsg, const NSString *dataJson) {
        NSLog(@"ISudFSMMG:updateGameCode retCode=%@ retMsg=%@ dataJson=%@", @(retCode), retMsg, dataJson);
    }];
}
#pragma mark =======处理返回消息=======
- (void)handleRetCode:(NSString *)retCode errorMsg:(NSString *)msg {
    
    NSLog(@"%@出错，错误码:%@", msg, retCode);

}
#pragma mark =======处理公屏消息=======
/// 处理公屏消息
/// @param json 公屏消息JSON
- (void)handlePublicMessage:(NSString *)json {
    if (!json) {
        return;
    }
    NSDictionary * dic = [Common turnStringToDictionary:json];
    NSLog(@"%@",dic);
    if (!dic) {
        NSLog(@"ISudFSMMG:handlePublicMessage error dic:%@",dic);
    }
}
#pragma mark =======APP->游戏状态处理=======
/// 状态通知（app to mg）
/// @param state 状态名称
/// @param dataJson 需传递的json
- (void)notifyStateChange:(NSString *) state dataJson:(NSString*) dataJson {
    [self.fsmAPP2MG notifyStateChange:state dataJson:dataJson listener:^(int retCode, const NSString *retMsg, const NSString *dataJson) {
        NSLog(@"ISudFSMMG:notifyStateChange:retCode=%@ retMsg=%@ dataJson=%@", @(retCode), retMsg, dataJson);
    }];
}

/// 加入,退出游戏
/// @param isIn YES:加入 NO:退出 seatIndex:座位号
- (void)notifySelfInState:(BOOL)isIn seatIndex:(int)seatIndex {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(seatIndex), @"seatIndex", @(isIn), @"isIn",@(YES), @"isSeatRandom", @(1), @"teamId", nil];
    [self notifyStateChange:APP_COMMON_SELF_IN dataJson:[Common dictionaryToJson:dic]];
}

/// 踢出用户
/// @param userId 踢出用户id
- (void)notifyKickStateWithUserId:(NSString *)userId {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"kickedUID", nil];
    [self notifyStateChange:APP_COMMON_SELF_KICK dataJson:[Common dictionaryToJson:dic]];
}

/// 设置用户为队长
/// @param userId 被设置用户id
- (void)notifySetCaptainStateWithUserId:(NSString *)userId {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"curCaptainUID", nil];
    [self notifyStateChange:APP_COMMON_SELF_CAPTAIN dataJson:[Common dictionaryToJson:dic]];
}

/// 命中 关键词状态 （你画我猜）
- (void)notifyChangeTextHitState {
}

/// 是否设置为准备状态
- (void)notifySetReady:(BOOL)isReady {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(isReady), @"isReady", nil];
    [self notifyStateChange:APP_COMMON_SELF_READY dataJson:[Common dictionaryToJson:dic]];
}

/// 停止游戏状态设置
- (void)notifySetEnd {
    [self notifyStateChange:APP_COMMON_SELF_END dataJson:[Common dictionaryToJson:@{}]];
}

/// 游戏中状态设置
- (void)notifyIsPlayingState:(BOOL)isPlaying extras:(NSString *)extras {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(isPlaying), @"isPlaying", nil];
    if (isPlaying && extras != nil) {
        [dic setValue:@"reportGameInfoExtras" forKey:extras];
    }
    [self notifyStateChange:APP_COMMON_SELF_PLAYING dataJson:[Common dictionaryToJson:dic]];
}

/// 打开或关闭背景音乐111111
- (void)notifyOpenMusic:(BOOL)isOpen {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(isOpen), @"isOpen", nil];
    [self notifyStateChange:APP_COMMON_OPEN_BG_MUSIC dataJson:[Common dictionaryToJson:dic]];
}

/// 打开或关闭游戏音效
- (void)notifyOpenSound:(BOOL)isOpen {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(isOpen), @"isOpen", nil];
    [self notifyStateChange:APP_COMMON_OPEN_SOUND dataJson:[Common dictionaryToJson:dic]];
    [self notifyOpenMusic:isOpen];
    [self notifyOpenVibrate:isOpen];
}

/// 打开或关闭手机震动
- (void)notifyOpenVibrate:(BOOL)isOpen {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(isOpen), @"isOpen", nil];
    [self notifyStateChange:APP_COMMON_OPEN_VIBRATE dataJson:[Common dictionaryToJson:dic]];
}

#pragma mark =======游戏->APP状态处理=======
- (void)handleState_MG_COMMON_PLAYER_IN_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    
    NSDictionary * dic = [Common turnStringToDictionary:dataJson];
    /// 加入状态：YES加入，NO退出
    BOOL isIn = NO;
    if (dic) {
        NSInteger retCode = [[dic objectForKey:@"retCode"] integerValue];
        if (retCode != 0) {
            [self handleRetCode:[NSString stringWithFormat:@"%ld",(long)retCode] errorMsg:MG_COMMON_PLAYER_IN];
            return;
        }
        isIn = [[dic objectForKey:@"isIn"] boolValue];
    }
    [_channel invokeMethod:MG_JOIN_USERID arguments:@{@"userId":userId, @"isIn": @(isIn)}];
    if (isIn) {
        /// 是否是当前用户的userid
        BOOL isCurrent = NO;
        if ([ZegoMGManager.instance.userId isEqual: userId]) {
            isCurrent = YES;
        }
        /// 加入麦位,只要是用户就加入id，内部做去重
//        [self.seatView insertSeatWithUserId:userId currentUser:isCurrent];
        /// 玩家加入
//        [self.seatView setUserId:userId seatState:SeatState_prepare];
    }else {
        /// 离开麦位
//        [self.seatView removeSeatWithUserId:userId];
    }
}

- (void)handleState_MG_COMMON_PLAYER_READY_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    /// 玩家是否准备,YES:已准备，NO:未准备
    BOOL isReady = NO;
    NSDictionary * dic = [Common turnStringToDictionary:dataJson];
    if (dic) {
        NSInteger retCode = [[dic objectForKey:@"retCode"] integerValue];
        if (retCode != 0) {
            [self handleRetCode:[NSString stringWithFormat:@"%ld",(long)retCode] errorMsg:MG_COMMON_PLAYER_READY];
            return;
        }
        isReady = [[dic objectForKey:@"isReady"] boolValue];
    }
    if (isReady) {
//        [self.seatView setUserId:userId seatState:SeatState_prepared];
    }else {
//        [self.seatView setUserId:userId seatState:SeatState_prepare];
    }
}

- (void)handleState_MG_COMMON_PLAYER_CAPTAIN_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    /// 是否是队长：YES：是队长 NO：不是队长
    BOOL isCaptain = NO;
    NSDictionary * dic = [Common turnStringToDictionary:dataJson];
    if (dic) {
        /// 错误处理
        NSInteger retCode = [[dic objectForKey:@"retCode"] integerValue];
        if (retCode != 0) {
            [self handleRetCode:[NSString stringWithFormat:@"%ld",(long)retCode] errorMsg:MG_COMMON_PLAYER_CAPTAIN];
            return;
        }
        
        isCaptain = [[dic objectForKey:@"isCaptain"] boolValue];
    }
    
    /// 设置队长状态，需要修改麦位状态
//    [self.seatView setUserId:userId isCaptain:isCaptain];
}

- (void)handleState_MG_COMMON_PLAYER_PLAYING_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    /// 是否正在游戏中
    BOOL isPlaying = NO;
    NSDictionary * dic = [Common turnStringToDictionary:dataJson];
    if (dic) {
        /// 错误处理
        NSInteger retCode = [[dic objectForKey:@"retCode"] integerValue];
        if (retCode != 0) {
            [self handleRetCode:[NSString stringWithFormat:@"%ld",(long)retCode] errorMsg:MG_COMMON_PLAYER_PLAYING];
            return;
        }
        
        isPlaying = [[dic objectForKey:@"isPlaying"] boolValue];
    }
    if (isPlaying) {
//        [self.seatView setUserId:userId seatState:SeatState_Playing];
    }else {
        if ([ZegoMGManager.instance.userId isEqual: userId]) {
//            if (self.hitButton.alpha == 1) {
//                self.hitButton.alpha = 0;
//            }
        }
    }
}

- (void)handleState_MG_DG_SELECTING_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    /// 设置麦位状态为选词中
//    [self.seatView setUserId:userId seatState:SeatState_selecting];
}

- (void)handleState_MG_DG_PAINTING_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    /// 设置麦位状态为作画中
    NSDictionary * dic = [Common turnStringToDictionary:dataJson];
    bool isPainting = NO;
    if (dic) {
        isPainting = [dic[@"isPainting"] boolValue];
    }
    if (isPainting) {
//        [self.seatView setUserId:userId seatState:SeatState_painting];
    }else {
//        [self.seatView setUserId:userId seatState:SeatState_prepared];
    }
}

- (void)handleState_MG_DG_ERRORANSWER_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    /// 错误答案
}

- (void)handleState_MG_DG_TOTALSCORE_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    /// 总积分
}

- (void)handleState_MG_DG_SCORE_WithUserId:(NSString *)userId dataJson:(NSString *)dataJson {
    /// 本次积分
}

@end
