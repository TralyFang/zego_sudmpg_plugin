package com.example.zego_sudmpg_plugin.hello.config;/*
 * Copyright © Sud.Tech
 * https://sud.tech
 */

import com.example.zego_sudmpg_plugin.hello.utils.UserUtils;

public class AppConfig {

    public static final String APP_ID = "1461564080052506636";
    public static final String APP_KEY = "03pNxK2lEXsKiiwrBQ9GbH541Fk2Sfnc";

    /** false:生产环境 true:测试环境 */
    public static boolean kIsTestEnv = true;

    /** 默认房间ID 见SudMGCfg.roomID
     * APP接入方运行Demo时，建议重新指定一个房间ID，保证每一个接入方测试Demo时互不影响
     * HelloSud Demo APP 是接入方的一个实例
     * 每一家接入方的appId都不同，所以接入方和接入方之间是隔离且互不影响
     * 现在已经改成可配置的，放在SudMGCfg中
     */
//    public static final String kRoomID = "10000001";//房间ID，同一个房间ID可对战

    /** 默认语言 */
    public static String kLanguage = "zh-CN";

    /** APP接入方用户唯一ID */
    public final static String kUserID = UserUtils.genUserID();

    /** Login获取Code的URL */
    public static final String kLoginUrl = "https://fat-mgp-hello.sudden.ltd/login/v3";

    /** 处理获取游戏视图信息 */
    public static SudMGCfg kSudMGCfg = new SudMGCfg();
}
