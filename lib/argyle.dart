import 'package:argyle_link_flutter/argyle_link_interface.dart';

class Argyle {
  static ArgyleLinkInterface get _platform =>
      ArgyleLinkInterface.instance;

  /// Present the Argyle Link SDK
  ///   - [configuration] Configuration of the Argyle Link SDK.
  ///   - [onAccountConnected] Closure that will be called when a user connects their account via Link
  ///   - [onAccountCreated] Closure that will be called when a user creates their account via Link
  ///   - [onAccountUpdated] Closure that will be called when a user updates their account via Link
  ///   - [onAccountRemoved] Closure that will be called when a user removes their account via Link
  ///   - [onAccountError] Closure that will be called when an account error is raised via Link
  ///   - [onError] Closure that will be called when the user experiences any Link error
  ///   - [onUserCreated] Closure that will be called when a User entity is created via Link
  ///   - [onClose] Closure that will be called just before Link closes
  ///   - [onPayDistributionError] Closure that will be called when a user experiences a PD error
  ///   - [onPayDistributionSuccess] Closure that will be called when a user successfully completes a PD operation
  ///   - [onUIEvent] Closure that will be called for any UI interaction
  ///   - [onTokenExpired] Closure that will be called if the users Link token expires
  static Future<void> startSdk({
    required Map<String, Object> configuration,
    Function? onAccountConnected,
    Function? onAccountCreated,
    Function? onAccountUpdated,
    Function? onAccountRemoved,
    Function? onAccountError,
    Function? onError,
    Function? onUserCreated,
    Function? onClose,
    Function? onPayDistributionError,
    Function? onPayDistributionSuccess,
    Function? onUIEvent,
    Function? onTokenExpired,
    Function? onDocumentsSubmitted,
    Function? onFormSubmitted,
    Function? onCantFindLinkItemClicked
  }) async {
    _platform.onAccountConnected = onAccountConnected;
    _platform.onAccountCreated = onAccountCreated;
    _platform.onAccountUpdated = onAccountUpdated;
    _platform.onAccountRemoved = onAccountRemoved;
    _platform.onAccountError = onAccountError;
    _platform.onError = onError;
    _platform.onUserCreated = onUserCreated;
    _platform.onClose = onClose;
    _platform.onPayDistributionError = onPayDistributionError;
    _platform.onPayDistributionSuccess = onPayDistributionSuccess;
    _platform.onUIEvent = onUIEvent;
    _platform.onTokenExpired = onTokenExpired;
    _platform.onDocumentsSubmitted = onDocumentsSubmitted;
    _platform.onFormSubmitted = onFormSubmitted;
    _platform.onCantFindLinkItemClicked = onCantFindLinkItemClicked;

    Map<String, Object> finalConfig = configuration;
    if (onCantFindLinkItemClicked != null) {
      finalConfig['cantFindLinkItemCallback'] = true;
    }
    await _platform.startSdk(
      configuration: finalConfig
    );
  }

  static Future<void> close() async {
    await _platform.close();
  }
}
