import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vpon_sdk/vpon_sdk_method_channel.dart';

void main() {
  MethodChannelVponSdk platform = MethodChannelVponSdk();
  const MethodChannel channel = MethodChannel('vpon_sdk');

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
    expect(await platform.getPlatformVersion(), '42');
  });
}
