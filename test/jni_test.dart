import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jni/jni.dart';

void main() {
  const MethodChannel channel = MethodChannel('jni');

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
    expect(await Jni.platformVersion, '42');
  });
}
