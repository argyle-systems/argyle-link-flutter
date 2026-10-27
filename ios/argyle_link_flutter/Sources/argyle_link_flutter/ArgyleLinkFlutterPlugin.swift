import Flutter
import UIKit

public class ArgyleLinkFlutterPlugin: NSObject, FlutterPlugin {

    private static var _channel: FlutterMethodChannel?

    private var webLinkController: ArgyleWebLinkViewController?

    private var channel: FlutterMethodChannel? {
        ArgyleLinkFlutterPlugin._channel
    }

    private var presentedController: UIViewController? {
        var controller = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
        ?? UIApplication.shared.delegate?.window??.rootViewController
        while let presented = controller?.presentedViewController {
            controller = presented
        }
        return controller
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "argyle_link_flutter", binaryMessenger: registrar.messenger())
        let instance = ArgyleLinkFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        ArgyleLinkFlutterPlugin._channel = channel
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "start":
            startSdk(call.arguments as! [String: Any])
            result("")
        case "close":
            closeSdk()
            result("")
        case "provideNewToken":
            provideNewToken(args: call.arguments)
            result("")
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func provideNewToken(args: Any?) {
        guard let token = (args as? [String: Any])?["newToken"] as? String else {
            fatalError("newToken argument must be set")
        }
        webLinkController?.updateToken(token)
    }

    private func startSdk(_ linkConfiguration: [String: Any]) {
        guard webLinkController == nil, let presenter = presentedController else {
            return
        }
        let controller = ArgyleWebLinkViewController(
            config: parseConfig(params: linkConfiguration["config"] as! [String: Any]),
            onCallback: { [weak self] name, data in
                self?.sendCallback(name: name, data: data)
            },
            onFinish: { [weak self] in
                self?.webLinkController = nil
            }
        )
        webLinkController = controller
        presenter.present(controller, animated: true)
    }

    private func closeSdk() {
        webLinkController?.close()
    }

    private func parseConfig(params: [String: Any]) -> [String: Any] {
        var config = params
        config["callbacks"] = params.compactMap { key, value -> String? in
            guard key.hasPrefix("on"), (value as? Bool) == true else { return nil }
            return key == "onUiEvent" ? "onUIEvent" : key
        }
        return config
    }

    private func sendCallback(name: String, data: [String: Any]) {
        let pick = { (keys: [String]) -> [String: Any] in
            Dictionary(uniqueKeysWithValues: keys.map { ($0, data[$0] ?? NSNull()) })
        }
        switch name {
        case "onAccountCreated", "onAccountConnected", "onAccountRemoved", "onAccountError", "onDDSSuccess", "onDDSError":
            channel?.invokeMethod(name, arguments: ["accountData": pick(["accountId", "userId", "itemId"])])
        case "onFormSubmitted", "onDocumentsSubmitted":
            channel?.invokeMethod(name, arguments: ["formData": pick(["accountId", "userId"])])
        case "onError":
            channel?.invokeMethod(name, arguments: [
                "linkError": [
                    "errorType": data["errorType"] as? String ?? "generic",
                    "errorMessage": data["errorMessage"] as? String ?? "",
                    "errorDetails": data["errorDetails"] ?? NSNull()
                ]
            ])
        case "onUIEvent":
            channel?.invokeMethod("onUiEvent", arguments: ["uiEvent": pick(["name", "properties"])])
        case "onCantFindItemClicked":
            channel?.invokeMethod(name, arguments: ["term": data["search"] ?? NSNull()])
        case "onClose", "onTokenExpired":
            channel?.invokeMethod(name, arguments: nil)
        default:
            break
        }
    }
}
