//
//  GameUtils.h
//  Pods
//
//  Created by TralyFang on 2022/3/30.
//

#ifndef GameUtils_h
#define GameUtils_h



/****************Native层->flutter层******************/
static NSString* MG_EXPIRE_APP_CODE      = @"mg_expire_app_code";// appCode过期回调，需要通知flutter获取最新code，去更新游戏code
static NSString* MG_JOIN_USERID          = @"mg_join_userId"; // 加入游戏的用户

/*******flutter层->Native层******************/
static NSString* MG_SELF_IN              = @"mg_self_in"; // 加入游戏
static NSString* MG_SELF_READY           = @"mg_self_ready"; // 准备游戏
static NSString* MG_SELF_PLAYING         = @"mg_self_playing"; // 开始游戏
static NSString* MG_SELF_KICK            = @"mg_self_kick"; // 踢人
static NSString* MG_SELF_CAPTAIN         = @"mg_self_captain"; // 设置队长
static NSString* MG_SELF_END             = @"mg_self_end"; // 结束游戏
static NSString* MG_DISPOSE              = @"mg_dispose"; // 退出游戏了
static NSString* MG_SELF_SOUND           = @"mg_self_sound"; // 打开游戏声音

#endif /* GameUtils_h */
