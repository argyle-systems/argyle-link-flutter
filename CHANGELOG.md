## 1.0.0-beta

Minimum requirements

- Android minSdkVersion: `26`
- iOS version: `14.0`

Added

- Photo capture now available during document upload
- Payroll connections disallowed when an Item's deposit switching capabilities do not support the provided `ddsConfig`
- `onError` callback now returns `errorType`, `errorMessage`, and `errorDetails`
- Errors added: `dds_not_supported`, `incompatible_dds_config`, `invalid_account_id`
- SDK Typescript typings

Breaking changes

- New required `sandbox` initialization parameter: `true` for Sandbox, `false` for Production
- Previously optional `userToken` initialization parameter now required
- Previously required `apiHost` initialization parameter removed
- `accountId` must be used for deep linking to existing accounts

Renamed

- Initialization parameters: `payDistributionConfig` to `ddsConfig`, `linkItems` to `items`
- Callbacks: `onCantFindLinkItemClicked` to `onCantFindItemClicked`, `onPayDistributionError` to `onDDSError`, `onPayDistributionSuccess` to `onDDSSuccess`
- Errors: `invalid_link_items` to `invalid_items`, `invalid_pd_config` to `invalid_dds_config`

Deprecations

- Previously optional initializations parameters removed: `companyName`, `showCloseButton`, `closeOnOutsideClick`, `excludeCategories`, `excludeLinkItems`, `payDistributionItemsOnly`, `showCategories`, `exitButtonTitle`, `showBackToSearchButton`, `backToSearchButtonTitle`, `showCantFindLinkItemAtTop`, `payDistributionReviewScreenTitle`, `payDistributionReviewScreenSubtitle`, `payDistributionUpdateFlow`, `payDistributionAutoTrigger`
- Callbacks removed: `onAccountUpdated`, `onUserCreated`


## 0.0.9

Bumped native iOS/Android SDKs to 4.7.0/4.7.2 versions correspondingly.

Fixed
* close method being broken on Android

## 0.0.8

Bumped native iOS/Android SDKs to 4.6.2/4.6.3 versions correspondingly.
Check [iOS Link](https://github.com/argyle-systems/argyle-link-ios/releases) and [Android Link](https://github.com/argyle-systems/argyle-link-android/releases) changelogs for more details.

Fixed
* onUserCreated callback not firing properly on iOS

## 0.0.7

Added
* Document upload support for no link item flow
* New error code - `CALLBACK_UNDEFINED`. This error indicates that you have enabled the "Callback" option on your Link Customisation but you have not defined the `onCantFindLinkItemClicked` callback when initialising the SDK.

Fixed
* A few NPEs which could arise if the SDK was started and stopped very quickly
* An issue with authentication error still visible after navigating out and coming back to Login screen

Changed
* `onCantFindLinkItemClicked` callback behaviour is now controlled via Link Customizer
* `onUIEvent` extended with form related events

## 0.0.6

* Added `onCantFindLinkItemClicked` callback

## 0.0.5

* Readme updates

## 0.0.4

* Readme updates

## 0.0.3

* Readme updates

## 0.0.2

* Readme updates

## 0.0.1

* Initial release
* Support for iOS and Android
