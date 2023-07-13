import Flutter
import UIKit
import Argyle

public class SwiftArgyleLinkFlutterPlugin: NSObject, FlutterPlugin {

    private static var _channel: FlutterMethodChannel?

    private var newTokenCallback: ((String) -> Void)? = nil

    private var channel: FlutterMethodChannel? {
        SwiftArgyleLinkFlutterPlugin._channel
    }

    private var presentedController: UIViewController? {
        UIApplication.shared.delegate?.window??.rootViewController
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "argyle_link_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftArgyleLinkFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        SwiftArgyleLinkFlutterPlugin._channel = channel
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
        newTokenCallback?(token)
    }

    private func startSdk(_ linkConfiguration: [String: Any]) {
        ArgyleLink.start(
            from: presentedController!,
            config: parseConfig(params: linkConfiguration["config"] as! [String: Any])
        )
    }

    private func closeSdk() {
        ArgyleLink.close()
    }

    private func parseConfig(params: [String: Any]) -> LinkConfig {
        var config = LinkConfig(
            userToken: params["userToken"] as! String,
            sandbox: params["sandbox"] as! Bool
        )
        config.items = params["items"] as? [String]
        config.accountId = params["accountId"] as? String
        config.flowId = params["flowId"] as? String
        config.ddsConfig = params["ddsConfig"] as? String

        config.baseUrl = params["apiHost"] as? String
        config.wrapperSdk = "Flutter"

        if (params["onTokenExpired"] as? Bool) == true {
            config.onTokenExpired = { [weak self] callback in
                self?.newTokenCallback = callback
                self?.channel?.invokeMethod("onTokenExpired", arguments: nil)
            }
        }

        if (params["onCantFindItemClicked"] as? Bool) == true {
            config.onCantFindItemClicked = { [weak self] in
                self?.channel?.invokeMethod("onCantFindItemClicked", arguments: ["term": $0])
            }
        }
        if (params["onAccountCreated"] as? Bool) == true {
            config.onAccountCreated = { [weak self] in
                self?.channel?.invokeMethod("onAccountCreated", arguments: $0.toMap())
            }
        }
        if (params["onAccountConnected"] as? Bool) == true {
            config.onAccountConnected = { [weak self] in
                self?.channel?.invokeMethod("onAccountConnected", arguments: $0.toMap())
            }
        }
        if (params["onAccountRemoved"] as? Bool) == true {
            config.onAccountRemoved = { [weak self] in
                self?.channel?.invokeMethod("onAccountRemoved", arguments: $0.toMap())
            }
        }
        if (params["onAccountError"] as? Bool) == true {
            config.onAccountError = { [weak self] in
                self?.channel?.invokeMethod("onAccountError", arguments: $0.toMap())
            }
        }
        if (params["onDDSSuccess"] as? Bool) == true {
            config.onDDSSuccess = { [weak self] in
                self?.channel?.invokeMethod("onDDSSuccess", arguments: $0.toMap())
            }
        }
        if (params["onDDSError"] as? Bool) == true {
            config.onDDSError = { [weak self] in
                self?.channel?.invokeMethod("onDDSError", arguments: $0.toMap())
            }
        }
        if (params["onFormSubmitted"] as? Bool) == true {
            config.onFormSubmitted = { [weak self] in
                self?.channel?.invokeMethod("onFormSubmitted", arguments: $0.toMap())
            }
        }
        if (params["onDocumentsSubmitted"] as? Bool) == true {
            config.onDocumentsSubmitted = { [weak self] in
                self?.channel?.invokeMethod("onDocumentsSubmitted", arguments: $0.toMap())
            }
        }
        if (params["onError"] as? Bool) == true {
            config.onError = { [weak self] in
                self?.channel?.invokeMethod("onError", arguments: $0.toMap())
            }
        }
        if (params["onClose"] as? Bool) == true {
            config.onClose = { [weak self] in
                self?.channel?.invokeMethod("onClose", arguments: nil)
            }
        }
        if (params["onUiEvent"] as? Bool) == true {
            config.onUIEvent = { [weak self] in
                self?.channel?.invokeMethod("onUiEvent", arguments: $0.toMap())
            }
        }

        return config
    }
}

private extension AccountData {
    func toMap() -> [String: Any] {
        ["accountData": ["accountId": accountId, "userId": userId, "itemId": itemId]]
    }
}

private extension FormData {
    func toMap() -> [String: Any] {
        ["formData": ["accountId": accountId, "userId": userId]]
    }
}

private extension LinkError {
    func toMap() -> [String: Any] {
        [
            "linkError": [
                "errorType": errorType.encoded,
                "errorMessage": errorMessage,
                "errorDetails": errorDetails
            ]
        ]
    }
}

private extension Argyle.UIEvent {
    func toMap() -> [String: Any] {
        ["uiEvent": ["name": name, "properties": properties]]
    }
}

private extension ArgyleErrorType {
    var encoded: String {
        switch self {
        case .INVALID_DDS_CONFIG: return "INVALID_PD_CONFIG"
        case .INVALID_USER_TOKEN: return "INVALID_USER_TOKEN"
        case .INVALID_LINK_KEY: return "INVALID_LINK_KEY"
        case .INVALID_ITEMS: return "INVALID_ITEMS"
        case .INVALID_ACCOUNT_ID: return "INVALID_ACCOUNT_ID"
        case .EXPIRED_USER_TOKEN: return "EXPIRED_USER_TOKEN"
        case .CALLBACK_UNDEFINED: return "CALLBACK_UNDEFINED"
        case .CARD_ISSUER_UNAVAILABLE: return "CARD_ISSUER_UNAVAILABLE"
        case .DDS_NOT_SUPPORTED: return "DDS_NOT_SUPPORTED"
        case .INCOMPATIBLE_DDS_CONFIG: return "INCOMPATIBLE_DDS_CONFIG"
        case .GENERIC: return "GENERIC"
        @unknown default: return "GENERIC"
        }
    }
}
