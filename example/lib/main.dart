import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jni/jni.dart';

late JClass _log = Jni.findClass('android/util/Log');
late JMethodId _loge =
    Jni.getStaticMethodId(_log, 'e', '(Ljava/lang/String;Ljava/lang/String;)I');

void loge(String tag, String message) {
  Jni.callStaticIntMethod(_log, _loge, tag, message);
}

void main() {
  // You need to attach the Dart isolate thread before calling into Java.
  Jni.attachToThread();
  // Wait a bit so the output is piped through the flutter tool.
  Future.delayed(const Duration(milliseconds: 1000), () {
    loge('AARON', 'Hello World!');
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Center(
          child: Text('Hello JNI (check logcat).\n'),
        ),
      ),
    );
  }
}
