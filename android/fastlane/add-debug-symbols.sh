#!/bin/sh
#
# Because Flutter is not adding the symbols of libapp.so to the App Bundle, this
# script add the libapp.so symbols to the App Bundle in order to upload them to
# the Play Console with Fastlane.
#
# See https://github.com/flutter/flutter/issues/170664.


# Go to project root dir
cd $(dirname $0)/../..

APPBUNDLE_DIR=build/app/outputs/bundle/release
cd $APPBUNDLE_DIR

SYMBOLS_DIR=symbols
SYMBOLS_BUNDLE=BUNDLE-METADATA/com.android.tools.build.debugsymbols

mkdir -p $SYMBOLS_BUNDLE/{arm64-v8a,armeabi-v7a,x86_64}

cp $SYMBOLS_DIR/app.android-arm64.symbols $SYMBOLS_BUNDLE/arm64-v8a/libapp.so.dbg
cp $SYMBOLS_DIR/app.android-arm.symbols   $SYMBOLS_BUNDLE/armeabi-v7a/libapp.so.dbg
cp $SYMBOLS_DIR/app.android-x64.symbols   $SYMBOLS_BUNDLE/x86_64/libapp.so.dbg

zip -r app-release.aab BUNDLE-METADATA
