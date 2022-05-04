import 'package:plugin_platform_interface/plugin_platform_interface.dart';

 import 'argyle_link_flutter.dart';

abstract class ArgyleLinkInterface extends PlatformInterface {
  ArgyleLinkInterface() : super(token: _token);

  static final Object _token = Object();

  static ArgyleLinkInterface _instance = ArgyleLinkFlutter();
  static ArgyleLinkInterface get instance => _instance;

  static set instance(ArgyleLinkInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Function? onAccountConnected;
  Function? onAccountCreated;
  Function? onAccountUpdated;
  Function? onAccountRemoved;
  Function? onAccountError;
  Function? onError;
  Function? onUserCreated;
  Function? onClose;
  Function? onPayDistributionError;
  Function? onPayDistributionSuccess;
  Function? onUIEvent;
  Function? onTokenExpired;

  Future<void> startSdk({
    required Map<String, dynamic> configuration,
  }) async {
    throw UnimplementedError('startSdk() has not been implemented.');
  }

  Future<void> close() async {
    throw UnimplementedError('close() has not been implemented.');
  }
}