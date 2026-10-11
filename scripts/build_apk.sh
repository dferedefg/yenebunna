#!/usr/bin/env bash
# ==============================================================================
# Yene Bunna (የኔ ቡና) — Ethiopian Specialty Coffee Marketplace
# 1-Command Android APK Builder (`flutter build apk --release`)
# ==============================================================================
set -euo pipefail

PARSE_APP_ID="${PARSE_APP_ID:-DYcuDNOm8aWRjpRUtPk3UQCmCguPYrwLzOzsW4Bo}"
PARSE_CLIENT_KEY="${PARSE_CLIENT_KEY:-4D6sGLUzFF8bxxUVaLuhhCqxGuu3YLms1NgWJD3o}"
PARSE_SERVER_URL="${PARSE_SERVER_URL:-https://parseapi.back4app.com}"

DART_DEFINES=(
  "--dart-define=PARSE_APP_ID=${PARSE_APP_ID}"
  "--dart-define=PARSE_CLIENT_KEY=${PARSE_CLIENT_KEY}"
  "--dart-define=PARSE_SERVER_URL=${PARSE_SERVER_URL}"
)

# Ensure Gradle wrapper & mipmap launcher icons exist without overwriting custom code
if [ ! -f "android/gradlew" ]; then
  echo "⚙️  Initializing Android Gradle wrapper & platform scaffolding..."
  flutter create . --platforms=android --org com.yenebunna
fi

echo "☕ [1/3] Fetching Flutter packages..."
flutter pub get

echo "📦 [2/3] Building Universal Release APK (flutter build apk --release)..."
flutter build apk --release "${DART_DEFINES[@]}"

echo "📦 [3/3] Building Split-ABI Release APKs (arm64-v8a / armeabi-v7a / x86_64)..."
flutter build apk --split-per-abi --release "${DART_DEFINES[@]}"

echo ""
echo "✅ Android APK Build Complete!"
echo "   • Universal APK : build/app/outputs/flutter-apk/app-release.apk"
echo "   • ARM64 APK     : build/app/outputs/flutter-apk/app-arm64-v8a-release.apk"
