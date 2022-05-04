import Flutter
import UIKit
import ArgyleLink

public class SwiftArgyleLinkFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "argyle_link_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftArgyleLinkFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "startSdk") {
        let flutterController = UIApplication.shared.delegate!.window!!.rootViewController!
        let controller = Argyle.shared.controller
        // read call arguments and setup SDK
        controller.modalPresentationStyle = .fullScreen
        flutterController.present(controller, animated: true, completion: nil)
        result("")
    }
  }
}
