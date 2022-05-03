import 'package:argyle_link_flutter/argyle_link_interface.dart';

class Argyle {
  static ArgyleLinkInterface get _platform =>
      ArgyleLinkInterface.instance;

  /// Present the Argyle Link SDK
  ///   - [configuration] Configuration of the Argyle Link SDK.
  ///   - [onAccountConnected] Closure that will be called when a Link connects an account
  static Future<void> startSdk({
    required Map<String, Object> configuration,
    Function? onAccountConnected
  }) async {
    _platform.onAccountConnected = onAccountConnected;

    await _platform.startSdk(
      configuration: configuration
    );
  }
}