//
//  GameUIConfigurationModel.h
//  HelloSud-iOS
//
//  Created by mihuasama on 2021/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//#define kOperationViewStyleIndex 1
//#define kRoomIdIndex 2
//#define kGameCPU     4
//#define kGameMode    5

typedef NS_ENUM(NSUInteger, GameUIConfigurationNodeType) {
    GameUIConfigurationNodeType_Input,
    GameUIConfigurationNodeType_Select,
    GameUIConfigurationNodeType_Notify,
};

@interface GameUIConfigurationSubNodeModel : NSObject
@property (nonatomic, copy)             NSString * paramName;
@property (nonatomic, assign)           BOOL       state;
@end

@interface GameUIConfigurationNodeModel : NSObject
@property (nonatomic, copy)   NSString                                    * paramName;
@property (nonatomic, assign) GameUIConfigurationNodeType                   type;
@property (nonatomic, strong) NSArray <GameUIConfigurationSubNodeModel* > * subNodes;
@property (nonatomic, copy)   NSString                                    * value;
@end

@interface GameUIConfigurationModel : NSObject
@property (nonatomic, assign, readonly) int        kNotifyCustomUI;
@property (nonatomic, assign, readonly) int        kNotifyOnGetGameCfg;
@property (nonatomic, assign, readonly) int        kOperationViewStyleIndex;
@property (nonatomic, assign, readonly) int        kRoomIdIndex;
@property (nonatomic, assign, readonly) int        kGameSettle;
@property (nonatomic, assign, readonly) int        kGameMode;
@property (nonatomic, assign, readonly) int        kGameCPU;
@property (nonatomic, assign, readonly) int        kGameSoundControl;
@property (nonatomic, assign, readonly) int        kGameSoundVolume;
@property (nonatomic, strong) NSArray <GameUIConfigurationNodeModel* > * nodes;
+ (GameUIConfigurationModel *)getDefaultModel;
- (NSDictionary *)getDictionary;
@end





NS_ASSUME_NONNULL_END
