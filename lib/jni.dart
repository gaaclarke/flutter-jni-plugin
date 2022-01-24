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

// dart:ffi doesn't handle variadic functions well.  Since we don't have
// reflection or metaprogramming we build up the list of arguments in an object
// at runtime.
class JniArgs {
  Pointer<_JniArgs> pointer;

  JniArgs() : pointer = Jni._newJniArgs();

  void _clear() {
    Jni._deleteJniArgs(pointer);
    pointer = Pointer<_JniArgs>.fromAddress(0);
  }

  JniArgs addString(String string) {
    assert(pointer.address != 0);
    Jni._jniArgsAddString(pointer, string.toNativeUtf8());
    return this;
  }
}

class _JniArgs extends Opaque {}

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

  static int callStaticIntMethodA(
      JClass klass, JMethodId method, JniArgs args) {
    int result =
        _callStaticIntMethodA(klass.pointer, method.pointer, args.pointer);
    args._clear();
    return result;
  }

  static final _callStaticIntMethodA = nativeAddLib.lookupFunction<
      Int32 Function(Pointer<_JClass>, Pointer<_JMethodId>, Pointer<_JniArgs>),
      int Function(Pointer<_JClass>, Pointer<_JMethodId>,
          Pointer<_JniArgs>)>('fjni_CallStaticIntMethodA');

  static final _newJniArgs = nativeAddLib.lookupFunction<
      Pointer<_JniArgs> Function(),
      Pointer<_JniArgs> Function()>('fjni_NewJniArgs');

  static final _jniArgsAddString = nativeAddLib.lookupFunction<
      Void Function(Pointer<_JniArgs>, Pointer<Utf8>),
      void Function(Pointer<_JniArgs>, Pointer<Utf8>)>('fjni_JniArgsAddString');

  static final _deleteJniArgs = nativeAddLib.lookupFunction<
      Void Function(Pointer<_JniArgs>),
      void Function(Pointer<_JniArgs>)>('fjni_DeleteJniArgs');
}
