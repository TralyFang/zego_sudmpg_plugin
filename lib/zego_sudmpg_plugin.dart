
import 'dart:async';

import 'package:flutter/services.dart';

class ZegoSudmpgPlugin {
  static const MethodChannel _channel = MethodChannel('zego_sudmpg_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
