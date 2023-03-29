# Lichess Mobile

Second iteration of the [Lichess mobile app](https://lichess.org/mobile).

## How to contribute

The project is still in early stage of development. Drastic changes may still
happen, including project structure.

If you want to contribute, please read the [contributing guide](./CONTRIBUTING.md).

## Setup

Follow the [flutter guide](https://docs.flutter.dev/get-started/install)
to install flutter on your operating system.

This project is meant to run on iOS and Android, so you need to follow the
"Platform setup" section of that guide to install the iOS and/or Android platform.

Note that this project is not meant to be run on web platform.

Read the [wiki](https://github.com/lichess-org/mobile/wiki) for more information.

## Run

First run the code generator:

```
flutter pub run build_runner watch
```

Then use flutter run:

```
flutter run
```

## Internationalisation

Don't edit the `app_en.arb` file by hand, this file is generated. More information [here](https://github.com/lichess-org/mobile/wiki/About-internationalisation).
