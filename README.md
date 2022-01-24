# flutter-jni-plugin

This is a proof of concept that a JNI Flutter plugin could be created with
dart:ffi.

Here is example usage of the plugin:

```dart
import 'package:jni/jni.dart';

void main() {
  Jni.attachToThread();
  JClass log = Jni.findClass('android/util/Log');
  JMethodId loge =
    Jni.getStaticMethodId(log, 'e', '(Ljava/lang/String;Ljava/lang/String;)I');
  Jni.callStaticIntMethod(log, loge, 'AARON', 'Hello World!');
}
```
