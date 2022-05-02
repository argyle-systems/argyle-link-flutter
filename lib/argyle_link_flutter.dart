
import 'dart:async';

import 'package:flutter/services.dart';

class ArgyleLinkFlutter {
  static const MethodChannel _channel = MethodChannel('argyle_link_flutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
