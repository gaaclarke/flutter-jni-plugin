import 'dart:ffi';
import 'dart:io';
import "package:ffi/ffi.dart";

class JClass {
  final Pointer<_JClass> pointer;
  JClass(this.pointer);
}

class _JClass extends Opaque {}

class JFieldId {
  final Pointer<_JFieldId> pointer;
  JFieldId(this.pointer);
}

class _JFieldId extends Opaque {}

class JMethodId {
  final Pointer<_JMethodId> pointer;
  JMethodId(this.pointer);
}

class _JMethodId extends Opaque {}

class Jni {
  static final DynamicLibrary nativeAddLib = Platform.isAndroid
      ? DynamicLibrary.open('libflutter_jni.so')
      : DynamicLibrary.process();

  static final int Function() attachToThread = nativeAddLib
      .lookup<NativeFunction<Int32 Function()>>('fjni_AttachCurrentThread')
      .asFunction();

  static JClass findClass(String path) {
    Pointer<Utf8> bar = path.toNativeUtf8();
    return JClass(_findClass(bar));
  }

  static final _findClass = nativeAddLib.lookupFunction<
      Pointer<_JClass> Function(Pointer<Utf8> str),
      Pointer<_JClass> Function(Pointer<Utf8> str)>('fjni_FindClass');

  static JFieldId getStaticFieldId(
      JClass klass, String name, String signature) {
    return JFieldId(_getStaticFieldId(
        klass.pointer, name.toNativeUtf8(), signature.toNativeUtf8()));
  }

  static final _getStaticFieldId = nativeAddLib.lookupFunction<
      Pointer<_JFieldId> Function(
          Pointer<_JClass>, Pointer<Utf8>, Pointer<Utf8>),
      Pointer<_JFieldId> Function(Pointer<_JClass>, Pointer<Utf8>,
          Pointer<Utf8>)>('fjni_GetStaticFieldId');

  static JMethodId getStaticMethodId(
      JClass klass, String name, String signature) {
    return JMethodId(_getStaticMethodId(
        klass.pointer, name.toNativeUtf8(), signature.toNativeUtf8()));
  }

  static final _getStaticMethodId = nativeAddLib.lookupFunction<
      Pointer<_JMethodId> Function(
          Pointer<_JClass>, Pointer<Utf8>, Pointer<Utf8>),
      Pointer<_JMethodId> Function(Pointer<_JClass>, Pointer<Utf8>,
          Pointer<Utf8>)>('fjni_GetStaticMethodId');

  // This function is hardcoded to take 2 strings as parameters.  We'd probably
  // have to use code generation to generate all the variants we'd need since
  // reflection isn't an option.
  static int callStaticIntMethod(
      JClass klass, JMethodId method, String x, String y) {
    return _callStaticIntMethod(
        klass.pointer, method.pointer, x.toNativeUtf8(), y.toNativeUtf8());
  }

  static final _callStaticIntMethod = nativeAddLib.lookupFunction<
      Int32 Function(
          Pointer<_JClass>, Pointer<_JMethodId>, Pointer<Utf8>, Pointer<Utf8>),
      int Function(Pointer<_JClass>, Pointer<_JMethodId>, Pointer<Utf8>,
          Pointer<Utf8>)>('fjni_CallStaticIntMethod');
}
