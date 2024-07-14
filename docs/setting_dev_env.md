# Setting up the development environment

The following instructions outline how to set up your development environment for starting development on Lichess mobile.

If you get stuck during the installation process the most suitable place to seek help is the `#lichess-dev-onboarding` channel on Discord (https://discord.gg/lichess).

This project uses Flutter. The best way to get started is to follow [the flutter install guide](https://docs.flutter.dev/get-started/install).
Installing on Linux using `snapd` might cause some [problems](../../issues/123) building stockfish. Installing flutter manually is a known workaround.

This project is meant to run on iOS and Android, so you need to follow the "Platform setup" section of that guide to install the iOS and/or Android platform.

Note that this application is not meant to be run on web platform.

## Setting up the emulators

### iOS

Simply follow the instructions in the flutter guide to install Xcode and the iOS
simulator.


### Android

If you are working with a local `lila` server, you need to expose some ports from the emulator. You can do this by running the following command (once the emulator is running):

```bash
adb reverse tcp:9663 tcp:9663
adb reverse tcp:9664 tcp:9664
```

This will allow the app to communicate with the local server. 9663 is for `http`
and 9664 is for `websocket`. It assumes that the server is running on the
default ports.

#### Troubleshooting

If Chrome instacrashes, it is likely you need to disable vulkan in emulator settings.

If you cannot access internet you can try launching the emulator with a DNS address:

```
$ emulator -avd <YourAVD> -dns-server 1.1.1.1
```

If you experience high lags or freezes, check the memory settings and be sure to enable hardware acceleration. Also disabling the snapshot storage may help:

```
$ emulator -avd <YourAVD> -no-snapshot-load -no-snapstorage -no-snapshot -no-snapshot-save'
```

## Code generation

This project uses code generation to generate data classes with [freezed](https://pub.dev/packages/freezed) among other things.

You need to run it before anything else otherwise the project won't compile:

```
dart run build_runner build
```

While developing you can use the watch command:

```
dart run build_runner watch
```

## Static analysis

Flutter comes with an `analyze` command to run static analysis. While developing you can run:

```
flutter analyze --watch
```

It will run analysis continuously, watching the filesystem for changes. It is important to always check for analysis errors.


## Run

Use the `flutter run` command to run on an emulator or device. If you need to change the lichess host you can do it like so:

```
flutter run --dart-define=LICHESS_HOST=lichess.dev
--dart-define=LICHESS_WS_HOST=socket.lichess.dev
```
