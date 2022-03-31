//
//  ZegoSubmpgFactory.h
//  zego_sudmpg_plugin
//
//  Created by TralyFang on 2022/3/30.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZegoSubmpgFactory : NSObject<FlutterPlatformViewFactory>

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messager;


@end

NS_ASSUME_NONNULL_END
