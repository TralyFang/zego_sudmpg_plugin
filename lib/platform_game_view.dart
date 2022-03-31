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
                  GameUtils.getInstance().notifyAppCommonSelfIn(true, 0);
                },
                child: Text("加入游戏")
            ),
            GestureDetector(
                onTap: (){
                  GameUtils.getInstance().notifyAppCommonSelfReady(true);
                },
                child: Text("准备游戏")
            ),
            GestureDetector(
                onTap: (){
                  GameUtils.getInstance().notifyAppCommonSelfPlaying(true);
                },
                child: Text("开始游戏")
            ),
          ],
        )
      ],
    );
  }

  Widget platformView() {

    var params = {
      "roomId": "",
      "userId":"",
      "appCode":"", // appcode
      "mgId":"", // 游戏id
      "appKey": "", // appkey
      "appId":"", // appId
    };

    if(Platform.isAndroid){
      return AndroidView(
        viewType: 'zego_sudmpg_plugin/gameView',
        creationParams: params,
        creationParamsCodec: const StandardMessageCodec(),
        // hitTestBehavior: PlatformViewHitTestBehavior.transparent,
      );
    }else if (Platform.isIOS) {
      return UiKitView(
        viewType: 'zego_sudmpg_plugin/gameView',
        creationParams: params,
        creationParamsCodec: const StandardMessageCodec(),
        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
      );
    }
    return Container();
  }
}
