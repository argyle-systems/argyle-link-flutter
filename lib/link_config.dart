import 'dart:convert';

import 'package:argyle_link_flutter/account_data.dart';
import 'package:argyle_link_flutter/form_data.dart';
import 'package:argyle_link_flutter/link_error.dart';
import 'package:argyle_link_flutter/ui_event.dart';

class LinkConfig {
  final String linkKey;
  final String userToken;
  final bool sandbox;

  List<String>? items;
  String? accountId;
  String? flowId;
  String? ddsConfig;

  String? apiHost;

  Function(String)? onCantFindItemClicked;
  Function(AccountData)? onAccountCreated;
  Function(AccountData)? onAccountConnected;
  Function(AccountData)? onAccountRemoved;
  Function(AccountData)? onAccountError;
  Function(AccountData)? onDDSSuccess;
  Function(AccountData)? onDDSError;
  Function(FormData)? onFormSubmitted;
  Function(FormData)? onDocumentsSubmitted;
  Function(LinkError)? onError;
  Function()? onClose;
  Function(Function(String))? onTokenExpired;
  Function(UIEvent)? onUiEvent;

  LinkConfig({
    required this.linkKey,
    required this.userToken,
    required this.sandbox,
    this.items,
    this.accountId,
    this.flowId,
    this.ddsConfig,
    this.apiHost,
    this.onCantFindItemClicked,
    this.onAccountCreated,
    this.onAccountConnected,
    this.onAccountRemoved,
    this.onAccountError,
    this.onDDSSuccess,
    this.onDDSError,
    this.onFormSubmitted,
    this.onDocumentsSubmitted,
    this.onError,
    this.onClose,
    this.onTokenExpired,
    this.onUiEvent,
  });
}
