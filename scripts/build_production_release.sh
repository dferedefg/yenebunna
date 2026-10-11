#!/usr/bin/env bash
# ==============================================================================
# Yene Bunna (የኔ ቡና) — Ethiopian Specialty Coffee Marketplace
# Production Release Build & Verification Pipeline (APK / AAB / Web)
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

if [ ! -f "android/gradlew" ]; then
  echo "⚙️  Initializing missing platform wrappers..."
  flutter create . --platforms=android,ios,web --org com.yenebunna
fi

echo "☕ [1/5] Fetching Flutter dependencies & running static analysis..."
flutter pub get
flutter analyze

echo "🧪 [2/5] Running automated unit & widget test suite (test/marketplace_test.dart)..."
flutter test

echo "📱 [3/5] Building Installable Android Release APK (flutter build apk --release)..."
flutter build apk --release "${DART_DEFINES[@]}"

echo "📦 [4/5] Building Signed Android App Bundle (.aab) for Google Play..."
flutter build appbundle --release "${DART_DEFINES[@]}"

echo "🌐 [5/5] Building Production Web bundle..."
flutter build web --release "${DART_DEFINES[@]}"

echo "✅ Production release artifacts built:"
echo "   • Android APK : build/app/outputs/flutter-apk/app-release.apk"
echo "   • Play AAB    : build/app/outputs/bundle/release/app-release.aab"
echo "   • Web Bundle  : build/web"
