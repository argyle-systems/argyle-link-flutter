## 1.6.0

Added:

- Multiple document upload submissions allowed.
- Three new document upload categories — proof of identity, proof of address, miscellaneous.
- After uploading documents, users are asked for their full name if Link was entered through an embedded instance or shareable URL.
- Uploaded documents can be previewed after submission.

Changed:

- All uploaded documents are now contained within one document upload account.
- The accountId property is no longer returned by the onDocumentsSubmitted callback.
- Uploaded documents can be individually deleted.
- Document upload can be shown on the connection success screen.
- Document upload can be shown on the payroll provider selection screen.
- Document upload can be shown when users select an unsupported employer.
- When returning to Link’s full search experience is optionally enabled for direct logins, the “Find more employers” button text and search experience can now be customized. The button layout has also been adjusted.
- Success screen subtitles for account connections, form submissions, and document uploads are now customizable.
- Deposit switch percentages adjust automatically when being edited.
- Redesigned layout when grouping Items are selected in Link.

Fixed:

- [iOS] Now, Direct Deposit Update starts automatically, eliminating the intermediate error screen
- [iOS] The issue of an infinite loading screen appearing sporadically
- [iOS] Navigation issues within Employment History flows
- [iOS] Misleading error previously shown on Phone Country selection
- [iOS] Crash triggered by tapping a header in User Profile

## 1.5.0

Added:

- (Android) SMS verification codes can be auto-filled during MFA.
- (Limited payroll platforms) Ability for users to select their preferred multi-factor authentication (MFA) method.
- (Limited payroll platforms) Users are asked if they remember their login credentials before reaching the login screen. If they do not, they are re-directed to the passwordless login flow.

Changed:

- Redesign of the account reconnection screen.
- Redesign of the account connection success screen.
- Redesign of how single sign-on (SSO) methods are shown on the login screen.
- Redesign of the payroll provider selection screen.
- Search field hidden for [constrained lists](https://argyle.com/docs/workflows/account-connections#list) of less than 10 Items.
- Additional text added to the revoking account connection screen.
- Copy changes for deposit switches with allocation adjustment enabled.
- The **Callback** fallback experience now lets users search for their payroll provider if they cannot find their employer.

Fixed:

- Dynamic title text scaling on search screen.
- Text wrapping for fallback text.
- Single obfuscation character used.
- Document uploading available for unmapped Items.

## 1.4.1

Fixed

- [iOS] Potential App Store validation issues
- [iOS] Minor bugs
- [Android] Fix the wrong login method selected from the bottom sheet intermittently 
- [Android] Fix incorrect results and logos in the search
- [Android] Potential crash

## 1.4.0

Added

- Support for Flows that customize Items shown in Link search based on [mapping status](https://argyle.com/docs/overview/data-structure/items#mapping-status).
- New account connection error: `unsupported_business_account`

Changed

- Redesigned layout for payroll providers screen.
- Company logo on Link’s intro screen appears in front of the Argyle logo.
- Users options shown when an account connection error occurs adjust depending on if a connection was previously established.


## 1.3.0

Added

- New troubleshooting error messages and design improvements for multi-factor authentication (MFA) screens.
- Argyle’s intro screen can be enabled for deep link Flows.

Changed

- The "login help" call-to-action button is shown more prominently on the login screen and after users enter invalid credentials.
- The image preview shown for photo-captured uploaded documents is now zoomed out to show the entire document.

## 1.2.6

Fixed

- [iOS] An issue when deep linking to an item where Intro screen is visible
- [iOS] An issue when deep linking with an accountId to Documents Upload
- [iOS] Constrained items list display when the search input field is focused

## 1.2.4

Added

- A new account connection error message, `unsupported_language`, has been introduced. This message will be displayed if the user's payroll system contains data or documents in a language that Argyle does not currently support.

Changed

- The experience for returning users has been improved by making the required user actions more prominent. For example, an action requiring the user to reconnect their account is now more noticeable.

## 1.2.3

Fixed

- [iOS] An issue with closing Link from deep-linked screens

## 1.2.1

Fixed:

- [iOS] UI issues when deeplinking into account

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
