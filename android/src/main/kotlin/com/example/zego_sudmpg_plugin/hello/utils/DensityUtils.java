package com.example.zego_sudmpg_plugin.hello.utils;/*
 * Copyright © Sud.Tech
 * https://sud.tech
 */

import android.content.Context;

public class DensityUtils {
    public static int dp2px(Context context, int dpValue) {
        float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dpValue * scale + 0.5f);
    }
}
