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

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Argyle Flutter App'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: (){
              Argyle.startSdk(configuration: createConfig(),
                onAccountConnected: (String accountId) {
                  print("- onAccountConnected: $accountId");
                }
              );
            },
            child: const Text("Start Argyle SDK"),
          ),
        ),

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
