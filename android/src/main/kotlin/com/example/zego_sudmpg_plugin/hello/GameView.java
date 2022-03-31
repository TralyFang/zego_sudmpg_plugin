package com.example.zego_sudmpg_plugin.hello;


import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;

import com.example.zego_sudmpg_plugin.ZegoMGManager;
import com.example.zego_sudmpg_plugin.hello.state.SudMGPAPPState;
import com.example.zego_sudmpg_plugin.hello.state.SudMGPMGState;
import com.example.zego_sudmpg_plugin.hello.utils.DensityUtils;
import com.example.zego_sudmpg_plugin.hello.utils.GameUtils;
import com.example.zego_sudmpg_plugin.hello.utils.ThreadUtils;
import com.example.zego_sudmpg_plugin.hello.utils.ToastUtils;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Objects;

import javax.xml.transform.Result;

import io.flutter.plugin.common.MethodChannel;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import tech.sud.mgp.core.ISudFSMMG;
import tech.sud.mgp.core.ISudFSMStateHandle;
import tech.sud.mgp.core.ISudFSTAPP;
import tech.sud.mgp.core.ISudListenerInitSDK;
import tech.sud.mgp.core.SudMGP;





/**
 * 游戏串游戏逻辑为主，APP做状态展现（代码量更少）
 * 游戏逻辑：加入游戏，准备游戏，取消准备，开始游戏
 * SudMGP类参考：https://github.com/SudTechnology/sud-mgp-doc/blob/main/Client/API/SudMGP.md
 */
public class GameView {

    private static final String kTag = "SudMGP--FlutterGameView";

    /// 游戏相关参数
    private ZegoMGManager MGConfig = ZegoMGManager.Companion.getInstance();

    /** 调用游戏SDK的接口,成功加载游戏后可用 */
    private ISudFSTAPP mISudFSTAPP;

    private Activity mContext;
    private FrameLayout frameLayout;
    private MethodChannel methodChannel;

    public void init(Activity context, FrameLayout frameLayout, MethodChannel methodChannel){

        mContext = context;
        this.frameLayout = frameLayout;
        this.methodChannel = methodChannel;
        // 检查WRITE_EXTERNAL_STORAGE权限
        {
            checkOrRequestPermission();
        }
        // 获取Code
        {
            login(MGConfig.getUserId(), mAppLoginCallback);
            /// TODO: Flutter的处理逻辑
            mAppLoginCallback.onLoginSuccess(0, MGConfig.getAPP_Code(), "");
        }
    }

    /**
     * Check and request permission
     */
    public boolean checkOrRequestPermission() {
        String[] PERMISSIONS_STORAGE = {
                "android.permission.WRITE_EXTERNAL_STORAGE",
                "android.permission.RECORD_AUDIO"};

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (ContextCompat.checkSelfPermission(mContext, "android.permission.WRITE_EXTERNAL_STORAGE") != PackageManager.PERMISSION_GRANTED
                    || ContextCompat.checkSelfPermission(mContext, "android.permission.RECORD_AUDIO") != PackageManager.PERMISSION_GRANTED) {
                mContext.requestPermissions(PERMISSIONS_STORAGE, 101);
                return false;
            }
        }
        return true;
    }

    private final AppLoginListener mAppLoginCallback = new AppLoginListener() {
        @Override
        public void onLoginFailure(String errMsg) {
            Log.e(kTag, errMsg);
        }

        @Override
        public void onLoginSuccess(int ret_code, String new_code, String expire_Date) {
//            if (ret_code.equals("SUCCESS")) {    // 判断成功规则由"接入方服务端"确定，因为模拟接入方服务端可能变化，在此注释模拟接入方服务端的判断成功条件
            Log.i(kTag, "login 从接入方服务端获得 Code=" + new_code + " ExpireDate=" + expire_Date);
            MGConfig.setAPP_Code(new_code);
            new Handler(Looper.getMainLooper()).post(() -> {
                // 初始化游戏SDK
                initGameSDK(mContext, MGConfig.getAPP_ID(), MGConfig.getAPP_KEY(), MGConfig.getKIsTestEnv());
            });
//            }
        }
    };

    /**
     * 1，初始化游戏SDK
     *
     * @param context   上下文
     * @param appID     appID
     * @param appKey    appKey
     * @param isTestEnv 是否是测试环境，true：测试环境，false：生产环境
     */
    private void initGameSDK(Context context, String appID, String appKey, Boolean isTestEnv) {
        SudMGP.initSDK(context, appID, appKey, isTestEnv, new ISudListenerInitSDK() {
            @Override
            public void onSuccess() {
                ToastUtils.showToast(mContext,"初始化游戏SDK成功"+MGConfig.getRoomId());
                Log.i(kTag, "初始化游戏SDK成功"+MGConfig.getRoomId()+" mgId:"+MGConfig.getMMGID());
                loadMG(mContext, MGConfig.getUserId(), MGConfig.getRoomId(), MGConfig.getAPP_Code(), MGConfig.getMMGID(), MGConfig.getKLanguage());
            }

            @Override
            public void onFailure(int retCode, String retMsg) {
                Log.i(kTag, "初始化游戏SDK失败:" + retCode + " retMsg=" + retMsg);
                ToastUtils.showToast(mContext,"初始化游戏SDK失败:" + retCode + " retMsg=" + retMsg);
            }
        });
    }

    /**
     * 2，加载游戏
     *
     * @param activity 上下文Activity
     * @param userID   用户ID，业务系统保证每个用户拥有唯一ID
     * @param roomID   房间ID，进入同一房间内的
     * @param code     短期令牌Code
     * @param mgID     小游戏ID
     * @param language 游戏语言 现支持，简体：zh-CN 繁体：zh-TW 英语：en-US 马来语：ms-MY
     * ISudFSTAPP接口参考：https://github.com/SudTechnology/sud-mgp-doc/blob/main/Client/API/ISudFSTAPP.md
     */
    private void loadMG(Activity activity, String userID, String roomID, String code, long mgID, String language) {
        mISudFSTAPP = SudMGP.loadMG(activity, userID, roomID, code, mgID, language, mISudFSMMG);
        addGameView(mISudFSTAPP.getGameView());
    }

    /**
     * 3，将游戏view添加到接入方App的布局当中
     *
     * @param gameView 小游戏View
     */
    private void addGameView(View gameView) {
        FrameLayout container = frameLayout;
        container.addView(gameView);
    }

    private void removeGameView(View gameView) {
        FrameLayout container = frameLayout;
        container.removeView(gameView);
    }

    /**
     * APP客户端实现ISudFSMMG接口
     * 游戏通知APP
     * 小游戏有限状态机
     * 参考：https://github.com/SudTechnology/sud-mgp-doc/blob/main/Client/API/ISudFSMMG.md
     */
    private final ISudFSMMG mISudFSMMG = new ISudFSMMG() {

        /**
         * 游戏日志
         * 最低版本：v1.1.30.xx
         */
        @Override
        public void onGameLog(String dataJson) {
            Log.w(kTag, dataJson);
        }

        /**
         * 游戏开始
         * 最低版本：v1.1.30.xx
         */
        @Override
        public void onGameStarted() {
            /** Activity的软键盘模式被改变，需要在此重新设置Activity的windowSoftInputMode */
        }

        /**
         * 游戏销毁
         * 最低版本：v1.1.30.xx
         */
        @Override
        public void onGameDestroyed() {

        }

        /**
         * Code过期
         * 1.重新获取Code
         * 2.更新Code，调用mISudFSTAPP.updateCode(Code, null)通知游戏更新Code;
         * @param handle handle.success("{}");
         * @param dataJson {"code":"value"}
         */
        @Override
        public void onExpireCode(ISudFSMStateHandle handle, String dataJson) {
            // 1.重新获取Code
            methodChannel.invokeMethod(GameUtils.MG_EXPIRE_APP_CODE, dataJson, new MethodChannel.Result() {
                @Override
                public void success(@Nullable Object result) {
                    String code = result.toString();
                    MGConfig.setAPP_Code(code);
                    if (mISudFSTAPP != null) {
                        // 2.更新Code
                        mISudFSTAPP.updateCode(MGConfig.getAPP_Code(), null);
                    }
                }
                @Override
                public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                }

                @Override
                public void notImplemented() {
                }
            });

            login(MGConfig.getUserId(), new AppLoginListener() {
                @Override
                public void onLoginFailure(String errMsg) {
                    Log.e(kTag, errMsg);
                }

                @Override
                public void onLoginSuccess(int ret_code, String new_code, String expire_Date) {
                    if (ret_code == 0) {    // 判断成功规则由"接入方服务端"确定，这里模拟接入服务器用ret_code == 0判断是否成功返回Code
                        Log.i(kTag, "UpdateCode： Code=" + new_code + " Expire=" + expire_Date);
                        MGConfig.setAPP_Code(new_code);
                        if (mISudFSTAPP != null) {
                            // 2.更新Code
                            mISudFSTAPP.updateCode(MGConfig.getAPP_Code(), null);
                        }
                    }
                }
            });

            handle.success("{}");
        }

        /**
         * 获取游戏View信息
         * @param handle handle.success(json);
         * @param dataJson {}
         * 参考：https://github.com/SudTechnology/sud-mgp-doc/blob/main/Client/API/ISudFSMMG/onGetGameViewInfo.md
         */
        @Override
        public void onGetGameViewInfo(final ISudFSMStateHandle handle, String dataJson) {
            // 拿到游戏View的宽高
            final FrameLayout container = frameLayout;
            int gameViewWidth = container.getMeasuredWidth();
            int gameViewHeight = container.getMeasuredHeight();
            if (gameViewWidth > 0 && gameViewHeight > 0) {
                notifyGameViewInfo(handle, gameViewWidth, gameViewHeight);
            } else {    //如果游戏View未加载完成，则监听加载完成时回调
                container.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
                    @Override
                    public void onGlobalLayout() {
                        container.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                        int gameViewWidth = container.getMeasuredWidth();
                        int gameViewHeight = container.getMeasuredHeight();
                        notifyGameViewInfo(handle, gameViewWidth, gameViewHeight);
                    }
                });
            }
        }

        /**
         * 获取游戏Config
         * @param handle handle.success("{}");
         * @param dataJson {}
         * 最低版本：v1.1.30.xx
         * 参考：https://github.com/SudTechnology/sud-mgp-doc/blob/main/Client/API/ISudFSMMG/onGetGameCfg.md
         */
        @Override
        public void onGetGameCfg(ISudFSMStateHandle handle, String dataJson) {
            String json = MGConfig.getKSudMGCfg().getJsonString();
            Log.d(kTag, "onGetGameCfg:" + json);
            handle.success(json);
        }

        /**
         * 通知游戏，游戏视图信息
         * @param handle handle.success("{}");
         * @param gameViewWidth width
         * @param gameViewHeight height
         */
        private void notifyGameViewInfo(ISudFSMStateHandle handle, int gameViewWidth, int gameViewHeight) {
            try {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("ret_code", 0);
                jsonObject.put("ret_msg", "success");

                // 游戏View大小
                JSONObject viewSize = new JSONObject();
                viewSize.put("width", gameViewWidth);
                viewSize.put("height", gameViewHeight);
                jsonObject.put("view_size", viewSize);

                // 游戏安全操作区域
                JSONObject viewGameRect = new JSONObject();
                viewGameRect.put("left", 0);
                viewGameRect.put("top", DensityUtils.dp2px(mContext, 90));
                viewGameRect.put("right", 0);
                viewGameRect.put("bottom", DensityUtils.dp2px(mContext, 85));
                jsonObject.put("view_game_rect", viewGameRect);

                // 通知游戏
                String json = jsonObject.toString();
                Log.d(kTag, "notifyGameViewInfo:" + json);
                handle.success(json);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        /**
         * MG状态机-通用状态-游戏
         * 参考：https://github.com/SudTechnology/sud-mgp-doc/blob/main/Client/MG%20FSM/%E9%80%9A%E7%94%A8%E7%8A%B6%E6%80%81-%E6%B8%B8%E6%88%8F.md
         * @param handle handle.success("{}");
         * @param state     状态名
         * @param dataJson  状态数据，json字符串
         */
        @Override
        public void onGameStateChange(ISudFSMStateHandle handle, String state, String dataJson) {
            Log.d(kTag, "onGameStateChange state:" + state + "--dataJson:" + dataJson);
            if (!state.equals(SudMGPMGState.MG_COMMON_PUBLIC_MESSAGE)) {
//                addPublicMsgGameState(state, dataJson);
            }
            switch (state) {
                case SudMGPMGState.MG_COMMON_PUBLIC_MESSAGE:
//                    handleMgCommonPublicMessage(dataJson);
                    break;
                case SudMGPMGState.MG_COMMON_KEY_WORD_TO_HIT:
//                    handleMgCommonKeyWordToHit(dataJson);
                    break;
                case SudMGPMGState.MG_COMMON_GAME_ASR:
//                    handleMgCommonGameASR(dataJson);
                    break;
                case SudMGPMGState.MG_COMMON_SELF_MICROPHONE:  // 游戏通知app麦克风状态, 在RTC场景下，app依此决定开启推流或者关闭推流
//                    handleMgCommonSelfMicroPhone(dataJson);
                    break;
                case SudMGPMGState.MG_COMMON_SELF_HEADPHONE:   // 游戏通知app耳机（听筒，喇叭）状态， 在RTC场景下，app依此决定开启拉流或者关闭拉流
//                    handleMgCommonSelfHeadPhone(dataJson);
                    break;
            }

            handle.success("{\"ret_code\": 0, \"ret_msg\": \"success\"}");
        }

        /**
         * MG状态机-通用状态-玩家
         * 参考：https://github.com/SudTechnology/sud-mgp-doc/blob/main/Client/MG%20FSM/%E9%80%9A%E7%94%A8%E7%8A%B6%E6%80%81-%E7%8E%A9%E5%AE%B6.md
         * @param handle handle.success("{}");
         * @param userId    玩家用户ID
         * @param state     状态名
         * @param dataJson  状态数据，json字符串。参考文档
         */
        @Override
        public void onPlayerStateChange(ISudFSMStateHandle handle, String userId, String state, String dataJson) {
            Log.d(kTag, "onPlayerStateChange userId:" + userId + "--state:" + state + "--dataJson:" + dataJson);
//            addPublicMsgPlayerState(userId, state, dataJson);
            switch (state) {
                //region 通用状态-玩家
                case SudMGPMGState.MG_COMMON_PLAYER_IN:
//                    handleMgCommonPlayerIn(userId, dataJson);
                    break;
                case SudMGPMGState.MG_COMMON_PLAYER_READY:
//                    handleMgCommonPlayerReady(userId, dataJson);
                    break;
                case SudMGPMGState.MG_COMMON_PLAYER_CAPTAIN:
//                    handleMgCommonPlayerCaptain(userId, dataJson);
                    break;
                case SudMGPMGState.MG_COMMON_PLAYER_PLAYING:
//                    handleMgCommonPlayerPlaying(userId, dataJson);
                    break;
                //endregion 通用状态-玩家
            }

            handle.success("{\"ret_code\": 0, \"ret_msg\": \"success\"}");
        }
    };

    /********************** 游戏操作 ******************************/
    /// 退出游戏
    public void notifyAppCommonSelfIn() {
        notifyAppCommonSelfIn(false, -1);
    }
    /// 加入游戏
    public void notifyAppCommonSelfIn(boolean isIn, int seatIndex) {
        try {
            // 状态名称
            String state = SudMGPAPPState.APP_COMMON_SELF_IN;

            // 状态数据
            JSONObject jsonObject = new JSONObject();
            // true 加入游戏，false 退出游戏
            jsonObject.put("isIn", isIn);
            // 加入的游戏位(座位号) 默认传seatIndex = -1 随机加入，seatIndex 从0开始，不可大于座位数
            jsonObject.put("seatIndex", seatIndex);
            // 默认为ture, 带有游戏位(座位号)的时候，如果游戏位(座位号)已经被占用，是否随机分配一个空位坐下
            // isSeatRandom=true 随机分配空位坐下，isSeatRandom=false 不随机分配
            jsonObject.put("isSeatRandom", true);
            // 1.不支持分队的游戏，数值填1；2.支持分队的游戏，数值填1或2（两支队伍）；
            jsonObject.put("teamId", 1);
            String dataJson = jsonObject.toString();

            // 调用接口
            mISudFSTAPP.notifyStateChange(state, dataJson, null);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    /// 准备游戏
    public void notifyAppCommonSelfReady(boolean isReady) {
        try {
            // 状态名称
            String state = SudMGPAPPState.APP_COMMON_SELF_READY;

            // 状态数据
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("isReady", isReady); // true 准备，false 取消准备
            String dataJson = jsonObject.toString();

            // 调用接口
            mISudFSTAPP.notifyStateChange(state, dataJson, null);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    /// 开始或结束游戏
    public void notifyAppCommonSelfPlaying(boolean isPlaying) {
        try {
            // 状态名称
            String state = SudMGPAPPState.APP_COMMON_SELF_PLAYING;

            // 状态数据
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("isPlaying", isPlaying); // true 开始游戏，false 结束游戏
            if (isPlaying) {
                // 透传的参数，Https服务会回调report_game_info参数
//                jsonObject.put("reportGameInfoExtras", "divtoss");
            }
            String dataJson = jsonObject.toString();

            // 调用接口
            mISudFSTAPP.notifyStateChange(state, dataJson, null);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    /// 设置队长
    public void notifyAppCommonSelfCaptain(String uid) {
        try {
            // 状态名称
            String state = SudMGPAPPState.APP_COMMON_SELF_CAPTAIN;

            // 状态数据
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("curCaptainUID", uid); // 必填，指定队长uid
            String dataJson = jsonObject.toString();

            // 调用接口
            mISudFSTAPP.notifyStateChange(state, dataJson, null);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    /// 踢人，只限队长功能
    public void notifyAppCommonSelfKick(String uid) {
        try {
            // 状态名称
            String state = SudMGPAPPState.APP_COMMON_SELF_KICK;

            // 状态数据
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("kickedUID", uid); // 被踢用户uid
            String dataJson = jsonObject.toString();

            // 调用接口
            mISudFSTAPP.notifyStateChange(state, dataJson, null);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    /// 主动结束游戏，只限队长功能
    public void notifyAppCommonSelfEnd() {
        try {
            // 状态名称
            String state = SudMGPAPPState.APP_COMMON_SELF_END;

            // 状态数据
            JSONObject jsonObject = new JSONObject();
            String dataJson = jsonObject.toString();

            // 调用接口
            mISudFSTAPP.notifyStateChange(state, dataJson, null);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /******************************/

    interface AppLoginListener {
        /**
         * App Server 登陆失败, App Server 不能返回CODE
         */
        void onLoginFailure(String errMsg);

        /**
         * App Server 登陆成功, App Server调用服务端接入SDK的API获取Code 返回给 App
         * App 就要用CODE和自己生成的UserID去调用SDK的初始化函数，登陆小游戏
         * 小游戏登陆成功后，其UserID，就是App传的UserID
         * ret_code 状态码，自己服务器决定
         */
        void onLoginSuccess(int ret_code, String new_code, String expire_Date);
    }

    /**
     * 参考sud-mgp-doc login
     * 地址：https://github.com/SudTechnology/sud-mgp-doc/blob/main/Resource/startup.png
     * 1. <接入方客户端>调用login接口，访问<接入方服务端>，获取Code
     * 2. Code生成：<接入方服务端>调用<服务端接入SDK>API生成Code
     * @param userId 接入方用户唯一ID
     * @param listener 获取Code回调
     */
    private void login(String userId, AppLoginListener listener){
        ///TODO: 测试代码，这里不需要处理，直接交给Flutter逻辑处理
        login1(userId, listener);
    }
    private void login1(String userId, AppLoginListener listener) {
        OkHttpClient client = new OkHttpClient();
        String req = "";
        try {
            JSONObject reqJsonObj = new JSONObject();
            reqJsonObj.put("user_id", userId);
            reqJsonObj.put("app_id", MGConfig.getAPP_ID());
            req = reqJsonObj.toString();
        } catch (Exception e) {
            e.printStackTrace();
        }

        RequestBody body = RequestBody.create(req, MediaType.get("application/json; charset=utf-8"));
        Request request = new Request.Builder()
                .url(MGConfig.getKLoginUrl())
                .post(body)
                .build();
        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(@NonNull Call call, @NonNull IOException e) {
                ThreadUtils.postUITask(() -> {
                    if (listener != null) {
                        listener.onLoginFailure(e.toString());
                    }
                });
            }

            @Override
            public void onResponse(@NonNull Call call, @NonNull Response response) {
                try {
                    String dataJson = Objects.requireNonNull(response.body()).string();
                    JSONObject jsonObject = new JSONObject(dataJson);
                    int ret_code = jsonObject.getInt("ret_code");
                    JSONObject dataObject = jsonObject.getJSONObject("data");
                    String newCode = dataObject.getString("code");
                    String expireDate = dataObject.getString("expire_date");
                    String avatarUrl = dataObject.getString("avatar_url");

                    ThreadUtils.postUITask(() -> {
                        if (listener != null) {
                            listener.onLoginSuccess(ret_code, newCode, expireDate);
                        }
                    });
                } catch (Exception e) {
                    e.printStackTrace();
                    ThreadUtils.postUITask(() -> {
                        if (listener != null) {
                            listener.onLoginFailure(e.toString());
                        }
                    });
                }
            }
        });
    }
    /*****************************/


}