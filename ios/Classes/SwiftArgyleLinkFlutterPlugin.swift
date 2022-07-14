import Flutter
import UIKit
import ArgyleLink

public class SwiftArgyleLinkFlutterPlugin: NSObject, FlutterPlugin {

    private static var _channel: FlutterMethodChannel?

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
        if (call.method == "startSdk") {
            startSdk(call.arguments as! [String: Any])
            result("")
        } else if (call.method == "close") {
            closeSdk()
            result("")
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func startSdk(_ linkConfiguration: [String: Any]) {
        let linkKey = linkConfiguration[ConfigKeys.linkKey] as! String
        let apiHost = linkConfiguration[ConfigKeys.apiHost] as! String
        let userToken = linkConfiguration[ConfigKeys.userToken] as? String

        let instance = Argyle.shared
        _ = instance.loginWith(linkKey: linkKey, apiHost: apiHost, userToken: userToken ?? "")
        _ = instance.resultListener(self)
        configInstanceParams(linkConfiguration)

        let controller = Argyle.shared.controller
        controller.modalPresentationStyle = .fullScreen
        presentedController?.present(controller, animated: true, completion: nil)
    }

    private func closeSdk() {
        Argyle.shared.close()
    }

    private func configInstanceParams(_ linkConfiguration: [String: Any]) {
        let instance = Argyle.shared
        if let value = linkConfiguration[ConfigKeys.linkItemIds] as? [String] {
            _ = instance.linkItems(value)
        }
        if let value = linkConfiguration[ConfigKeys.pdConfig] as? String {
            _ = instance.payDistributionConfig(value)
        }
        if let value = linkConfiguration[ConfigKeys.pdItemsOnly] as? Bool {
            _ = instance.payDistributionItemsOnly(value)
        }
        if let value = linkConfiguration[ConfigKeys.pdUpdateFlow] as? Bool {
            _ = instance.payDistributionUpdateFlow(value)
        }
        if let value = linkConfiguration[ConfigKeys.pdAutoTrigger] as? Bool {
            _ = instance.payDistributionAutoTrigger(value)
        }
        if let value = linkConfiguration[ConfigKeys.sdkCustomisationId] as? String {
            _ = instance.customizationId(value)
        }
        if let value = linkConfiguration[ConfigKeys.companyName] as? String {
            _ = instance.companyName(value)
        }
        if let value = linkConfiguration[ConfigKeys.exitButtonTitle] as? String {
            _ = instance.exitButtonTitle(value)
        }
        if let value = linkConfiguration[ConfigKeys.excludeCategories] as? [String] {
            _ = instance.excludeCategories(value)
        }
        if let value = linkConfiguration[ConfigKeys.showCategories] as? Bool {
            _ = instance.showCategories(value)
        }
        if let value = linkConfiguration[ConfigKeys.showBackToSearchButton] as? Bool {
            _ = instance.showBackToSearchButton(value)
        }
        if let value = linkConfiguration[ConfigKeys.pdReviewScreenSubtitle] as? String {
            _ = instance.payDistributionReviewScreenSubtitle(value)
        }
        if let value = linkConfiguration[ConfigKeys.pdReviewScreenTitle] as? String {
            _ = instance.payDistributionReviewScreenTitle(value)
        }
        if let value = linkConfiguration[ConfigKeys.backToSearchButtonTitle] as? String {
            _ = instance.backToSearchButtonTitle(value)
        }
        if let value = linkConfiguration[ConfigKeys.cantFindLinkItemTitle] as? String {
            _ = instance.cantFindLinkItemTitle(value)
        }
        if let value = linkConfiguration[ConfigKeys.showCantFindLinkItemAtTop] as? Bool {
            _ = instance.showCantFindLinkItemAtTop(value)
        }
        if linkConfiguration[ConfigKeys.cantFindLinkItemCallback] as? Bool == true {
            _ = instance.onCantFindLinkItemClicked { [weak self] query in
                self?.channel?.invokeMethod("onCantFindLinkItemClicked", arguments: ["query": query])
            }
        }
    }
}

extension SwiftArgyleLinkFlutterPlugin: ArgyleResultListener {
    public func onAccountCreated(accountId: String, userId: String, linkItemId: String) {
        channel?.invokeMethod("onAccountCreated", arguments: ["accountId": accountId, "userId": userId, "linkItemId": linkItemId])
    }

    public func onAccountConnected(accountId: String, userId: String, linkItemId: String) {
        channel?.invokeMethod("onAccountConnected", arguments: ["accountId": accountId, "userId": userId, "linkItemId": linkItemId])
    }

    public func onAccountError(accountId: String, userId: String, linkItemId: String) {
        channel?.invokeMethod("onAccountError", arguments: ["accountId": accountId, "userId": userId, "linkItemId": linkItemId])
    }

    public func onAccountUpdated(accountId: String, userId: String, linkItemId: String) {
        channel?.invokeMethod("onAccountUpdated", arguments: ["accountId": accountId, "userId": userId, "linkItemId": linkItemId])
    }

    public func onAccountRemoved(accountId: String, userId: String, linkItemId: String) {
        channel?.invokeMethod("onAccountRemoved", arguments: ["accountId": accountId, "userId": userId, "linkItemId": linkItemId])
    }

    public func onPayDistributionSuccess(accountId: String, userId: String, linkItemId: String) {
        channel?.invokeMethod("onPayDistributionSuccess", arguments: ["accountId": accountId, "userId": userId, "linkItemId": linkItemId])
    }

    public func onPayDistributionError(accountId: String, userId: String, linkItemId: String) {
        channel?.invokeMethod("onPayDistributionError", arguments: ["accountId": accountId, "userId": userId, "linkItemId": linkItemId])
    }

    public func onUserCreated(token: String, userId: String) {
        channel?.invokeMethod("onUserCreated", arguments: ["token": token, "userId": userId])
    }

    public func onError(error: ArgyleErrorType) {
        channel?.invokeMethod("onError", arguments: ["error": error.encoded])
    }

    public func onExitIntroClicked() {
        channel?.invokeMethod("onExitIntroClicked", arguments: nil)
    }

    public func onUIEvent(name: String, properties: [String : Any]) {
        channel?.invokeMethod("onUIEvent", arguments: ["name": name, "properties": properties])
    }

    public func onClose() {
        channel?.invokeMethod("onClose", arguments: nil)
    }

    public func onDocumentsSubmitted(accountId: String, userId: String) {
        channel?.invokeMethod("onDocumentsSubmitted", arguments: ["accountId": accountId, "userId": userId])
    }

    public func onFormSubmitted(accountId: String, userId: String) {
        channel?.invokeMethod("onFormSubmitted", arguments: ["accountId": accountId, "userId": userId])
    }

    public func onTokenExpired(handler: @escaping (String) -> ()) {
        // currently not supported
    }
}

private extension ArgyleErrorType {
    var encoded: String {
        switch self {
        case .INVALID_PD_CONFIG:
            return "INVALID_PD_CONFIG"
        case .INVALID_USER_TOKEN:
            return "INVALID_USER_TOKEN"
        case .INVALID_LINK_KEY:
            return "INVALID_LINK_KEY"
        case .INVALID_LINK_ITEMS:
            return "INVALID_LINK_ITEMS"
        case .GENERIC:
            return "GENERIC"
        case .CALLBACK_UNDEFINED:
            return "CALLBACK_UNDEFINED"
        @unknown default:
            return "GENERIC"
        }
    }
}

private struct ConfigKeys {
    static let linkKey = "linkKey"
    static let apiHost = "apiHost"
    static let userToken = "userToken"
    static let linkItemIds = "linkItems"
    static let pdConfig = "payDistributionConfig"
    static let pdItemsOnly = "payDistributionItemsOnly"
    static let pdUpdateFlow = "payDistributionUpdateFlow"
    static let pdAutoTrigger = "payDistributionAutoTrigger"
    static let sdkCustomisationId = "customizationId"
    static let companyName = "companyName"
    static let exitButtonTitle = "exitButtonTitle"
    static let excludeCategories = "excludeCategories"
    static let showCategories = "showCategories"
    static let showBackToSearchButton = "showBackToSearchButton"
    static let pdReviewScreenSubtitle = "pdReviewScreenSubtitle"
    static let pdReviewScreenTitle = "pdReviewScreenTitle"
    static let backToSearchButtonTitle = "backToSearchButtonTitle"
    static let cantFindLinkItemTitle = "cantFindLinkItemTitle"
    static let showCantFindLinkItemAtTop = "showCantFindLinkItemAtTop"
    static let cantFindLinkItemCallback = "cantFindLinkItemCallback"
}
