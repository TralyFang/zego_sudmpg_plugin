import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:zego_sudmpg_plugin/method_helper.dart';

class PlatformGameView extends StatefulWidget {
  const PlatformGameView({Key? key}) : super(key: key);

  @override
  _PlatformGameViewState createState() => _PlatformGameViewState();
}

class _PlatformGameViewState extends State<PlatformGameView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        platformView(),
        Column(
          children: [
            GestureDetector(
                onTap: (){
                  _methodChannel.invokeMethod(GameUtils.MG_SELF_IN, {"isIn": true});
                },
                child: Text("加入游戏")
            ),
            GestureDetector(
                onTap: (){
                  _methodChannel.invokeMethod(GameUtils.MG_SELF_READY, {"isReady": true});
                },
                child: Text("准备游戏")
            ),
            GestureDetector(
                onTap: (){
                  _methodChannel.invokeMethod(GameUtils.MG_SELF_PLAYING, {"isPlaying": true});
                },
                child: Text("开始游戏")
            ),
          ],
        )
      ],
    );
  }

  Widget platformView() {
    if(Platform.isAndroid){
      return AndroidView(
        viewType: 'zego_sudmpg_plugin/gameView',
        // creationParams: const {
        //   "roomId": "",
        //   "userId":"",
        //   "appCode":"",
        //   "mgId":""
        // },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onVideGiftCreated,
        // hitTestBehavior: PlatformViewHitTestBehavior.transparent,
      );
    }else if (Platform.isIOS) {
      return UiKitView(
        viewType: 'zego_sudmpg_plugin/gameView',
        // creationParams: const {
        //   "roomId": "",
        //   "userId":"",
        //   "appCode":"",
        //   "mgId":""
        // },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onVideGiftCreated,
        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
      );
    }
    return Container();
  }

  late MethodChannel _methodChannel;

  void _onVideGiftCreated(int id) {
    var channelName = 'zego_sudmpg_plugin/gameView';
    _methodChannel = MethodChannel(channelName);
    _methodChannel.setMethodCallHandler((call) {
      switch(call.method) {
        case GameUtils.MG_EXPIRE_APP_CODE: {

          // 更新code

          return Future.value("success");
        }
      }
      return Future.value("success");
    });
  }
}
