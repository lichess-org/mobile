#!/bin/sh
#
# Because Flutter is not adding the symbols of libapp.so to the App Bundle, this
# script create a native-debug-symbols folder including the libapp.so symbols that
# will be uploaded to the Play Console with Fastlane.
#
# See https://github.com/flutter/flutter/issues/170664.


# Go to project root dir
cd $(dirname $0)/../..

# Go to App Bundle files
cd build/app/outputs/bundle/release

mkdir native-debug-symbols

SYMBOLS_BUNDLE_PATH=BUNDLE-METADATA/com.android.tools.build.debugsymbols
unzip app-release.aab $SYMBOLS_BUNDLE_PATH/* -d tmp-extract-dir
cp -r tmp-extract-dir/$SYMBOLS_BUNDLE_PATH/* native-debug-symbols

cp symbols/app.android-arm64.symbols native-debug-symbols/arm64-v8a/libapp.so.dbg
cp symbols/app.android-arm.symbols   native-debug-symbols/armeabi-v7a/libapp.so.dbg
cp symbols/app.android-x64.symbols   native-debug-symbols/x86_64/libapp.so.dbg

cd native-debug-symbols
zip -r native-debug-symbols.zip .
