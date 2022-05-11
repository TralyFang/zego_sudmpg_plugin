//
//  ZegoMGManager.m
//  zego_sudmpg_plugin
//
//  Created by TralyFang on 2022/3/30.
//

#import "ZegoMGManager.h"
#import "AppConfig.h"
#import "Common.h"

@interface ZegoMGManager ()

@end

@implementation ZegoMGManager

+ (instancetype)instance {
    static ZegoMGManager *p = nil ;//1.声明一个空的静态的单例对象
    static dispatch_once_t onceToken; //2.声明一个静态的gcd的单次任务
    dispatch_once(&onceToken, ^{ //3.执行gcd单次任务：对对象进行初始化
        if (p == nil) {
            p = [[ZegoMGManager alloc]init];
        }
    });
  return p;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _roomId = mRoomID;
        _userId = [Common getUserName];
        _mgId = MG_ID_BUMPER;
        _language = @"en-US";
        _appId = APP_ID;
        _appKey = APP_KEY;
        _APP_Code = @"";
        _isTestEnv = kIsTestEnv;
        _gameViewTop = _gameViewBottom = 110;
    }
    return self;
}

@end
