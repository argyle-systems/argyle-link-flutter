
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
  final List<String> sdkCallbackEvents = <String>[];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  void addSdkCallbackEventToList(String eventDetails) {
    setState(() {
      sdkCallbackEvents.add(eventDetails);
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
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: sdkCallbackEvents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 100,
                      margin: const EdgeInsets.all(2),
                      color: Colors.blue[400],
                      child: Center(
                          child: Text(
                        sdkCallbackEvents[index],
                        style: const TextStyle(fontSize: 18),
                      )),
                    );
                  })),
          ElevatedButton(
              onPressed: () {
                Argyle.startSdk(
                    configuration: createConfig(),
                    onAccountConnected:
                        (String accountId, String userId, String linkItemId) {
                      addSdkCallbackEventToList("onAccountConnected " +
                          accountId +
                          " " +
                          userId +
                          " " +
                          linkItemId);
                    },
                    onAccountCreated:
                        (String accountId, String userId, String linkItemId) {
                      addSdkCallbackEventToList("onAccountCreated " +
                          accountId +
                          " " +
                          userId +
                          " " +
                          linkItemId);
                    },
                    onAccountError:
                        (String accountId, String userId, String linkItemId) {
                      addSdkCallbackEventToList("onAccountError " +
                          accountId +
                          " " +
                          userId +
                          " " +
                          linkItemId);
                    },
                    onClose:
                        (String accountId, String userId, String linkItemId) {
                      addSdkCallbackEventToList("onClose");
                    },
                    onUserCreated: (String userToken, String userId) {
                      addSdkCallbackEventToList(
                          "onUserCreated " + userToken + " " + userId);
                    },
                    onError:
                        (String accountId, String userId, String linkItemId) {
                      addSdkCallbackEventToList("onError");
                    },
                    onPayDistributionError:
                        (String accountId, String userId, String linkItemId) {
                      addSdkCallbackEventToList("onPayDistributionError " +
                          accountId +
                          " " +
                          userId +
                          " " +
                          linkItemId);
                    },
                    onPayDistributionSuccess:
                        (String accountId, String userId, String linkItemId) {
                      addSdkCallbackEventToList("onPayDistributionSuccess " +
                          accountId +
                          " " +
                          userId +
                          " " +
                          linkItemId);
                    },
                    onUIEvent: (String name, Map<String, Object> properties) {
                      addSdkCallbackEventToList(
                          "onUIEvent " + properties.toString());
                    });
              },
              child: const Text('Start Argyle SDK'))
        ]),
      ),
    );
  }
}

createConfig() {
  return <String, Object>{
    'linkKey': '017cf0de-aac1-e1c4-b86c-7d9dffbfc8ed',
    'apiHost': 'https://api-sandbox.argyle.com/v1',
  };
}
