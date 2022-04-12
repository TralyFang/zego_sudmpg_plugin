package com.example.zego_sudmpg_plugin

import com.example.zego_sudmpg_plugin.hello.config.SudMGCfg
import com.example.zego_sudmpg_plugin.hello.utils.UserUtils
import java.time.LocalDateTime
import java.util.*

/**
 * 相关配置管理，初始化游戏的
 *
 * */
class ZegoMGManager private constructor(){
    companion object {
        val instance = SingletonHolder.holder
    }
    private object SingletonHolder {
        val holder= ZegoMGManager()
    }

    /** app 配置信息 */
    var APP_ID = "1461564080052506636"
    var APP_KEY = "03pNxK2lEXsKiiwrBQ9GbH541Fk2Sfnc"

    /** false:生产环境 true:测试环境  */
    var kIsTestEnv = true
    /** 默认语言  游戏语言 现支持，简体：zh-CN 繁体：zh-TW 英语：en-US 马来语：ms-MY */
    var kLanguage = "en-US"

    /** 处理获取游戏视图信息  */
    var kSudMGCfg = SudMGCfg()

    /** 默认房间ID
     * 房间ID，同一个房间ID可对战
     */
    var roomId = kSudMGCfg.roomID

    /** APP接入方用户唯一ID  */
    var userId = UserUtils.genUserID()

    /** 每个游戏对应的id */
    var mMGID = SudMGCfg.MG_ID_BUMPER_CAR

    /** APP接入方服务端生成Code 具有实效性的，过期需要更新的  */
    var APP_Code = ""
    var APP_Code_expireDate = ""

    /** Login获取Code的URL  */
    val kLoginUrl = "https://fat-mgp-hello.sudden.ltd/login/v3"


}