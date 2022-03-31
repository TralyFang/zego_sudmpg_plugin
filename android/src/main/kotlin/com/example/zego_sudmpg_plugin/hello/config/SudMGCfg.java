package com.example.zego_sudmpg_plugin.hello.config;/*
 * Copyright © Sud.Tech
 * https://sud.tech
 */

import android.content.Context;

import com.example.zego_sudmpg_plugin.R;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class SudMGCfg {
    public static final long MG_ID_BUMPER_CAR = 1461227817776713818L;//游戏ID:碰碰车
    public static final long MG_ID_FLY_CUTTER = 1461228379255603251L;//游戏ID:飞刀达人
    public static final long MG_ID_DRAW_GUESS = 1461228410184400899L;//游戏ID:你画我猜
    public static final long MG_ID_GO_BANG = 1461297734886621238L; //游戏ID:五子棋
    public static final long MG_ID_REVERSI = 1461297789198663710L;//游戏ID:黑白棋
    public static final long MG_ID_LUDO = 1468180338417074177L; //游戏ID:飞行棋
    public static final long MG_ID_SKATING = 1468090257126719572L; //游戏ID:短道速滑
    public static final long MG_ID_ROLL = 1468434637562912769L; //游戏ID:数字转轮
    public static final long MG_ID_RSP = 1468434723902660610L;  //游戏ID:石头剪刀布
    public static final long MG_ID_NUMBER_BOMB = 1468091457989509190L;//游戏ID:数字炸弹

    private Map<Long, String> mMgNameIDs = null;

    public SudMGCfg() {
        roomID = "9009";
        customUISwitch = true;
        pauseMGSwitch = true;
        gameMode = 1;
        gameSoundControl = 0;
        gameSoundVolume = 100;
        gameCPU = new SudMGCfgGameCPU();
        ui = new SudMGCfgUI();
        ui.gameSettle = new SudMGCfgUIGameSettle();
        ui.ping = new SudMGCfgUIPing();
        ui.version = new SudMGCfgUIVersion();
        ui.level = new SudMGCfgUILevel();
        ui.lobby_setting_btn = new SudMGCfgUILobbySettingBtn();
        ui.lobby_help_btn = new SudMGCfgUILobbyHelpBtn();
        ui.lobby_players = new SudMGCfgUILobbyPlayers();
        ui.lobby_player_captain_icon = new SudMGCfgUILobbyPlayerCaptainIcon();
        ui.lobby_player_kickout_icon = new SudMGCfgUILobbyPlayerKickoutIcon();
        ui.lobby_rule = new SudMGCfgUILobbyRule();
        ui.lobby_game_setting = new SudMGCfgUILobbyGameSetting();
        ui.join_btn = new SudMGCfgUIJoinBtn();
        ui.cancel_join_btn = new SudMGCfgUICancelJoinBtn();
        ui.ready_btn = new SudMGCfgUIReadyBtn();
        ui.cancel_ready_btn = new SudMGCfgUICancelReadyBtn();
        ui.start_btn = new SudMGCfgUIStartBtn();
        ui.share_btn = new SudMGCfgUIShareBtn();
        ui.game_setting_btn = new SudMGCfgUIGameSettingBtn();
        ui.game_help_btn = new SudMGCfgUIGameHelpBtn();
        ui.game_settle_close_btn = new SudMGCfgUIGameSettleCloseBtn();
        ui.game_settle_again_btn = new SudMGCfgUIGameSettleAgainBtn();
        ui.game_bg = new SudMGCfgUIGameBg();
    }

    private void initMgNameIDs(Context context) {
        if (mMgNameIDs == null) {
            mMgNameIDs = new HashMap<>();
            mMgNameIDs.put(SudMGCfg.MG_ID_BUMPER_CAR, context.getResources().getString(R.string.bumper_car));
            mMgNameIDs.put(SudMGCfg.MG_ID_FLY_CUTTER, context.getResources().getString(R.string.fly_cutter));
            mMgNameIDs.put(SudMGCfg.MG_ID_DRAW_GUESS, context.getResources().getString(R.string.draw_guess));
            mMgNameIDs.put(SudMGCfg.MG_ID_GO_BANG, context.getResources().getString(R.string.go_bang));
            mMgNameIDs.put(SudMGCfg.MG_ID_REVERSI, context.getResources().getString(R.string.reversi));
            mMgNameIDs.put(SudMGCfg.MG_ID_SKATING, context.getResources().getString(R.string.skating));
            mMgNameIDs.put(SudMGCfg.MG_ID_LUDO, context.getResources().getString(R.string.ludo));
            mMgNameIDs.put(SudMGCfg.MG_ID_ROLL, context.getResources().getString(R.string.roll));
            mMgNameIDs.put(SudMGCfg.MG_ID_RSP, context.getResources().getString(R.string.rsp));
            mMgNameIDs.put(SudMGCfg.MG_ID_NUMBER_BOMB, context.getResources().getString(R.string.number_bomb));
        }
    }

    /** 默认房间ID
     * APP接入方运行Demo时，建议重新指定一个房间ID，保证每一个接入方测试Demo时互不影响
     * HelloSud Demo APP 是接入方的一个实例
     * 每一家接入方的appId都不同，所以接入方和接入方之间是隔离且互不影响
     */
    public String roomID;
    /** CustomUI界面开关
     *  true，所有原生按钮根据状态显示隐藏
     *  false, 所有原生按钮都一直显示
     */
    public boolean customUISwitch;
    /** 切后台是否调用pauseMG
     *  true, 切后台时调用pauseMG
     *  false, 切后台时不调用pauseMG
     */
    public boolean pauseMGSwitch;
    public int gameMode;
    public SudMGCfgGameCPU gameCPU;
    /**
     * 游戏中声音的播放是否被app层接管
     * 值为0和1；0：游戏播放声音，1：app层播放声音，游戏中不播放任何声音；默认是0
     */
    public int gameSoundControl;
    /**
     * 游戏中音量的大小（值为0到100；默认是100）
     */
    public int gameSoundVolume;
    public SudMGCfgUI ui;

    public class SudMGCfgUI {
        public SudMGCfgUIGameSettle gameSettle;
        public SudMGCfgUIPing ping;
        public SudMGCfgUIVersion version;
        public SudMGCfgUILevel level;
        public SudMGCfgUILobbySettingBtn lobby_setting_btn;
        public SudMGCfgUILobbyHelpBtn lobby_help_btn;
        public SudMGCfgUILobbyPlayers lobby_players;
        public SudMGCfgUILobbyPlayerCaptainIcon lobby_player_captain_icon;
        public SudMGCfgUILobbyPlayerKickoutIcon lobby_player_kickout_icon;
        public SudMGCfgUILobbyRule lobby_rule;
        public SudMGCfgUILobbyGameSetting lobby_game_setting;
        public SudMGCfgUIJoinBtn join_btn;
        public SudMGCfgUICancelJoinBtn cancel_join_btn;
        public SudMGCfgUIReadyBtn ready_btn;
        public SudMGCfgUICancelReadyBtn cancel_ready_btn;
        public SudMGCfgUIStartBtn start_btn;
        public SudMGCfgUIShareBtn share_btn;
        public SudMGCfgUIGameSettingBtn game_setting_btn;
        public SudMGCfgUIGameHelpBtn game_help_btn;
        public SudMGCfgUIGameSettleCloseBtn game_settle_close_btn;
        public SudMGCfgUIGameSettleAgainBtn game_settle_again_btn;
        public SudMGCfgUIGameBg game_bg;
    }

    public class SudMGCfgGameCPU {
        // 值为0和1；0：正常cpu消耗，1：低cpu消耗；默认模式是0
        int mode = 0;
    }

    public class SudMGCfgUIGameSettle {
        boolean hide = true;
    }

    public class SudMGCfgUIPing {
        boolean hide = true;
    }

    public class SudMGCfgUIVersion {
        boolean hide = true;
    }

    public class SudMGCfgUILevel {
        boolean hide = true;
    }

    public class SudMGCfgUILobbySettingBtn {
        boolean hide = true;
    }

    public class SudMGCfgUILobbyHelpBtn {
        boolean hide = true;
    }

    public class SudMGCfgUILobbyPlayers {
        boolean custom = false;
        boolean hide = false;
    }

    public class SudMGCfgUILobbyPlayerCaptainIcon {
        boolean hide = false;
    }

    public class SudMGCfgUILobbyPlayerKickoutIcon {
        boolean hide = true;
    }

    public class SudMGCfgUILobbyRule {
        boolean hide = true;
    }

    public class SudMGCfgUILobbyGameSetting {
        boolean hide = true;
    }

    public class SudMGCfgUIJoinBtn {
        boolean custom = false;
        boolean hide = false;
    }

    public class SudMGCfgUICancelJoinBtn {
        boolean custom = true;
        boolean hide = true;
    }

    public class SudMGCfgUIReadyBtn {
        boolean custom = false;
        boolean hide = false;
    }

    public class SudMGCfgUICancelReadyBtn {
        boolean custom = true;
        boolean hide = true;
    }

    public class SudMGCfgUIStartBtn {
        boolean custom = true;
        boolean hide = true;
    }

    public class SudMGCfgUIShareBtn {
        boolean custom = true;
        boolean hide = true;
    }

    public class SudMGCfgUIGameSettingBtn {
        boolean hide = true;
    }

    public class SudMGCfgUIGameHelpBtn {
        boolean hide = true;
    }

    public class SudMGCfgUIGameSettleCloseBtn {
        boolean custom = true;
    }

    public class SudMGCfgUIGameSettleAgainBtn {
        boolean custom = true;
    }

    public class SudMGCfgUIGameBg {
        boolean hide = true;
    }

    public long getMGIDByMGName(Context context, String mgName) {
        initMgNameIDs(context);

        for (Map.Entry<Long, String> entry : mMgNameIDs.entrySet()) {
            long key = entry.getKey();
            String value = entry.getValue();
            if (value.equals(mgName)) {
                return key;
            }
        }
        return 0;
    }

    public String getMGNameByMGID(Context context, long mgID) {
        initMgNameIDs(context);

        if (mMgNameIDs.containsKey(mgID)) {
            return mMgNameIDs.get(mgID);
        }
        return null;
    }

    public String getJsonString() {
        String json = "";
        try {
            JSONObject jsonObject = new JSONObject();
            JSONObject uiObj = new JSONObject();

            // 游戏模式（每个游戏默认模式是1，不填是1）
            {
                jsonObject.put("gameMode", gameMode);
            }

            // 游戏cpu占用
            {
                jsonObject.put("gameCPU", gameCPU.mode);
            }

            // 游戏中声音的播放是否被app层接管, 值为0和1；0：游戏播放声音，1：app层播放声音，游戏中不播放任何声音；默认是0
            {
                jsonObject.put("gameSoundControl", gameSoundControl);
            }

            // 游戏中音量的大小（值为0到100；默认是100）
            {
                jsonObject.put("gameSoundVolume", gameSoundVolume);
            }

            // 结算界面
            {
                JSONObject gameSettle = new JSONObject();
                gameSettle.put("hide", ui.gameSettle.hide);
                uiObj.put("gameSettle", gameSettle);
            }

            // 界面中的ping值
            {
                JSONObject ping = new JSONObject();
                ping.put("hide", ui.ping.hide);
                uiObj.put("ping", ping);
            }

            // 界面中的版本信息值
            {
                JSONObject version = new JSONObject();
                version.put("hide", ui.version.hide);
                uiObj.put("version", version);
            }

            // 大厅中的段位信息
            {
                JSONObject level = new JSONObject();
                level.put("hide", ui.level.hide);
                uiObj.put("level", level);
            }

            // 大厅的设置按钮
            {
                JSONObject lobby_setting_btn = new JSONObject();
                lobby_setting_btn.put("hide", ui.lobby_setting_btn.hide);
                uiObj.put("lobby_setting_btn", lobby_setting_btn);
            }

            // 大厅的帮助按钮
            {
                JSONObject lobby_help_btn = new JSONObject();
                lobby_help_btn.put("hide", ui.lobby_help_btn.hide);
                uiObj.put("lobby_help_btn", lobby_help_btn);
            }

            // 大厅玩家展示位
            {
                JSONObject lobby_players = new JSONObject();
                lobby_players.put("custom", ui.lobby_players.custom);
                lobby_players.put("hide", ui.lobby_players.hide);
                uiObj.put("lobby_players", lobby_players);
            }

            // 大厅玩家展示位上队长标识
            {
                JSONObject lobby_player_captain_icon = new JSONObject();
                lobby_player_captain_icon.put("hide", ui.lobby_player_captain_icon.hide);
                uiObj.put("lobby_player_captain_icon", lobby_player_captain_icon);
            }

            // 大厅玩家展示位上踢人标识
            {
                JSONObject lobby_player_kickout_icon = new JSONObject();
                lobby_player_kickout_icon.put("hide", ui.lobby_player_kickout_icon.hide);
                uiObj.put("lobby_player_kickout_icon", lobby_player_kickout_icon);
            }

            // 大厅的玩法规则描述文字
            {
                JSONObject lobby_rule = new JSONObject();
                lobby_rule.put("hide", ui.lobby_rule.hide);
                uiObj.put("lobby_rule", lobby_rule);
            }

            // 玩法设置
            {
                JSONObject lobby_game_setting = new JSONObject();
                lobby_game_setting.put("hide", ui.lobby_game_setting.hide);
                uiObj.put("lobby_game_setting", lobby_game_setting);
            }

            //加入按钮
            {
                JSONObject join_btn = new JSONObject();
                join_btn.put("custom", ui.join_btn.custom);
                join_btn.put("hide", ui.join_btn.hide);
                uiObj.put("join_btn", join_btn);
            }

            //取消加入按钮
            {
                JSONObject cancel_join_btn = new JSONObject();
                cancel_join_btn.put("custom", ui.cancel_join_btn.custom);
                cancel_join_btn.put("hide", ui.cancel_join_btn.hide);
                uiObj.put("cancel_join_btn", cancel_join_btn);
            }

            // 准备按钮
            {
                JSONObject ready_btn = new JSONObject();
                ready_btn.put("custom", ui.ready_btn.custom);
                ready_btn.put("hide", ui.ready_btn.hide);
                uiObj.put("ready_btn", ready_btn);
            }

            // 取消准备按钮
            {
                JSONObject cancel_ready_btn = new JSONObject();
                cancel_ready_btn.put("custom", ui.cancel_ready_btn.custom);
                cancel_ready_btn.put("hide", ui.cancel_ready_btn.hide);
                uiObj.put("cancel_ready_btn", cancel_ready_btn);
            }

            // 开始游戏按钮
            {
                JSONObject start_btn = new JSONObject();
                start_btn.put("custom", ui.start_btn.custom);
                start_btn.put("hide", ui.start_btn.hide);
                uiObj.put("start_btn", start_btn);
            }

            // 分享按钮
            {
                JSONObject share_btn = new JSONObject();
                share_btn.put("custom", ui.share_btn.custom);
                share_btn.put("hide", ui.share_btn.hide);
                uiObj.put("share_btn", share_btn);
            }

            // 游戏场景中的设置按钮
            {
                JSONObject game_setting_btn = new JSONObject();
                game_setting_btn.put("hide", ui.game_setting_btn.hide);
                uiObj.put("game_setting_btn", game_setting_btn);
            }

            // 游戏场景中的帮助按钮
            {
                JSONObject game_help_btn = new JSONObject();
                game_help_btn.put("hide", ui.game_help_btn.hide);
                uiObj.put("game_help_btn", game_help_btn);
            }

            // 游戏结算界面中的关闭按钮
            {
                JSONObject game_settle_close_btn = new JSONObject();
                game_settle_close_btn.put("custom", ui.game_settle_close_btn.custom);
                uiObj.put("game_settle_close_btn", game_settle_close_btn);
            }

            // 游戏结算界面中的再来一局按钮
            {
                JSONObject game_settle_again_btn = new JSONObject();
                game_settle_again_btn.put("custom", ui.game_settle_again_btn.custom);
                uiObj.put("game_settle_again_btn", game_settle_again_btn);
            }

            // 是否隐藏游戏背景图
            {
                JSONObject game_bg = new JSONObject();
                game_bg.put("hide", ui.game_bg.hide);
                uiObj.put("game_bg", game_bg);
            }

            jsonObject.put("ui", uiObj);

            json = jsonObject.toString();
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return json;
    }
}
