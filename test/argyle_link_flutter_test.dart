import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:argyle_link_flutter/argyle_link_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('argyle_link_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await ArgyleLinkFlutter.platformVersion, '42');
  });
}
