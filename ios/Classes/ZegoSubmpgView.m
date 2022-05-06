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
        if ([args isKindOfClass:[NSDictionary class]]) {
            NSDictionary *params = args;
            ZegoMGManager.instance.roomId = [[params valueForKey:@"roomId"] stringValue];
            ZegoMGManager.instance.userId = [[params valueForKey:@"userId"] stringValue];
            ZegoMGManager.instance.appId = [[params valueForKey:@"appId"] stringValue];
            ZegoMGManager.instance.appKey = [[params valueForKey:@"appKey"] stringValue];
            ZegoMGManager.instance.APP_Code = [[params valueForKey:@"APP_Code"] stringValue];
            ZegoMGManager.instance.APP_Code_expireDate = [[params valueForKey:@"expireDate"] stringValue];
            if ([params valueForKey:@"mgId"]) {
                ZegoMGManager.instance.mgId = [[params valueForKey:@"mgId"] longLongValue];
            }
        }
        NSLog(@"gameInit.params: %@, mgId: %lld, appCode: %@", args, ZegoMGManager.instance.mgId, ZegoMGManager.instance.APP_Code);

        
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
        // 添加透传jsonString
        NSString *extras = @"";
        if ([dict objectForKey:@"extras"]) {
            extras = [[dict objectForKey:@"extras"] stringValue];
        }
        [_gameView notifyIsPlayingState:isReady extras:extras];
        
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
    }else if ([call.method isEqualToString:MG_SELF_SOUND]) { // 关闭声音
        NSDictionary *dict = [call arguments];
        bool isOpen = false;
        if ([dict objectForKey:@"isOpen"]) {
            isOpen = [[dict objectForKey:@"isOpen"] boolValue];
        }
        [_gameView notifyOpenSound:isOpen];
    }
}


@end
