#include <jni.h>
#include <stdint.h>

static JavaVM *s_vm = nullptr;
static JNIEnv* s_env = nullptr;

extern "C" {

__attribute__((visibility("default"))) __attribute__((used))
jint JNI_OnLoad(JavaVM *vm, void *reserved) {
  s_vm = vm;
  return JNI_VERSION_1_2;
}

__attribute__((visibility("default"))) __attribute__((used))
int32_t fjni_AttachCurrentThread() {
  jint result = s_vm->AttachCurrentThread(&s_env, nullptr);
  return result;
}

__attribute__((visibility("default"))) __attribute__((used))
jclass fjni_FindClass(const char* name) {
  jclass result = s_env->FindClass(name);
  return result;
}

__attribute__((visibility("default"))) __attribute__((used))
jfieldID fjni_GetStaticFieldId(jclass klass, const char* name, const char* sig) {
  return s_env->GetStaticFieldID(klass, name, sig);
}

__attribute__((visibility("default"))) __attribute__((used))
jmethodID fjni_GetStaticMethodId(jclass klass, const char* name, const char* sig) {
  return s_env->GetStaticMethodID(klass, name, sig);
}

__attribute__((visibility("default"))) __attribute__((used))
int32_t fjni_CallStaticIntMethod(jclass klass, jmethodID method, const char* x, const char* y) {
  jstring jstrX = s_env->NewStringUTF(x);
  jstring jstrY = s_env->NewStringUTF(y);
  return s_env->CallStaticIntMethod(klass, method, jstrX, jstrY);
}

}  // extern "C"