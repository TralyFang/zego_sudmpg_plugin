
class GameUtils {

  /****************Native层->flutter层******************/
  static const String MG_EXPIRE_APP_CODE = "mg_expire_app_code";// 原生appCode过期回调，需要通知flutter获取最新code，去更新游戏code

  /****************flutter层->Native层******************/
  static const String MG_SELF_IN ="mg_self_in"; // 加入游戏
  static const String MG_SELF_READY ="mg_self_ready"; // 准备游戏
  static const String MG_SELF_PLAYING ="mg_self_playing"; // 开始游戏
  static const String MG_SELF_KICK ="mg_self_kick"; // 踢人
  static const String MG_SELF_CAPTAIN ="mg_self_captain"; // 设置队长
  static const String MG_SELF_END ="mg_self_end"; // 结束游戏
}
