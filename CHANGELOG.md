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
