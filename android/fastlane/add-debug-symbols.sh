#!/bin/sh
#
# Because Flutter is not adding the symbols of libapp.so to the App Bundle, this
# script add the libapp.so symbols to the archive native-debug-symbols.zip in order
# to upload them to the Play Console with Fastlane.
#
# See https://github.com/flutter/flutter/issues/170664.

cd $(dirname $0)/../..
SYMBOLS_DIR=build/app/outputs/native-debug-symbols/release
LIBAPP_DIR=build/app/outputs/bundle/release/symbols

mkdir -p $SYMBOLS_DIR/{arm64-v8a,armeabi-v7a,x86_64}

cp $LIBAPP_DIR/app.android-arm64.symbols $SYMBOLS_DIR/arm64-v8a/libapp.so.dbg
cp $LIBAPP_DIR/app.android-arm.symbols   $SYMBOLS_DIR/armeabi-v7a/libapp.so.dbg
cp $LIBAPP_DIR/app.android-x64.symbols   $SYMBOLS_DIR/x86_64/libapp.so.dbg

cd $SYMBOLS_DIR
zip -r native-debug-symbols.zip arm64-v8a armeabi-v7a x86_64
