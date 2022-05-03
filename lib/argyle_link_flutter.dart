
import 'dart:async';

import 'package:argyle_link_flutter/argyle_link_interface.dart';
import 'package:flutter/services.dart';

class ArgyleLinkFlutter extends ArgyleLinkInterface {
  static const MethodChannel _channel = MethodChannel('argyle_link_flutter');

  MethodChannel get channel => _channel;

  ArgyleLinkFlutter() {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  /// Initializes the Argyle Link flow on the device.
  @override
  Future<void> startSdk({required Map<String, dynamic> configuration}) async {
    await _channel.invokeMethod('startSdk', configuration);
  }

  Future<dynamic> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onAccountConnected':
        final accountId = call.arguments['accountId'];
        onAccountConnected?.call(accountId);
        break;

      default:
        throw MissingPluginException(
            '${call.method} was invoked but has no handler');
    }
  }
}
