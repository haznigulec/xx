#!/bin/bash
set -euo pipefail

# Defaults
env="prod"
target="both"
entry="lib/main.dart"
pTag="\033[1;33m[PIAPIRI]\033[0m"
programname=$0
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
build_apk_only=0        # --apk verilirse AAB yerine sadece APK üretilecek
android_flavor="prod"   # env'e göre aşağıda güncellenecek

usage() {
  echo ""
  echo "Create AAB or APK and IPA for the app"
  echo ""
  echo "usage: $programname --env string --target string [--apk]"
  echo ""
  echo "  --env string            env to which to deploy"
  echo "                          default: prod"
  echo "                          options: dev | qa | prod"
  echo "  --target string         target operating system"
  echo "                          default: both"
  echo "                          options: ios | android"
  echo "  --apk                   ANDROID için AAB yerine sadece APK üret"
  echo ""
}

clean_build() {
  echo -e "$pTag Clearing . . ."
  flutter clean
}

getpkg() {
  echo -e "$pTag Getting packages . . ."
  flutter pub get
}

# pub.dev cleartext içeren example'ları temizle
# example dışındaki TRUE durumunda script HATA verip build'i kesecek
clean_pubdev_cleartext() {
  echo -e "$pTag Cleaning pub.dev cleartext examples . . ."
  "$SCRIPT_DIR/clean_pubdev_cleartext.sh"
}

buildrunner() {
  echo -e "$pTag Creating routes (build_runner) . . ."
  flutter pub run build_runner build --delete-conflicting-outputs
}

build_android() {
  if [[ "$build_apk_only" -eq 1 ]]; then
    echo -e "$pTag Building ANDROID APK (env: $env, flavor: $android_flavor, entry: $entry) . . ."
    flutter build apk \
      --flavor "$android_flavor" \
      --release \
      --target "$entry" \
      --no-tree-shake-icons
    echo -e "$pTag Android APK built successfully."
  else
    echo -e "$pTag Building ANDROID AAB (appbundle) (env: $env, flavor: $android_flavor, entry: $entry) . . ."
    flutter build appbundle \
      --flavor "$android_flavor" \
      --release \
      --target "$entry" \
      --no-tree-shake-icons
    echo -e "$pTag Android appbundle (AAB) built successfully."
  fi
}

build_ios() {
  echo -e "$pTag Building IOS IPA (env: $env, entry: $entry) . . ."
  flutter build ipa \
    --flavor prod \
    --target "$entry"
  echo -e "$pTag IPA built successfully."
}

# ---- Argüman parsing ----
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
    --env)
      if [[ -z "${2-}" ]]; then
        echo -e "$pTag Missing value for --env"
        exit 1
      fi
      env="$2"
      shift 2
      ;;
    --target)
      if [[ -z "${2-}" ]]; then
        echo -e "$pTag Missing value for --target"
        exit 1
      fi
      target="$2"
      shift 2
      ;;
    --apk)
      build_apk_only=1
      shift 1
      ;;
    *)
      echo -e "$pTag Unknown argument: $1"
      echo -e "$pTag Use --help for usage."
      exit 1
      ;;
  esac
done

echo -e "$pTag Building app with env: $env and target: $target (apk_only=$build_apk_only)"

# ---- Env'e göre entry + android_flavor seçimi ----
case "$env" in
  dev)
    entry="lib/main_dev.dart"
    android_flavor="dev"
    ;;
  qa)
    entry="lib/main_qa.dart"
    android_flavor="qa"
    ;;
  prod)
    entry="lib/main.dart"
    android_flavor="prod"
    ;;
  *)
    echo -e "$pTag Unknown env: $env (allowed: dev | qa | prod)"
    exit 1
    ;;
esac

# ---- Build akışı ----
if [[ "$target" == "ios" ]]; then
  clean_build
  getpkg
  clean_pubdev_cleartext
  buildrunner
  build_ios
elif [[ "$target" == "android" ]]; then
  clean_build
  getpkg
  clean_pubdev_cleartext
  buildrunner
  build_android
elif [[ "$target" == "both" ]]; then
  clean_build
  getpkg
  clean_pubdev_cleartext
  buildrunner
  build_android
  build_ios
else
  echo -e "$pTag Unknown target: $target (allowed: ios | android | both)"
  exit 1
fi

echo -e "$pTag Build completed successfully."


# =========================
# DEV ENVIRONMENT
# =========================

# DEV - Android (AAB)
# ./app_build.sh --env dev --target android

# DEV - Android (APK)
# ./app_build.sh --env dev --target android --apk

# DEV - iOS (IPA)
# ./app_build.sh --env dev --target ios

# DEV - Both (Android AAB + iOS)
# ./app_build.sh --env dev --target both

# DEV - Both (Android APK + iOS)
# ./app_build.sh --env dev --target both --apk


# =========================
# QA ENVIRONMENT
# =========================

# QA - Android (AAB)
# ./app_build.sh --env qa --target android

# QA - Android (APK)
# ./app_build.sh --env qa --target android --apk

# QA - iOS (IPA)
# ./app_build.sh --env qa --target ios

# QA - Both (Android AAB + iOS)
# ./app_build.sh --env qa --target both

# QA - Both (Android APK + iOS)
# ./app_build.sh --env qa --target both --apk


# =========================
# PROD ENVIRONMENT
# =========================

# PROD - Android (AAB)
# ./app_build.sh --env prod --target android

# PROD - Android (APK)
# ./app_build.sh --env prod --target android --apk

# PROD - iOS (IPA)
# ./app_build.sh --env prod --target ios

# PROD - Both (Android AAB + iOS)
# ./app_build.sh --env prod --target both

# PROD - Both (Android APK + iOS)
# ./app_build.sh --env prod --target both --apk
