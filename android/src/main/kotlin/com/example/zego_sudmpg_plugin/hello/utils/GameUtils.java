package com.example.zego_sudmpg_plugin.hello.utils;

public class GameUtils {

    /****************Native层->flutter层******************/
    public static final String MG_EXPIRE_APP_CODE = "mg_expire_app_code";// 原生appCode过期回调，需要通知flutter获取最新code，去更新游戏code
    public static final String MG_JOIN_USERID = "mg_join_userId"; // 加入游戏的用户
    public static final String MG_STATE_STARTED = "mg_state_started"; // 游戏已经加载完成

    /****************flutter层->Native层******************/
    public static final String MG_SELF_IN ="mg_self_in"; // 加入游戏
    public static final String MG_SELF_READY ="mg_self_ready"; // 准备游戏
    public static final String MG_SELF_PLAYING ="mg_self_playing"; // 开始游戏
    public static final String MG_SELF_KICK ="mg_self_kick"; // 踢人
    public static final String MG_SELF_CAPTAIN ="mg_self_captain"; // 设置队长
    public static final String MG_SELF_END ="mg_self_end"; // 结束游戏

    public static final String MG_DISPOSE = "mg_dispose"; // 退出游戏了

    public static final String MG_SELF_SOUND ="mg_self_sound"; // 打开游戏声音
    public static final String MG_STATE_PLAYING = "mg_state_playing"; // 获取游戏是否开始状态
}
