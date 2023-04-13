# Argyle Link Flutter plugin (Beta)


Argyle's Flutter plugin which wraps [our native Android and iOS SDKs](https://argyle.com/docs/products/argyle-link)

**Note:** We recommend you to lock your app to portrait orientation.

## Installation

## 1. Add the SDK dependency

Add `argyle_link_flutter` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## 2. Integrate
### 1. Access your Link API Key
1. Log into your [Console](https://console.argyle.com/api-keys) instance
2. Navigate to the [API Keys](https://console.argyle.com/api-keys) area under the Developer menu
3. Copy your Sandbox or Production Link API Key for use in the next step

### 2. Set your Link API Key and start the SDK

``` dart
import 'package:argyle_link_flutter/link_config.dart';
// (Optional) Callback argument type definitions
import 'package:argyle_link_flutter/account_data.dart';
import 'package:argyle_link_flutter/argyle_link.dart';
import 'package:argyle_link_flutter/form_data.dart';

// ...

final config = LinkConfig(
  linkKey: 'YOUR_LINK_KEY',
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

For detailed guidance on how to integrate our SDK please review the example app located in this repo, and also check out our [Link SDK Documentation](https://argyle.com/docs/products/argyle-link).

### iOS Requirements

- Xcode 14.0+
- iOS 14.0+

### Android Requirements

Set the `minSdkVersion` in `android/app/build.gradle`:

```groovy
android {
    defaultConfig {
        minSdkVersion 26 // or greater
    }
}
```
