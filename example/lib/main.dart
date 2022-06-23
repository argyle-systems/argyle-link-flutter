import 'package:argyle_link_flutter/argyle.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Map<String, String> sdkCallbackEvents = {};

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  void addSdkCallbackEventToList(String eventName, [String eventParams = ""]) {
    setState(() {
      sdkCallbackEvents[eventName] =  eventParams;
    });
  }

  void clearCallbackList() {
    setState(() {
      sdkCallbackEvents.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Argyle Flutter App'),
        ),
        body: Column(children: <Widget>[
          const SizedBox(height: 10),
          const Text(
              "Callback Log",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          ),
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: sdkCallbackEvents.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = sdkCallbackEvents.keys.elementAt(index);

                    return Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(2),
                        color: Colors.grey[400],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Callback: $key",
                                style: const TextStyle(fontSize: 20, color: Colors.black45, fontWeight: FontWeight.bold)
                            ),
                            const SizedBox(height: 10),
                            const Text(
                                "Params:",
                                style: TextStyle(fontSize: 18)
                            ),
                            Text(
                                "${sdkCallbackEvents[key]}",
                                style: const TextStyle(fontSize: 14, color: Colors.black45)
                            )
                          ],
                        )
                    );
                  })),
          ElevatedButton(
              onPressed: () {
                clearCallbackList();
                startArgyleSdk();
              },
              child: const Text('Start Argyle SDK'))
        ]),
      ),
    );
  }

  void startArgyleSdk() {
    Argyle.startSdk(
        configuration: createConfig(),
        onAccountConnected: onAccountConnectedHandler,
        onAccountCreated: onAccountCreatedHandler,
        onAccountRemoved: onAccountRemovedHandler,
        onAccountUpdated: onAccountUpdatedHandler,
        onAccountError: onAccountErrorHandler,
        onUserCreated: onUserCreatedHandler,
        onPayDistributionError: onPayDistributionErrorHandler,
        onPayDistributionSuccess: onPayDistributionSuccessHandler,
        onUIEvent: onUiEventHandler,
        onDocumentsSubmitted: onDocumentsSubmittedHandler,
        onFormSubmitted: onFormSubmittedHandler,
        onError: onErrorHandler,
        onClose: () {});
  }

  onUiEventHandler(String name, Map<String, Object> properties) {
    addSdkCallbackEventToList(
        "onUIEvent", name + " " + properties.toString());
  }

  onPayDistributionSuccessHandler(String accountId, String userId, String linkItemId) {
    addSdkCallbackEventToList("onPayDistributionSuccess", getFormattedParams(accountId, userId, linkItemId));
  }

  onPayDistributionErrorHandler(String accountId, String userId, String linkItemId) {
    addSdkCallbackEventToList("onPayDistributionError", getFormattedParams(accountId, userId, linkItemId));
  }

  onErrorHandler(String errorCode) {
    addSdkCallbackEventToList("onError", "ErrorCode: $errorCode");
  }

  onUserCreatedHandler(String userToken, String userId) {
    addSdkCallbackEventToList(
        "onUserCreated", "UserToken: $userToken \nUserId: $userId");
  }

  onAccountErrorHandler(String accountId, String userId, String linkItemId) {
    addSdkCallbackEventToList("onAccountError", getFormattedParams(accountId, userId, linkItemId));
  }

  onAccountCreatedHandler(String accountId, String userId, String linkItemId) {
    addSdkCallbackEventToList("onAccountCreated", getFormattedParams(accountId, userId, linkItemId));
  }

  onAccountConnectedHandler(String accountId, String userId, String linkItemId) {
    addSdkCallbackEventToList("onAccountConnected", getFormattedParams(accountId, userId, linkItemId));
  }

  onAccountRemovedHandler(String accountId, String userId, String linkItemId) {
    addSdkCallbackEventToList("onAccountRemoved", getFormattedParams(accountId, userId, linkItemId));
  }

  onAccountUpdatedHandler(String accountId, String userId, String linkItemId) {
    addSdkCallbackEventToList("onAccountUpdated", getFormattedParams(accountId, userId, linkItemId));
  }

  onDocumentsSubmittedHandler(String accountId, String userId) {
    addSdkCallbackEventToList(
        "onDocumentsSubmitted", "AccountId: $accountId \nUserId: $userId");
  }

  onFormSubmittedHandler(String accountId, String userId) {
    addSdkCallbackEventToList(
        "onFormSubmittedHandler", "AccountId: $accountId \nUserId: $userId");
  }
}

getFormattedParams(String accountId, String userId, String linkItemId) {
  return "AccountID: $accountId \nUserId: $userId \nLinkItemId: $linkItemId";
}

createConfig() {
  return <String, Object>{
    'linkKey': '[YOUR LINK KEY]',
    // 'linkItems' : ['kroger', 'uber'],
    // 'cantFindLinkItemCallback' : true
    // 'customizationId' : 'CREATE A CUSTOMISATION IN CONSOLE',
    // 'payDistributionItemsOnly' : false,
    // 'showCantFindLinkItemAtTop' : false
    // 'payDistributionConfig' : 'CiQAzxhtktpPeu3esWpJA7+Ka8ru9jJCzZ04ZH/HxGX7G2X6wwUSjwIAW+ch9IEKQpwr20FhPEtN/z261Lh2PqN4NpO9t3FeYWA7iKBUmQwoE9TOqz3UErv43uK+5BqluRw2ZYpviPEMZilCVOi1Mg3cwLFNkVypkJ+++z1/I4Mb7mZSheosaCrBQv7cfkvJoFsiC9mS0VXC0Uj1Wqwr+GsNC5qf8JE5ZYi1RBHTteNWL27625YiUSPROVtiSeS87r1amXx0dHb/e2SvQ1nG4V2pcsOKeh+262ySbWUsHBqIN/60LODMtu4C4UXI5GhqfvGTj9fbPnF1qwIpCqFEcsBPrFDKtOoXJBeIuWupT3gOA2sbY+iypua2BtgSUqprSu7GMJwrP1Apk8aYm1WtXwhXAJYH7ve6'
  };
}
