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

  /// Closure that will be called when a Link Interaction event occurs
  Function? onAccountConnected;

  Future<void> startSdk({
    required Map<String, dynamic> configuration,
  }) async {
    throw UnimplementedError('startSdk() has not been implemented.');
  }
}