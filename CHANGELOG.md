## 1.2.0

Added

- Added user prompts for government benefits and "Employees only" Items.
- Added allocation type selection for the entire paycheck scenario when using the `allow_changing_allocation_type` DDS config flag.

Changed

- Improved handling for Items that support multiple payroll providers.
- Added more information to the Login screen about why Argyle is involved.
- Updated text content used in DDS-related screens.
- Deprecated the `linkKey` parameter.
- Improved presentation of the login methods to the user.
- Separated username and password reset buttons at login.
- [iOS] Improved bottom sheet handling.

Fixed

- [iOS] Fixed various minor UI issues.
- [Android] Fixed allocation editing issue within DDS flow.
- [Android] Fixed an issue with confirming allocations for DDS.
- [Android] Fixed an issue with opening the default email application from the MFA screen.
- Fixed focus handling for allocation options.

## 1.1.0

Added

* The ability to fully customize which tabs (Popular, Employer, Gig, Benefits, Payroll) appear on the home screen of Link's search experience.
* Recommendations for the Popular tab can now be chosen manually.
* Additional selections are available when the user is searching for a payroll provider.
* Users can be given the option to return to the search screen even if they are directly connected to a specific employer or payroll provider.

Fixed

Various UI and stability issues

## 1.0.1

Fixed

* [iOS] Closing Link after deep linking to a Grouping item
* [iOS] Minor UI issues

## 1.0.0

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
