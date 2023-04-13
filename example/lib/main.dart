import 'dart:convert';

import 'package:argyle_link_flutter/account_data.dart';
import 'package:argyle_link_flutter/argyle_link.dart';
import 'package:argyle_link_flutter/form_data.dart';
import 'package:argyle_link_flutter/link_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  final jsonConfigInputController = TextEditingController();

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
              Row(
                children: [
                  const Text(
                    'Json Config',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 4),
                  ElevatedButton(
                    onPressed: () {
                      jsonConfigInputController.text = "";
                    },
                    child: const Text('clear'),
                  ),
                  SizedBox(width: 4),
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.getData(Clipboard.kTextPlain).then((value) {
                        jsonConfigInputController.text = value?.text ?? "";
                      });
                    },
                    child: const Text('paste'),
                  )
                ]
              ),
              TextField(
                controller: jsonConfigInputController,
                style: TextStyle(fontSize: 12),
                keyboardType: TextInputType.multiline,
                maxLines: 10,
              ),
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
    clearLog();

    final jsonConfig = jsonConfigInputController.text;
    if (!jsonConfig.isEmpty) {
      startArgyleSdkFromJson(jsonConfig);
      return;
    }

    final config = createLinkConfig();
    configCallbacks(config, true);
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
  );

  configCallbacks(LinkConfig config, bool setOnCantFindItemClicked) {
    config.onTokenExpired = (handler) {
      const newToken = 'YOUR_NEW_TOKEN';
      handler(newToken);
    };
    config.onAccountCreated = (accountData) =>
      logCallbackWithAccountData('onAccountCreated', accountData);
    config.onAccountConnected = (accountData) =>
      logCallbackWithAccountData('onAccountConnected', accountData);
    config.onAccountRemoved = (accountData) =>
      logCallbackWithAccountData('onAccountRemoved', accountData);
    config.onAccountError = (accountData) =>
      logCallbackWithAccountData('onAccountError', accountData);
    config.onDDSSuccess = (accountData) =>
      logCallbackWithAccountData('onDDSSuccess', accountData);
    config.onDDSError = (accountData) =>
      logCallbackWithAccountData('onDDSError', accountData);
    config.onFormSubmitted = (formData) =>
      logCallbackWithFormData('onFormSubmitted', formData);
    config.onDocumentsSubmitted = (formData) =>
      logCallbackWithFormData('onDocumentsSubmitted', formData);
    if (setOnCantFindItemClicked) {
      config.onCantFindItemClicked = (term) =>
        appendLogMessage('onCantFindItemClicked(${term})');
    }
    config.onError = (linkError) => appendLogMessage(
      'onError(\n'
      '\terrorType: ${linkError.errorType.name}\n'
      '\terrorMessage: ${linkError.errorMessage}\n'
      '${linkError.errorDetails != null ? '\terrorDetails: ${linkError.errorDetails}\n' : ''}'
      ')',
    );
    config.onClose = () => appendLogMessage('onClose');
    config.onUiEvent = (uiEvent) {
      final props = uiEvent.properties?.entries
          .map((e) => '\t\t${e.key}: ${e.value}')
          .join('\n');
      appendLogMessage(
        'onUIEvent(\n'
        '\tname: ${uiEvent.name}\n'
        '\tproperties:\n$props\n'
        ')',
      );
    };
  }

  startArgyleSdkFromJson(String json) {
    final params = jsonDecode(json);
    final config = createConfigFromJson(params);
    appendLogMessage('${config.linkKey}');
    configCallbacks(config, params['onCantFindItemClicked'] == true);
    ArgyleLink.start(config);
  }

  createConfigFromJson(Map params) =>
    LinkConfig(
      linkKey: params['linkKey'],
      userToken: params['userToken'],
      sandbox: true,
      items: params['items'],
      accountId: params['accountId'],
      customizationId: params['customizationId'],
      flowId: params['flowId'],
      ddsConfig: params['ddsConfig'],
      apiHost: params['apiHost']
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

  clearLog() => setState(() { log = ''; });
}
