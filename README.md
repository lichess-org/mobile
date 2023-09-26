# Lichess Mobile

Second iteration of the [Lichess mobile app](https://lichess.org/mobile).

## How to contribute

The project is still in early stage of development. Drastic changes may still
happen, including project structure.

If you want to contribute, please read the [contributing guide](./CONTRIBUTING.md).

## Setup

Follow the [flutter guide](https://docs.flutter.dev/get-started/install)

This project is meant to run on iOS and Android, so you need to follow the
"Platform setup" section of that guide to install the iOS and/or Android platform.

Note that this project is not meant to be run on web platform.

### Using FVM for Flutter Version Management

If you want to use FVM to manage your Flutter versions effectively, please consult the [FVM (Flutter Version Management) guide](https://fvm.app/docs/getting_started/installation) for comprehensive instructions on installing Flutter on your specific operating system.

**Pro Tip:** Remember to prepend the 'flutter' prefix when using FVM commands, like this: `fvm flutter [command]`.



### Local lila

You will need a local [lila](https://github.com/lichess-org/lila) (lichess server scala app) instance to work on this
project. You will also need to setup [lila-ws](https://github.com/lichess-org/lila-ws) (websocket server).

Instructions to install both are found in [the lila wiki](https://github.com/lichess-org/lila/wiki).

The mobile application is configured by default to target `http://127.0.0.1:9663` and `ws://127.0.0.1:9664`, so keep these when installing lila.

## Run

First run the code generator:

```
flutter pub get
dart run build_runner watch
```

Check you have some connected device with: `flutter devices`.

If you target an android device you need to run these commands so the device can reach the local lila instance:
```
adb reverse tcp:9663 tcp:9663
adb reverse tcp:9664 tcp:9664
```

Then run on your device:

```
flutter run -d <my_device>
```

You can find more information about emulators [in the wiki](https://github.com/lichess-org/mobile/wiki/Setting-up-device-emulators).

You can find more information about the `flutter run` command by running `flutter run --help`.

## Internationalisation

Do not edit the `app_en.arb` file by hand, this file is generated. 
More information [in the wiki](https://github.com/lichess-org/mobile/wiki/About-internationalisation).

## Releasing

Only for members of lichess team.

1. Bump the pubspec.yaml version number. This can be in a PR making a change or a separate PR. Use semantic versioning to determine which part to increment. The version number after the + should also be incremented. For example 0.3.3+000303 with a patch should become 0.3.4+000304.
2. Run workflow [Draft GitHub Release](https://github.com/lichess-org/mobile/actions/workflows/draft_github_release.yml)
3. Run workflow [Deploy to Play Store](https://github.com/lichess-org/mobile/actions/workflows/deploy_play_store.yml)
