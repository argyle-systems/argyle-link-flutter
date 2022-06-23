# Argyle Link Flutter Plugin


Argyle's Flutter plugin which wraps [our native Android and iOS SDKs](https://argyle.com/docs/products/argyle-link)

## Installation


### 1. Add the SDK dependency
Add `argyle_link_flutter` to your pubspec.yaml file, either manually, or by running this command:

    dart pub add argyle_link_flutter

### 2. Configure your integration

**Access your Link API Key**
- Log into your [Console](https://console.argyle.com/api-keys) instance
- Navigate to the [API Keys](https://console.argyle.com/api-keys) area under the Developer menu
- Copy your Sandbox or Production Link API Key for use in the next step

**Start the SDK**  
To start Link in your Flutter app, call `Argyle.startSdk()` passing in your Link Key and other configuration options.

``` dart

...  

    Argyle.startSdk(
        configuration: <String, Object>{
          'linkKey': '[YOUR LINK KEY]'},
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
**Note:** We recommend you to lock your app to portrait orientation.


- `minSdkVersion` of `23` and above
- Kotlin version `1.6.21` and above
