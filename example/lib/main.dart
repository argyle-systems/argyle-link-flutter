import 'package:argyle_link_flutter/account_data.dart';
import 'package:argyle_link_flutter/argyle_link.dart';
import 'package:argyle_link_flutter/form_data.dart';
import 'package:argyle_link_flutter/link_config.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String log = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Argyle Flutter App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Callback Log',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(log),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  startArgyleSdk();
                },
                child: const Text('Start Argyle SDK'),
              )
            ],
          ),
        ),
      ),
    );
  }

  startArgyleSdk() {
    final config = createLinkConfig();
    ArgyleLink.start(config);
  }

  createLinkConfig() => LinkConfig(
        linkKey: 'YOUR_LINK_KEY',     // Get it from https://console.argyle.com/link-key
        userToken: 'YOUR_USER_TOKEN', // Should be fetched and provided by your own backend API https://argyle.com/docs/api-reference/users
        sandbox: true,

        // accountId: 'USER_ACCOUNT_ID', // Specify to take the user directly to the account
        // flowId: '00000000',           // Specify to use flows https://argyle.com/docs/console/flows
        // ddsConfig: 'YOUR_DDS_CONFIG', // Specify to use deposit switching https://argyle.com/docs/workflows/deposit-switching
        // items: ['item_000014039', 'item_000025742'], // Specify to limit search to the specified items only

        onTokenExpired: (handler) {
          const newToken = 'YOUR_NEW_TOKEN';
          handler(newToken);
        },
        onAccountCreated: (accountData) =>
            logCallbackWithAccountData('onAccountCreated', accountData),
        onAccountConnected: (accountData) =>
            logCallbackWithAccountData('onAccountConnected', accountData),
        onAccountRemoved: (accountData) =>
            logCallbackWithAccountData('onAccountRemoved', accountData),
        onAccountError: (accountData) =>
            logCallbackWithAccountData('onAccountError', accountData),
        onDDSSuccess: (accountData) =>
            logCallbackWithAccountData('onDDSSuccess', accountData),
        onDDSError: (accountData) =>
            logCallbackWithAccountData('onDDSError', accountData),
        onFormSubmitted: (formData) =>
            logCallbackWithFormData('onFormSubmitted', formData),
        onDocumentsSubmitted: (formData) =>
            logCallbackWithFormData('onDocumentsSubmitted', formData),
        onError: (linkError) => appendLogMessage(
          'onError(\n'
          '\terrorType: ${linkError.errorType.name}\n'
          '\terrorMessage: ${linkError.errorMessage}\n'
          '${linkError.errorDetails != null ? '\terrorDetails: ${linkError.errorDetails}\n' : ''}'
          ')',
        ),
        onClose: () => appendLogMessage('onClose'),
        onUiEvent: (uiEvent) {
          final props = uiEvent.properties?.entries
              .map((e) => '\t\t${e.key}: ${e.value}')
              .join('\n');
          appendLogMessage(
            'onUIEvent(\n'
            '\tname: ${uiEvent.name}\n'
            '\tproperties:\n$props\n'
            ')',
          );
        },
      );

  logCallbackWithAccountData(String callbackName, AccountData accountData) {
    appendLogMessage('$callbackName: accountId: ${accountData.accountId} '
        'userId: ${accountData.userId} '
        'itemId: ${accountData.itemId}');
  }

  logCallbackWithFormData(String callbackName, FormData formData) {
    appendLogMessage('$callbackName: accountId: ${formData.accountId} '
        'userId: ${formData.userId}');
  }

  appendLogMessage(String message) {
    setState(() {
      log += '$message\n';
    });
  }
}
