//
//  GameView.h
//  zego_sudmpg_plugin
//
//  Created by TralyFang on 2022/3/30.
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>


NS_ASSUME_NONNULL_BEGIN

@interface GameView : UIView

- (instancetype)initWithFrame:(CGRect)frame channel:(FlutterMethodChannel *)channel;

/// 加入,退出游戏
/// @param isIn YES:加入 NO:退出 seatIndex:座位号
- (void)notifySelfInState:(BOOL)isIn seatIndex:(int)seatIndex;
/// 踢出用户
/// @param userId 踢出用户id
- (void)notifyKickStateWithUserId:(NSString *)userId;
/// 设置用户为队长
/// @param userId 被设置用户id
- (void)notifySetCaptainStateWithUserId:(NSString *)userId;
/// 是否设置为准备状态
- (void)notifySetReady:(BOOL)isReady;
/// 停止游戏状态设置
- (void)notifySetEnd;
/// 游戏中状态设置
- (void)notifyIsPlayingState:(BOOL)isPlaying;
@end

NS_ASSUME_NONNULL_END
