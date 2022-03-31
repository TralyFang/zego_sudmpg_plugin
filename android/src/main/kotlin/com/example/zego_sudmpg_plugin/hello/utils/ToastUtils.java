package com.example.zego_sudmpg_plugin.hello.utils;

import android.content.Context;
import android.widget.Toast;

/**
 * @author guanghui
 * Created on 2021/12/11
 */
public class ToastUtils {
    public static void showToast(Context context, String content) {
        Toast.makeText(context, content, Toast.LENGTH_SHORT).show();
    }
}
