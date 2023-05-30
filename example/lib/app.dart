import 'package:argyle_link_flutter/account_data.dart';
import 'package:argyle_link_flutter/argyle_link.dart';
import 'package:argyle_link_flutter/form_data.dart';
import 'package:argyle_link_flutter/link_config.dart';
import 'package:flutter/material.dart';

import 'theme.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Palette.brandColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('📱️ Argyle Link SDK'),
        ),
        body: Container(
          alignment: AlignmentDirectional.center,
          child: ElevatedButton(
            onPressed: () {
              startArgyleSdk();
            },
            child: const Text('Start Argyle SDK'),
          )
        ),
      ),
    );
  }

  startArgyleSdk() {
    final config = LinkConfig(
      linkKey: 'YOUR_LINK_KEY',     // Get it from https://console.argyle.com/link-key
      userToken: 'YOUR_USER_TOKEN', // Should be fetched and provided by your own backend API https://argyle.com/docs/api-reference/users
      sandbox: true,

      // accountId: 'USER_ACCOUNT_ID', // Specify to take the user directly to the account
      // flowId: '00000000',           // Specify to use flows https://argyle.com/docs/console/flows
      // ddsConfig: 'YOUR_DDS_CONFIG', // Specify to use deposit switching https://argyle.com/docs/workflows/deposit-switching
      // items: ['item_000014039', 'item_000025742'], // Specify to limit search to the specified items only
    );
    configCallbacks(config);
    ArgyleLink.start(config);
  }

  configCallbacks(LinkConfig config) {
    config.onTokenExpired = (handler) {
      const newToken = 'YOUR_NEW_TOKEN';
      handler(newToken);
    };
    config.onAccountCreated = (accountData) =>
      print('onAccountCreated: $accountData');
    config.onAccountConnected = (accountData) =>
      printAccountData('onAccountConnected', accountData);
    config.onAccountRemoved = (accountData) =>
      printAccountData('onAccountRemoved', accountData);
    config.onAccountError = (accountData) =>
      printAccountData('onAccountError', accountData);
    config.onDDSSuccess = (accountData) =>
      printAccountData('onDDSSuccess', accountData);
    config.onDDSError = (accountData) =>
      printAccountData('onDDSError', accountData);
    config.onFormSubmitted = (formData) =>
      printFormData('onFormSubmitted', formData);
    config.onDocumentsSubmitted = (formData) =>
      printFormData('onDocumentsSubmitted', formData);
    config.onCantFindItemClicked = (term) =>
      print('onCantFindItemClicked(${term})');
    config.onError = (linkError) => print(
      'onError(\n'
      '\terrorType: ${linkError.errorType.name}\n'
      '\terrorMessage: ${linkError.errorMessage}\n'
      '${linkError.errorDetails != null ? '\terrorDetails: ${linkError.errorDetails}\n' : ''}'
      ')',
    );
    config.onClose = () => print('onClose');
    config.onUiEvent = (uiEvent) {
      final props = uiEvent.properties?.entries
        .map((e) => '\t\t${e.key}: ${e.value}')
        .join('\n');
      print(
        'onUIEvent(\n'
        '\tname: ${uiEvent.name}\n'
        '\tproperties:\n$props\n'
        ')',
      );
    };
  }

  printAccountData(String callbackName, AccountData accountData) {
    print('$callbackName: accountId: ${accountData.accountId} '
        'userId: ${accountData.userId} '
        'itemId: ${accountData.itemId}');
  }

  printFormData(String callbackName, FormData formData) {
    print('$callbackName: accountId: ${formData.accountId} '
        'userId: ${formData.userId}');
  }
}