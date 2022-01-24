#include <cstdlib>
#include <cstring>
#include <jni.h>
#include <stdint.h>
#include <string>
#include <vector>

static JavaVM *s_vm = nullptr;
static JNIEnv *s_env = nullptr;

extern "C" {

__attribute__((visibility("default"))) __attribute__((used)) jint
JNI_OnLoad(JavaVM *vm, void *reserved) {
  s_vm = vm;
  return JNI_VERSION_1_2;
}

__attribute__((visibility("default"))) __attribute__((used)) int32_t
fjni_AttachCurrentThread() {
  jint result = s_vm->AttachCurrentThread(&s_env, nullptr);
  return result;
}

__attribute__((visibility("default"))) __attribute__((used)) jclass
fjni_FindClass(const char *name) {
  jclass result = s_env->FindClass(name);
  return result;
}

__attribute__((visibility("default"))) __attribute__((used)) jfieldID
fjni_GetStaticFieldId(jclass klass, const char *name, const char *sig) {
  return s_env->GetStaticFieldID(klass, name, sig);
}

__attribute__((visibility("default"))) __attribute__((used)) jmethodID
fjni_GetStaticMethodId(jclass klass, const char *name, const char *sig) {
  return s_env->GetStaticMethodID(klass, name, sig);
}

struct JniArgs {
  std::vector<jvalue> values;
  std::vector<std::string> strings;
};

__attribute__((visibility("default"))) __attribute__((used)) int32_t
fjni_CallStaticIntMethodA(jclass klass, jmethodID method, JniArgs *args) {
  return s_env->CallStaticIntMethodA(klass, method, args->values.data());
}

__attribute__((visibility("default"))) __attribute__((used)) JniArgs *
fjni_NewJniArgs() {
  return new JniArgs();
}

__attribute__((visibility("default"))) __attribute__((used)) void
fjni_JniArgsAddString(JniArgs *args, const char *str) {
  std::string cppStr(str);
  jvalue value;
  value.l = reinterpret_cast<jobject>(s_env->NewStringUTF(cppStr.c_str()));
  args->values.push_back(value);
  args->strings.emplace_back(std::move(cppStr));
}

__attribute__((visibility("default"))) __attribute__((used)) void
fjni_DeleteJniArgs(JniArgs *args) {
  delete args;
}

} // extern "C"
