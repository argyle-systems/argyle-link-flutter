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
...

Argyle.startSdk(
        configuration: <String, Object>{
          'linkKey': '[YOUR LINK API KEY]'
        },
        onAccountConnected: onAccountConnectedHandler,
        onAccountCreated: onAccountCreatedHandler,
        onAccountRemoved: onAccountRemovedHandler,
        onAccountUpdated: onAccountUpdatedHandler,
        onAccountError: onAccountErrorHandler,
        onUserCreated: onUserCreatedHandler,
        onPayDistributionError: onPayDistributionErrorHandler,
        onPayDistributionSuccess: onPayDistributionSuccessHandler,
        onUIEvent: onUiEventHandler,
        onDocumentsSubmitted: onDocumentsSubmittedHandler,
        onFormSubmitted: onFormSubmittedHandler,
        onError: onErrorHandler,
        onClose: () {});

...

```

### Usage

For detailed guidance on how to integrate our SDK please review the example app located in this repo, and also check out our [Link SDK Documentation](https://argyle.com/docs/products/argyle-link).

### iOS Requirements

- Xcode 13.0+
- iOS 12.0+

### Android Requirements

Set the `minSdkVersion` in `android/app/build.gradle`:

```groovy
android {
    defaultConfig {
        minSdkVersion 23 // or greater
    }
}
```
