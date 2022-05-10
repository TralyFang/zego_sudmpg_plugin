//
//  GameUIConfigurationModel.m
//  HelloSud-iOS
//
//  Created by mihuasama on 2021/12/10.
//

#import "GameUIConfigurationModel.h"

@interface GameUIConfigurationModel ()
@end

@implementation GameUIConfigurationModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (GameUIConfigurationModel *)getDefaultModel {
    GameUIConfigurationModel * model = [[GameUIConfigurationModel alloc]init];
    [model nodesInit];
    return model;
}

- (void)nodesInit {
        
    GameUIConfigurationNodeModel * notifyCustomUI = [[GameUIConfigurationNodeModel alloc]init];
    notifyCustomUI.paramName = @"HelloSud 配置";
    notifyCustomUI.type = GameUIConfigurationNodeType_Notify;
    
    /// lobby_players
    GameUIConfigurationNodeModel * CustomVCOperationViewType = [[GameUIConfigurationNodeModel alloc]init];
    CustomVCOperationViewType.paramName = @"CustomView操作按钮添加相关逻辑";
    CustomVCOperationViewType.type = GameUIConfigurationNodeType_Select;
    CustomVCOperationViewType.subNodes = @[[self getSubNodeWithParamName:@"是否添加" state:true]];

    /// roomID
    GameUIConfigurationNodeModel * roomID = [[GameUIConfigurationNodeModel alloc]init];
    roomID.paramName = @"修改房间号";
    roomID.type = GameUIConfigurationNodeType_Input;
    roomID.value = @"9009";
    
    GameUIConfigurationNodeModel * notifyOnGetGameCfg = [[GameUIConfigurationNodeModel alloc]init];
    notifyOnGetGameCfg.paramName = @"游戏配置，通过onGetGameCfg配置";
    notifyOnGetGameCfg.type = GameUIConfigurationNodeType_Notify;
    
    /// gameCPU    0为默认，1为开启低功耗模式
    GameUIConfigurationNodeModel * gameCPU = [[GameUIConfigurationNodeModel alloc]init];
    gameCPU.paramName = @"gameCPU";
    gameCPU.type = GameUIConfigurationNodeType_Input;
    gameCPU.value = @"0";
    
    /// gameMode
    GameUIConfigurationNodeModel * gameMode = [[GameUIConfigurationNodeModel alloc]init];
    gameMode.paramName = @"gameMode";
    gameMode.type = GameUIConfigurationNodeType_Input;
    gameMode.value = @"1";
    
    /// gameSoundControl
    GameUIConfigurationNodeModel * gameSoundControl = [[GameUIConfigurationNodeModel alloc]init];
    gameSoundControl.paramName = @"gameSoundControl";
    gameSoundControl.type = GameUIConfigurationNodeType_Input;
    gameSoundControl.value = @"0";
    
    /// gameSoundVolume
    GameUIConfigurationNodeModel * gameSoundVolume = [[GameUIConfigurationNodeModel alloc]init];
    gameSoundVolume.paramName = @"gameSoundVolume";
    gameSoundVolume.type = GameUIConfigurationNodeType_Input;
    gameSoundVolume.value = @"100";
    
    /// gameSettle
    GameUIConfigurationNodeModel * gameSettle = [self getDefaultSelectNodeWithParamName:@"gameSettle"
                                                                               subNodes:[self getSubNodesHide:NO]];
    
    /// ping
    GameUIConfigurationNodeModel * ping = [self getDefaultSelectNodeWithParamName:@"ping"
                                                                               subNodes:[self getSubNodesHide:NO]];
    
    /// version
    GameUIConfigurationNodeModel * version = [self getDefaultSelectNodeWithParamName:@"version"
                                                                            subNodes:[self getSubNodesHide:NO]];
    
    /// level
    GameUIConfigurationNodeModel * level = [self getDefaultSelectNodeWithParamName:@"level"
                                                                          subNodes:[self getSubNodesHide:NO]];
    
    /// lobby_setting_btn
    GameUIConfigurationNodeModel * lobby_setting_btn = [self getDefaultSelectNodeWithParamName:@"lobby_setting_btn"
                                                                                      subNodes:[self getSubNodesHide:NO]];
    
    /// lobby_help_btn
    GameUIConfigurationNodeModel * lobby_help_btn = [self getDefaultSelectNodeWithParamName:@"lobby_help_btn"
                                                                          subNodes:[self getSubNodesHide:NO]];
    
    /// lobby_players 游戏座位
    GameUIConfigurationNodeModel * lobby_players = [self getDefaultSelectNodeWithParamName:@"lobby_players"
                                                                                  subNodes:[self getPlayersSubNodesCustom:NO hide:NO]];
    
    /// lobby_player_captain_icon
    GameUIConfigurationNodeModel * lobby_player_captain_icon = [self getDefaultSelectNodeWithParamName:@"lobby_player_captain_icon"
                                                                                              subNodes:[self getSubNodesHide:NO]];
    
    /// lobby_player_kickout_icon
    GameUIConfigurationNodeModel * lobby_player_kickout_icon = [self getDefaultSelectNodeWithParamName:@"lobby_player_kickout_icon"
                                                                                              subNodes:[self getSubNodesHide:NO]];
    
    /// lobby_rule
    GameUIConfigurationNodeModel * lobby_rule = [self getDefaultSelectNodeWithParamName:@"lobby_rule"
                                                                               subNodes:[self getSubNodesHide:NO]];
    
    /// lobby_game_setting
    GameUIConfigurationNodeModel * lobby_game_setting = [self getDefaultSelectNodeWithParamName:@"lobby_game_setting"
                                                                                       subNodes:[self getSubNodesHide:NO]];
    
    /// join_btn
    GameUIConfigurationNodeModel * join_btn = [self getDefaultSelectNodeWithParamName:@"join_btn"
                                                                             subNodes:[self getSubNodesCustom:NO hide:NO]];
    
    /// cancel_join_btn
    GameUIConfigurationNodeModel * cancel_join_btn = [self getDefaultSelectNodeWithParamName:@"cancel_join_btn"
                                                                                    subNodes:[self getSubNodesCustom:NO hide:NO]];
    
    /// ready_btn
    GameUIConfigurationNodeModel * ready_btn = [self getDefaultSelectNodeWithParamName:@"ready_btn"
                                                                              subNodes:[self getSubNodesCustom:NO hide:NO]];
    
    /// cancel_ready_btn
    GameUIConfigurationNodeModel * cancel_ready_btn = [self getDefaultSelectNodeWithParamName:@"cancel_ready_btn"
                                                                                     subNodes:[self getSubNodesCustom:NO hide:NO]];
    
    /// start_btn
    GameUIConfigurationNodeModel * start_btn = [self getDefaultSelectNodeWithParamName:@"start_btn"
                                                                              subNodes:[self getSubNodesCustom:NO hide:NO]];
    
    /// share_btn
    GameUIConfigurationNodeModel * share_btn = [self getDefaultSelectNodeWithParamName:@"share_btn"
                                                                              subNodes:[self getSubNodesCustom:NO hide:YES]];
    
    /// game_setting_btn
    GameUIConfigurationNodeModel * game_setting_btn = [self getDefaultSelectNodeWithParamName:@"game_setting_btn"
                                                                                     subNodes:[self getSubNodesHide:NO]];
    
    /// game_help_btn
    GameUIConfigurationNodeModel * game_help_btn = [self getDefaultSelectNodeWithParamName:@"game_help_btn"
                                                                                  subNodes:[self getSubNodesHide:NO]];
    
    /// game_settle_close_btn
    GameUIConfigurationNodeModel * game_settle_close_btn = [self getDefaultSelectNodeWithParamName:@"game_settle_close_btn"
                                                                                  subNodes:[self getSubNodesCustom:NO]];
    
    /// game_settle_again_btn
    GameUIConfigurationNodeModel * game_settle_again_btn = [self getDefaultSelectNodeWithParamName:@"game_settle_again_btn"
                                                                                  subNodes:[self getSubNodesCustom:NO]];
    
    /// game_bg
    GameUIConfigurationNodeModel * game_bg = [self getDefaultSelectNodeWithParamName:@"game_bg"
                                                                                      subNodes:[self getSubNodesHide:NO]];


    self.nodes = @[ notifyCustomUI,
                    CustomVCOperationViewType,
                    roomID,
                    notifyOnGetGameCfg,
                    gameCPU,
                    gameMode,
                    gameSoundControl,
                    gameSoundVolume,
                    gameSettle,
                    ping,
                    version,
                    level,
                    lobby_setting_btn,
                    lobby_help_btn,
                    lobby_players,
                    lobby_player_captain_icon,
                    lobby_player_kickout_icon,
                    lobby_rule,
                    lobby_game_setting,
                    join_btn,
                    cancel_join_btn,
                    ready_btn,
                    cancel_ready_btn,
                    start_btn,
                    share_btn,
                    game_setting_btn,
                    game_help_btn,
                    game_settle_close_btn,
                    game_settle_again_btn,
                    game_bg,];
    
    
    _kNotifyCustomUI          = (int)[self.nodes indexOfObject:notifyCustomUI];
    _kNotifyOnGetGameCfg      = (int)[self.nodes indexOfObject:notifyOnGetGameCfg];
    _kGameMode                = (int)[self.nodes indexOfObject:gameMode];
    _kGameSettle              = (int)[self.nodes indexOfObject:gameSettle];
    _kGameCPU                 = (int)[self.nodes indexOfObject:gameCPU];
    _kRoomIdIndex             = (int)[self.nodes indexOfObject:roomID];
    _kOperationViewStyleIndex = (int)[self.nodes indexOfObject:CustomVCOperationViewType];
    _kGameSoundControl        = (int)[self.nodes indexOfObject:gameSoundControl];
    _kGameSoundVolume         = (int)[self.nodes indexOfObject:gameSoundVolume];
}

- (NSDictionary *)getDictionary {
    NSMutableDictionary * ui = [NSMutableDictionary dictionary];
    for (int i = _kGameSettle; i < self.nodes.count; i ++) {
        GameUIConfigurationNodeModel * node = self.nodes[i];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        for (int j = 0; j < node.subNodes.count; j ++) {
            GameUIConfigurationSubNodeModel * subNode = node.subNodes[j];
            [dic setObject:@(subNode.state) forKey:subNode.paramName];
        }
        [ui setObject:dic forKey:node.paramName];
    }
    
    return @{@"gameMode": @(self.nodes[_kGameMode].value.intValue),
             @"gameCPU": @(self.nodes[_kGameCPU].value.intValue),
             @"gameSoundControl": @(self.nodes[_kGameSoundControl].value.intValue),
             @"gameSoundVolume": @(self.nodes[_kGameSoundVolume].value.intValue),
             @"ui": ui,
             @"ret_code": @(0),
             @"ret_msg": @"success"};
}


- (GameUIConfigurationNodeModel *)getDefaultSelectNodeWithParamName:(NSString *)paramName subNodes:(NSArray *)subNodes {
    GameUIConfigurationNodeModel * node = [[GameUIConfigurationNodeModel alloc]init];
    node.paramName = paramName;
    node.type      = GameUIConfigurationNodeType_Select;
    node.subNodes  = subNodes;
    return node;
}

- (GameUIConfigurationSubNodeModel *)getSubNodeWithParamName:(NSString *)paramName state:(BOOL)state {
    GameUIConfigurationSubNodeModel * subNode = [[GameUIConfigurationSubNodeModel alloc]init];
    subNode.paramName = paramName;
    subNode.state     = YES; //state; // 修改成全部关闭状态
    return subNode;
}

- (NSArray *)getSubNodesCustom:(BOOL)custom hide:(BOOL)hide {
    GameUIConfigurationSubNodeModel * customNode = [self getSubNodeWithParamName:@"custom" state:custom];
    GameUIConfigurationSubNodeModel * hideNode = [self getSubNodeWithParamName:@"hide" state:hide];
    return @[customNode, hideNode];
}
- (NSArray *)getPlayersSubNodesCustom:(BOOL)custom hide:(BOOL)hide {
    GameUIConfigurationSubNodeModel * customNode = [self getSubNodeWithParamName:@"custom" state:custom];
    GameUIConfigurationSubNodeModel * hideNode = [self getSubNodeWithParamName:@"hide" state:hide];
    // 单独设置状态
//    customNode.state = custom;
//    hideNode.state = hide;
    return @[customNode, hideNode];
}

- (NSArray *)getSubNodesHide:(BOOL)hide {
    GameUIConfigurationSubNodeModel * hideNode = [self getSubNodeWithParamName:@"hide" state:hide];
    return @[hideNode];
}

- (NSArray *)getSubNodesCustom:(BOOL)custom {
    GameUIConfigurationSubNodeModel * customNode = [self getSubNodeWithParamName:@"custom" state:custom];
    return @[customNode];
}

@end

@interface GameUIConfigurationNodeModel ()
@end
@implementation GameUIConfigurationNodeModel
@end


@interface GameUIConfigurationSubNodeModel ()
@end
@implementation GameUIConfigurationSubNodeModel
@end
