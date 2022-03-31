
import 'package:flutter/services.dart';

/// code过期需要更新回调
typedef GameUpdateCodeCallback = Future<String> Function();

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

  GameUpdateCodeCallback? _updateCodeCallback;

  late MethodChannel _methodChannel;
  static GameUtils? _helper;
  _init() {
    _helper = GameUtils.getInstance();
  }
  GameUtils._();
  static GameUtils getInstance() {
    if (_helper == null) {
      var instance = GameUtils._();
      instance._initChannelHandler();
      _helper = instance;
    }
    return _helper!;
  }

  /// 初始化通道处理器
  void _initChannelHandler() {
    var channelName = 'zego_sudmpg_plugin/gameView';
    _methodChannel = MethodChannel(channelName);
    _methodChannel.setMethodCallHandler((call) {
      switch(call.method) {
        case GameUtils.MG_EXPIRE_APP_CODE: {
          return _updateCodeCallback?.call() ?? Future.value("success");
        }
      }
      return Future.value("success");
    });
  }

  /// 需要监听code过期回调去更新code
  notifyAppUpdateCodeCallback(GameUpdateCodeCallback callback) {
    _updateCodeCallback = callback;
  }

  /// 加入游戏
  notifyAppCommonSelfIn(bool isIn, int seatIndex) {
    _methodChannel.invokeMethod(
        GameUtils.MG_SELF_IN,
        {"isIn": isIn,
          "seatIndex": seatIndex});
  }
  /// 准备游戏
  notifyAppCommonSelfReady(bool isReady) {
    _methodChannel.invokeMethod(
        GameUtils.MG_SELF_READY,
        {"isReady": isReady});
  }
  /// 开始游戏
  notifyAppCommonSelfPlaying(isPlaying) {
    _methodChannel.invokeMethod(
        GameUtils.MG_SELF_PLAYING,
        {"isPlaying": isPlaying});
  }
  /// 设置队长
  notifyAppCommonSelfCaptain(String userId) {
    _methodChannel.invokeMethod(
        GameUtils.MG_SELF_CAPTAIN,
        {"captainUserId": userId});
  }
  /// 踢出某人
  notifyAppCommonSelfKick(String userId) {
    _methodChannel.invokeMethod(
        GameUtils.MG_SELF_KICK,
        {"kickUserId": userId});
  }
  /// 结束游戏
  notifyAppCommonSelfEnd() {
    _methodChannel.invokeMethod(
        GameUtils.MG_SELF_END);
  }

}
