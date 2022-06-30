import 'dart:async';

import 'package:argyle_link_flutter/argyle_link_interface.dart';
import 'package:flutter/services.dart';

class ArgyleLinkFlutter extends ArgyleLinkInterface {
  static const MethodChannel _channel = MethodChannel('argyle_link_flutter');

  MethodChannel get channel => _channel;

  ArgyleLinkFlutter() {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  @override
  Future<void> close() async {
    await _channel.invokeMethod('close');
  }

  /// Initializes the Argyle Link flow on the device.
  @override
  Future<void> startSdk({required Map<String, dynamic> configuration}) async {
    await _channel.invokeMethod('startSdk', configuration);
  }

  Future<dynamic> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onAccountCreated':
        onAccountCreated?.call(getAccountIdArgument(call),
            getUseIdArgument(call), getLinkItemIdArgument(call));
        break;
      case 'onAccountConnected':
        onAccountConnected?.call(getAccountIdArgument(call),
            getUseIdArgument(call), getLinkItemIdArgument(call));
        break;
      case 'onAccountUpdated':
        onAccountUpdated?.call(getAccountIdArgument(call),
            getUseIdArgument(call), getLinkItemIdArgument(call));
        break;
      case 'onAccountRemoved':
        onAccountRemoved?.call(getAccountIdArgument(call),
            getUseIdArgument(call), getLinkItemIdArgument(call));
        break;
      case 'onAccountError':
        onAccountError?.call(getAccountIdArgument(call), getUseIdArgument(call),
            getLinkItemIdArgument(call));
        break;
      case 'onError':
        onError?.call(getErrorCode(call));
        break;
      case 'onUserCreated':
        onUserCreated?.call(getUserTokenArgument(call), getUseIdArgument(call));
        break;
      case 'onClose':
        onClose?.call();
        break;
      case 'onPayDistributionError':
        onPayDistributionError?.call(getAccountIdArgument(call),
            getUseIdArgument(call), getLinkItemIdArgument(call));
        break;
      case 'onPayDistributionSuccess':
        onPayDistributionSuccess?.call(getAccountIdArgument(call),
            getUseIdArgument(call), getLinkItemIdArgument(call));
        break;
      case 'onUIEvent':
        onUIEvent?.call(
            getEventNameArgument(call), getEventPropertiesArgument(call));
        break;
      case 'onDocumentsSubmitted':
        onDocumentsSubmitted?.call(getAccountIdArgument(call), getUseIdArgument(call));
        break;
      case 'onFormSubmitted':
        onFormSubmitted?.call(getAccountIdArgument(call), getUseIdArgument(call));
        break;
      case 'onCantFindLinkItemClicked':
        onCantFindLinkItemClicked?.call(getQueryArgument(call));
        break;

      default:
        throw MissingPluginException(
            '${call.method} was invoked but has no handler');
    }
  }

  Map<String, Object> getEventPropertiesArgument(MethodCall call) {
    final userdata = Map<String, Object>.from(call.arguments['properties']);
    return userdata;
  }

  getErrorCode(MethodCall call) => call.arguments['error'];
  getEventNameArgument(MethodCall call) => call.arguments['name'];
  getUserTokenArgument(MethodCall call) => call.arguments['userToken'];
  getLinkItemIdArgument(MethodCall call) => call.arguments['linkItemId'];
  getUseIdArgument(MethodCall call) => call.arguments['userId'];
  getAccountIdArgument(MethodCall call) => call.arguments['accountId'];
  getQueryArgument(MethodCall call) => call.arguments['query'];
}
