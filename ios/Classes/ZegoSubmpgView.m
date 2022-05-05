//
//  ZegoSubmpgView.m
//  zego_sudmpg_plugin
//
//  Created by TralyFang on 2022/3/30.
//

#import "ZegoSubmpgView.h"
#import "GameView.h"
#import "ZegoMGManager.h"
#import "GameUtils.h"

@implementation ZegoSubmpgView
{
    GameView *_gameView;
}

-(instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([super init]) {
        
        /// 需要外部传过来的必须参数
//        ZegoMGManager.instance.roomId = params["roomId"].toString()
//        ZegoMGManager.instance.userId = params["userId"].toString()
//        ZegoMGManager.instance.APP_Code = params["appCode"].toString()
//        ZegoMGManager.instance.mMGID = params["mgId"].toString().toLongOrNull() ?:SudMGCfg.MG_ID_BUMPER_CAR
        
        
        FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"zego_sudmpg_plugin/gameView" binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [channel setMethodCallHandler:^(FlutterMethodCall *  call, FlutterResult  result) {
            [weakSelf onMethodCall:call result:result];
        }];
        
        _gameView = [[GameView alloc] initWithFrame:frame channel:channel];
    }
    return self;
}
- (nonnull UIView *)view {
    return _gameView;
}
- (void)alloc {
    
}

-(void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSLog(@"onMethodCall===%@===%@",[call method], [call arguments]);
    
    if ([call.method isEqualToString:MG_SELF_IN]) {// 加入游戏
        NSDictionary *dict = [call arguments];
        bool isIn = false;
        if ([dict objectForKey:@"isIn"]) {
            isIn = [[dict objectForKey:@"isIn"] boolValue];
        }
        int seatIndex = -1;
        if ([dict objectForKey:@"seatIndex"]) {
            seatIndex = [[dict objectForKey:@"seatIndex"] intValue];
        }
        [_gameView notifySelfInState:isIn seatIndex:seatIndex];
        
    }else if ([call.method isEqualToString:MG_SELF_READY]) {// 准备游戏
        NSDictionary *dict = [call arguments];
        bool isReady = false;
        if ([dict objectForKey:@"isReady"]) {
            isReady = [[dict objectForKey:@"isReady"] boolValue];
        }
        [_gameView notifySetReady:isReady];
        
    }else if ([call.method isEqualToString:MG_SELF_PLAYING]) {// 开始游戏
        NSDictionary *dict = [call arguments];
        bool isReady = false;
        if ([dict objectForKey:@"isPlaying"]) {
            isReady = [[dict objectForKey:@"isPlaying"] boolValue];
        }
        [_gameView notifyIsPlayingState:isReady];
        
    }else if ([call.method isEqualToString:MG_SELF_CAPTAIN]) {// 设置队长
        NSDictionary *dict = [call arguments];
        NSString *userId = [[dict objectForKey:@"captainUserId"] stringValue];
        [_gameView notifySetCaptainStateWithUserId:userId];
        
    }else if ([call.method isEqualToString:MG_SELF_KICK]) {// 踢人
        NSDictionary *dict = [call arguments];
        NSString *userId = [[dict objectForKey:@"kickUserId"] stringValue];
        [_gameView notifyKickStateWithUserId:userId];
    }else if ([call.method isEqualToString:MG_SELF_END]) { // 结束游戏
        [_gameView notifySetEnd];
    }
}


@end
