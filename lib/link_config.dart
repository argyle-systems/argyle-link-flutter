import 'dart:convert';

import 'package:argyle_link_flutter/account_data.dart';
import 'package:argyle_link_flutter/form_data.dart';
import 'package:argyle_link_flutter/link_error.dart';
import 'package:argyle_link_flutter/ui_event.dart';

class LinkConfig {
  final String linkKey;
  final String userToken;
  final bool sandbox;

  final List<String>? items;
  final String? accountId;
  final String? flowId;
  final String? ddsConfig;

  final Function(String)? onCantFindItemClicked;
  final Function(AccountData)? onAccountCreated;
  final Function(AccountData)? onAccountConnected;
  final Function(AccountData)? onAccountRemoved;
  final Function(AccountData)? onAccountError;
  final Function(AccountData)? onDDSSuccess;
  final Function(AccountData)? onDDSError;
  final Function(FormData)? onFormSubmitted;
  final Function(FormData)? onDocumentsSubmitted;
  final Function(LinkError)? onError;
  final Function()? onClose;
  final Function(Function(String))? onTokenExpired;
  final Function(UIEvent)? onUiEvent;

  LinkConfig({
    required this.linkKey,
    required this.userToken,
    required this.sandbox,
    this.items,
    this.accountId,
    this.flowId,
    this.ddsConfig,
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

  static LinkConfig fromJson(
    String json,
    Function(String)? onCantFindItemClicked,
  ) {
    final params = jsonDecode(json);
    return LinkConfig(
      linkKey: params['linkKey'],
      userToken: params['userToken'],
      sandbox: params['sandbox'],
      items: params['items'],
      accountId: params['accountId'],
      flowId: params['flowId'],
      ddsConfig: params['ddsConfig'],
      onCantFindItemClicked:
          params['onCantFindItemClicked'] ? onCantFindItemClicked : null,
    );
  }
}
