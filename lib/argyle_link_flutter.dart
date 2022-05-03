
import 'dart:async';

import 'package:flutter/services.dart';

class ArgyleLinkFlutter {
  static const MethodChannel _channel = MethodChannel('argyle_link_flutter');

  /// Initializes the Argyle Link flow on the device.
  static Future<void> startSdk({required Map<String, dynamic> configuration}) async {
    await _channel.invokeMethod('startSdk', configuration);
  }
}
