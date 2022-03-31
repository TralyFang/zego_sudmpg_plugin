package com.example.zego_sudmpg_plugin

import android.content.Context
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import com.example.zego_sudmpg_plugin.ZegoSudmpgPlugin.Companion.mActivity
import com.example.zego_sudmpg_plugin.ZegoSudmpgPlugin.Companion.mContext
import com.example.zego_sudmpg_plugin.hello.GameView
import com.example.zego_sudmpg_plugin.hello.config.AppConfig
import com.example.zego_sudmpg_plugin.hello.config.SudMGCfg
import com.example.zego_sudmpg_plugin.hello.utils.GameUtils
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView


/**
 *
 * 逻辑
 * 1。初始化SDK「userId, roomId, MGID, appCode」
 *  flutter--->native--->initSDK--->loadGame
 * 2. 开始游戏
 * flutter--->in,ready,playing
 * 3。 appCode过期需要刷新
 *  native-->flutter-->code--->native--->update
 *
 * 1。 加入游戏
 * 2。 准备游戏
 * 3。 设置队长
 * 4。 开始游戏
 * 5。 踢人
 * 6。 结算
 *
 * **/

class ZegoSudmpgView(private var context: Context, messenger: BinaryMessenger?, id: Int, params: Map<String, Any>) : PlatformView,
    MethodChannel.MethodCallHandler {

    private val TAG = "ZegoSudmpgView"
    private  var methodChannel: MethodChannel = MethodChannel(messenger, "zego_sudmpg_plugin/gameView")
    private val contentView: FrameLayout = FrameLayout(context)
    private val gameView : GameView = GameView()
    init {

        /// 需要外部传过来的必须参数
//        ZegoMGManager.instance.roomId = params["roomId"].toString()
//        ZegoMGManager.instance.userId = params["userId"].toString()
//        ZegoMGManager.instance.APP_Code = params["appCode"].toString()
//        ZegoMGManager.instance.mMGID = params["mgId"].toString().toLongOrNull() ?:SudMGCfg.MG_ID_BUMPER_CAR

        params["appKey"]?.toString()?.let {
            ZegoMGManager.instance.APP_KEY = it
        }
        params["appId"]?.toString()?.let {
            ZegoMGManager.instance.APP_ID = it
        }
        params["roomId"]?.toString()?.let {
            ZegoMGManager.instance.roomId = it
        }
        params["userId"]?.toString()?.let {
            ZegoMGManager.instance.userId = it
        }
        params["appCode"]?.toString()?.let {
            ZegoMGManager.instance.APP_Code = it
        }
        params["expireDate"]?.toString()?.let {
            ZegoMGManager.instance.APP_Code_expireDate = it
        }
        if (params["mgId"]?.toString().isNullOrEmpty()){
        }else {
            params["mgId"]?.toString()?.toLong()?.let {
                ZegoMGManager.instance.mMGID = it
            }
        }

        Log.i(TAG, "gameInit.params: $params, mgId: ${ZegoMGManager.instance.mMGID}, appCode: ${ZegoMGManager.instance.APP_Code}")

        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View {
        gameView.init(mActivity, contentView, methodChannel)
        return contentView
    }

    override fun dispose() {
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.i(TAG, "gameMethodCall: ${call.method}")
        if (call != null){
            when(call.method){
                GameUtils.MG_SELF_IN->{ // 加入游戏
                    val isIn = call.argument<Boolean>("isIn") ?: false
                    val seatIndex = call.argument<Int>("seatIndex") ?: -1
                    gameView.notifyAppCommonSelfIn(isIn, seatIndex)
                }
                GameUtils.MG_SELF_READY->{ // 准备游戏
                    val isReady = call.argument<Boolean>("isReady") ?: false
                    gameView.notifyAppCommonSelfReady(isReady)
                }
                GameUtils.MG_SELF_PLAYING->{ // 开始游戏
                    val isPlaying = call.argument<Boolean>("isPlaying") ?: false
                    gameView.notifyAppCommonSelfPlaying(isPlaying)
                }
                GameUtils.MG_SELF_CAPTAIN->{ // 设置队长
                    val captainUserId = call.argument<String>("captainUserId")
                    captainUserId.let {
                        gameView.notifyAppCommonSelfCaptain(it)
                    }
                }
                GameUtils.MG_SELF_KICK->{// 踢人
                    val kickUserId = call.argument<String>("kickUserId")
                    kickUserId.let {
                        gameView.notifyAppCommonSelfKick(it)
                    }
                }
                GameUtils.MG_SELF_END->{ // 结束游戏
                    gameView.notifyAppCommonSelfEnd()
                }
            }
        }else{
            print("MethodCall is null");
        }
    }

}