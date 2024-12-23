# Setting up the development environment

The following instructions outline how to set up your development environment for starting development on Lichess mobile.

If you get stuck during the installation process the most suitable place to seek help is the `#lichess-dev-onboarding` channel on Discord (https://discord.gg/lichess).

## Installing Flutter

This project uses Flutter.

1. Follow [the flutter install guide](https://docs.flutter.dev/get-started/install).
   This project is meant to run on iOS and Android, so you need to follow the "Platform setup" section of that guide to
   install the iOS and/or Android platform.
> [!WARNING]
> Installing on Linux using `snapd` might cause some [problems](../../issues/123) building stockfish.
> Installing flutter manually is a known workaround.
2. Switch to the beta channel by running `flutter channel beta` and `flutter upgrade`
> [!NOTE]
> We'll use Flutter's `beta` channel while the app itself is in Beta.
3. Ensure Flutter is correctly configured by running `flutter doctor`

Note that this application is not meant to be run on web platform.

### Flutter Version Management

If you want to use FVM to manage your Flutter versions effectively, please consult the [FVM (Flutter Version Management) guide](https://fvm.app/documentation/getting-started/installation) for comprehensive instructions on installing Flutter on your specific operating system.

This project is currently using FVM 3.x.

**Pro Tip:** Remember to prepend the 'flutter' prefix when using FVM commands, like this: `fvm flutter [command]`.

## Lila Server

By default, the app will target the [Lichess dev server](https://lichess.dev/),
so you can start developing without setting up a local server.

During development, you may need a local [lila](https://github.com/lichess-org/lila) (lichess server scala app)
instance to work on this project.

If you work with a local lila, you will also need to setup [lila-ws](https://github.com/lichess-org/lila-ws) (websocket server).

### lila-docker

The fastest and most straight-forward way to get started is using [lila-docker](https://github.com/lichess-org/lila-docker).

### Local lila server (manual installation)

Instructions to install both `lila` and `lila-ws` locally can be found in [the lila wiki](https://github.com/lichess-org/lila/wiki/Lichess-Development-Onboarding).

**Do not use any scheme (https:// or ws://) in url in host, since it's already handled by URI helper methods**

To run the application with a local server, you can use the following command:

```bash
flutter run --dart-define=LICHESS_HOST=localhost:9663 --dart-define=LICHESS_WS_HOST=localhost:9664
```

> [!NOTE]
> The hosts above are the default ports for lila, if you have changed them, you
will need to adjust the command accordingly.

## Setting up the emulators

### iOS

Simply follow the instructions in the flutter guide to install Xcode and the iOS
simulator.


### Android

#### When using a manually installed lila server

If you are working with a local `lila` server, you need to expose some ports from the emulator. You can do this by
running the following command (once the emulator is running):

```bash
adb reverse tcp:9663 tcp:9663
adb reverse tcp:9664 tcp:9664
```

This will allow the app to communicate with the local server. 9663 is for `http`
and 9664 is for `websocket`. It assumes that the server is running on the
default ports.

#### When using lila-docker

When using [lila-docker](https://github.com/lichess-org/lila-docker), first run `./lila-docker hostname` and select your
computer's IP address. Then, instead of the commands above, use this:

```bash
adb reverse tcp:9663 tcp:8080
adb reverse tcp:9664 tcp:8080
```

#### Troubleshooting

If Chrome instacrashes, it is likely you need to disable vulkan in emulator settings.

If you cannot access internet you can try launching the emulator with a DNS address:

```bash
$ emulator -avd <YourAVD> -dns-server 1.1.1.1
```

If you experience high lags or freezes, check the memory settings and be sure to enable hardware acceleration (`-gpu host`)
Also disabling the snapshot storage may help:

```bash
$ emulator -avd <YourAVD> -no-snapshot-load -no-snapstorage -no-snapshot -no-snapshot-save'
```

## Code generation

This project uses code generation to generate data classes with [freezed](https://pub.dev/packages/freezed) among other things.

We don't commit generated code to the repository, so you need to run it before anything else otherwise the project won't
compile:

```bash
flutter pub get
dart run build_runner build
```

While developing you can use the watch command:

```bash
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

### Logging

```sh
dart devtools
```

Then run the app with the `flutter run` command above, and a link to the logging page will be printed in the console.

