import 'package:argyle_link_flutter/argyle_link_interface.dart';

class Argyle {
  static ArgyleLinkInterface get _platform =>
      ArgyleLinkInterface.instance;

  /// Present the Argyle Link SDK
  ///   - [configuration] Configuration of the Argyle Link SDK.
  ///   - [onAccountConnected] Closure that will be called when a Link connects an account
  static Future<void> startSdk({
    required Map<String, Object> configuration,
    Function? onAccountConnected,
    Function? onAccountCreated,
    Function? onAccountUpdated,
    Function? onAccountRemoved,
    Function? onAccountError,
    Function? onError,
    Function? onUserCreated,
    Function? onClose,
    Function? onPayDistributionError,
    Function? onPayDistributionSuccess,
    Function? onUIEvent,
    Function? onTokenExpired
  }) async {
    _platform.onAccountConnected = onAccountConnected;
    _platform.onAccountCreated = onAccountCreated;
    _platform.onAccountUpdated = onAccountUpdated;
    _platform.onAccountRemoved = onAccountRemoved;
    _platform.onAccountError = onAccountError;
    _platform.onError = onError;
    _platform.onUserCreated = onUserCreated;
    _platform.onClose = onClose;
    _platform.onPayDistributionError = onPayDistributionError;
    _platform.onPayDistributionSuccess = onPayDistributionSuccess;
    _platform.onUIEvent = onUIEvent;
    _platform.onTokenExpired = onTokenExpired;

    await _platform.startSdk(
      configuration: configuration
    );
  }
}