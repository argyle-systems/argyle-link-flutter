# Argyle Link Flutter SDK

Argyle Link Flutter SDK provides a way to integrate [Argyle Link](https://argyle.com/docs/link/overview) into your Flutter app.

Link runs in a webview hosted by the plugin, loading the same web Link experience as the Argyle native iOS and Android SDKs. The plugin has no native SDK dependencies.

**Note:** We recommend you to lock your app to portrait orientation.

**Requirements for iOS:**

- iOS 15.0+
- Xcode 14.0+
- Works with both CocoaPods and Swift Package Manager ([Flutter SPM support](https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-developers))

**Requirements for Android:**

Set the `minSdkVersion` in `android/app/build.gradle`:

```
android {
    compileSdk 34
    defaultConfig {
        minSdk 26
        ...
    }
    ...
}
```

The plugin ships its own ProGuard/R8 rules, so no extra configuration is needed when minifying.

## 1. Add the SDK dependency

Add `argyle_link_flutter` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

---
## 2. Configure and integrate Link

### 1. Access your Link API Key

1. Log into your [Console](https://console.argyle.com/api-keys) instance
2. Navigate to the [API Keys](https://console.argyle.com/api-keys) area under the Developer menu
3. Copy your Sandbox or Production Link API Key for use in the next steps

### 2. Utilize user tokens

To prevent your API key and secret from being exposed on the front-end, [request user tokens on your server side](https://argyle.com/docs/link/user-tokens#creating-a-user-token).

### 3. Integrate Link

``` dart
import 'package:argyle_link_flutter/link_config.dart';
// (Optional) Callback argument type definitions
import 'package:argyle_link_flutter/account_data.dart';
import 'package:argyle_link_flutter/argyle_link.dart';
import 'package:argyle_link_flutter/form_data.dart';

// ...

final config = LinkConfig(
  userToken: 'USER_TOKEN',
  sandbox: true, // Set it to false for production environment.
  // (Optional) Add a Link flow customization created in Console:
  //    flowId: '<ID of the Link flow>',
  // (Optional) Add a deposit switch flow:
  //    ddsConfig: '<Encrypted target deposit destination value>',
  // (Optional) Limit Link search to specific Items:
  //    items: ['item_000001422', 'item_000025742'],
  // (Optional) Connect directly to an existing account:
  //    accountId: '<ID of the account>',
  // (Optional) Callback examples:
  onAccountConnected: (payload) => debugPrint('onAccountConnected'),
  onAccountError: (payload) => debugPrint('onAccountError'),
  onDDSSuccess: (payload) => debugPrint('onDDSSuccess'),
  onDDSError: (payload) => debugPrint('onDDSError'),
  onTokenExpired: (updateToken) => {
    debugPrint('onTokenExpired')
    // Generate a new user token.
    // updateToken(newToken)
  },
);
ArgyleLink.start(config);

// ArgyleLink.close()   // Manually close Link (typically the user closes Link).

```

### Usage

For detailed guidance on how to integrate our SDK please review the [example app](example/lib/app.dart), and also check out our [Link SDK Documentation](https://argyle.com/docs/link/initialization#flutter).
