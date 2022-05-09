# Argyle Link Flutter plugin

Argyle's Flutter plugin which wraps [our native Android and iOS SDKs](https://argyle.com/docs/products/argyle-link)

## Installation

We currently don't publish our plugin to [pub.dev](https://pub.dev/). If you have access to this repository then you can add the dependency to your project via your `pubspec.yaml`:

```yaml
dependencies:
  argyle-link:
    git:
      url: git://github.com/argyle-systems/argyle-plugin-flutter-source
```

More information about the mechanism for adding unpublished plugins can be found in the [Flutter documentation](https://docs.flutter.dev/development/packages-and-plugins/using-packages#dependencies-on-unpublished-packages).

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

### Known limitations
This initial version of the plugin has 2 known limitations:

* The `onCantFindLinkItemClicked` callback has not been implemented
* The `onTokenExpired` callback has not been implemented

These 2 callbacks will be implemented very soon.