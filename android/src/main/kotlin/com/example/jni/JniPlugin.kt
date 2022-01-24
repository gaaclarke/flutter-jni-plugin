package com.example.jni

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** JniPlugin */
class JniPlugin: FlutterPlugin {
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    System.loadLibrary("flutter_jni");
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }
}
