import 'package:argyle_link_flutter/account_data.dart';
import 'package:argyle_link_flutter/form_data.dart';
import 'package:argyle_link_flutter/link_config.dart';
import 'package:argyle_link_flutter/link_error.dart';
import 'package:argyle_link_flutter/ui_event.dart';
import 'package:flutter/services.dart';

class ArgyleLink {
  static const _channel = MethodChannel('argyle_link_flutter');
  static late LinkConfig _config;

  static Future<void> start(LinkConfig config) {
    _config = config;
    _channel.setMethodCallHandler(_onMethodCall);
    final params = {
      'userToken': config.userToken,
      'sandbox': config.sandbox,
      'items': config.items,
      'accountId': config.accountId,
      'flowId': config.flowId,
      'ddsConfig': config.ddsConfig,
      'apiHost': config.apiHost,
      'onCantFindItemClicked': config.onCantFindItemClicked != null,
      'onAccountCreated': config.onAccountCreated != null,
      'onAccountConnected': config.onAccountConnected != null,
      'onAccountRemoved': config.onAccountRemoved != null,
      'onAccountError': config.onAccountError != null,
      'onDDSSuccess': config.onDDSSuccess != null,
      'onDDSError': config.onDDSError != null,
      'onFormSubmitted': config.onFormSubmitted != null,
      'onDocumentsSubmitted': config.onDocumentsSubmitted != null,
      'onError': config.onError != null,
      'onClose': config.onClose != null,
      'onTokenExpired': config.onTokenExpired != null,
      'onUiEvent': config.onUiEvent != null
    };
    return _channel.invokeMethod('start', {'config': params});
  }

  static Future<void> close() {
    return _channel.invokeMethod('close');
  }

  static Future<dynamic> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onCantFindItemClicked':
        _config.onCantFindItemClicked?.call(call.arguments['term']);
        break;
      case 'onAccountCreated':
        _config.onAccountCreated?.call(_parseAccountData(call));
        break;
      case 'onAccountConnected':
        _config.onAccountConnected?.call(_parseAccountData(call));
        break;
      case 'onAccountRemoved':
        _config.onAccountRemoved?.call(_parseAccountData(call));
        break;
      case 'onAccountError':
        _config.onAccountError?.call(_parseAccountData(call));
        break;
      case 'onDDSSuccess':
        _config.onDDSSuccess?.call(_parseAccountData(call));
        break;
      case 'onDDSError':
        _config.onDDSError?.call(_parseAccountData(call));
        break;
      case 'onFormSubmitted':
        _config.onFormSubmitted?.call(_parseFormData(call));
        break;
      case 'onDocumentsSubmitted':
        _config.onDocumentsSubmitted?.call(_parseFormData(call));
        break;
      case 'onError':
        _config.onError?.call(_parseLinkError(call));
        break;
      case 'onClose':
        _config.onClose?.call();
        break;
      case 'onTokenExpired':
        _config.onTokenExpired?.call(_onNewTokenProvided);
        break;
      case 'onUiEvent':
        _config.onUiEvent?.call(_parseUiEvent(call));
        break;
    }
  }

  static AccountData _parseAccountData(MethodCall call) {
    final params = call.arguments['accountData'];
    return AccountData(
      accountId: params['accountId'],
      userId: params['userId'],
      itemId: params['itemId'],
    );
  }

  static FormData _parseFormData(MethodCall call) {
    final params = call.arguments['formData'];
    return FormData(
      accountId: params['accountId'],
      userId: params['userId'],
    );
  }

  static LinkError _parseLinkError(MethodCall call) {
    final params = call.arguments['linkError'];
    return LinkError(
        errorType: _parseLinkErrorType(params['errorType']),
        errorMessage: params['errorMessage'],
        errorDetails: params['errorDetails']);
  }

  static LinkErrorType _parseLinkErrorType(String type) {
    final normalizedType = type.toLowerCase().replaceAll('_', '');
    return LinkErrorType.values
        .firstWhere((element) => element.name.toLowerCase() == normalizedType);
  }

  static UIEvent _parseUiEvent(MethodCall call) {
    final params = call.arguments['uiEvent'];
    return UIEvent(name: params['name'], properties: params['properties']);
  }

  static void _onNewTokenProvided(String newToken) {
    _channel.invokeMethod('provideNewToken', {'newToken': newToken});
  }
}
