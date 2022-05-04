
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
      case 'onAccountCreated':
        final accountId = call.arguments['accountId'];
        final userId = call.arguments['userId'];
        final linkItemId = call.arguments['linkItemId'];
        onAccountCreated?.call(accountId, userId, linkItemId);
        break;
      case 'onAccountConnected':
        final accountId = call.arguments['accountId'];
        final userId = call.arguments['userId'];
        final linkItemId = call.arguments['linkItemId'];
        onAccountConnected?.call(accountId, userId, linkItemId);
        break;
      case 'onAccountUpdated':
        final accountId = call.arguments['accountId'];
        final userId = call.arguments['userId'];
        final linkItemId = call.arguments['linkItemId'];
        onAccountUpdated?.call(accountId, userId, linkItemId);
        break;
      case 'onAccountRemoved':
        final accountId = call.arguments['accountId'];
        final userId = call.arguments['userId'];
        final linkItemId = call.arguments['linkItemId'];
        onAccountRemoved?.call(accountId, userId, linkItemId);
        break;
      case 'onAccountError':
        final accountId = call.arguments['accountId'];
        final userId = call.arguments['userId'];
        final linkItemId = call.arguments['linkItemId'];
        onAccountError?.call(accountId, userId, linkItemId);
        break;
      case 'onError':
        final accountId = call.arguments['accountId'];
        final userId = call.arguments['userId'];
        final linkItemId = call.arguments['linkItemId'];
        onError?.call(accountId, userId, linkItemId);
        break;
      case 'onUserCreated':
        final userToken = call.arguments['userToken'];
        final userId = call.arguments['userId'];
        onUserCreated?.call(userToken, userId);
        break;
      case 'onClose':
        onClose?.call();
        break;
      case 'onPayDistributionError':
        final accountId = call.arguments['accountId'];
        final userId = call.arguments['userId'];
        final linkItemId = call.arguments['linkItemId'];
        onPayDistributionError?.call(accountId, userId, linkItemId);
        break;
      case 'onPayDistributionSuccess':
        final accountId = call.arguments['accountId'];
        final userId = call.arguments['userId'];
        final linkItemId = call.arguments['linkItemId'];
        onPayDistributionSuccess?.call(accountId, userId, linkItemId);
        break;
      case 'onUIEvent':
        final name = call.arguments['name'];
        final properties = call.arguments['properties'];
        final userdata = Map<String, Object>.from(properties);
        onUIEvent?.call(name, userdata);
        break;

      default:
        throw MissingPluginException(
            '${call.method} was invoked but has no handler');
    }
  }
}
