package com.example.zego_sudmpg_plugin.hello.utils;

import android.os.Handler;
import android.os.Looper;

public class ThreadUtils {
    public static void postUITask(Runnable r) {
        Looper uiLoop = Looper.getMainLooper();
        if (Looper.myLooper() != uiLoop) {
            new Handler(uiLoop).post(r);
        } else {
            r.run();
        }
    }
}
