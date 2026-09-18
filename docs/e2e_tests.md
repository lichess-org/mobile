# End-to-end tests

End-to-end tests live in `patrol_test/` and run the real app on an Android emulator or device with
[Patrol](https://patrol.leancode.co). `flutter test` and CI do not run them.

## Setup

Install the CLI in the version that pairs with the `patrol` package in `pubspec.yaml`, see the
[compatibility table](https://patrol.leancode.co/documentation/compatibility-table):

```sh
dart pub global activate patrol_cli
patrol doctor
```

## Running

With an emulator booted:

```sh
patrol test
patrol test --target patrol_test/scenarios/puzzle_themes_test.dart
```

Tests talk to the same server as `flutter run` and take the same `--dart-define` flags.

## Layout

- `patrol_test/common/open_app.dart` boots the app the way `main()` does. Keep it in sync with
  `lib/main.dart`.
- `patrol_test/modules/` holds one class per screen with the actions a test can take on it.
- `patrol_test/system.dart` holds native interactions such as permission dialogs.
- `patrol_test/scenarios/` holds the tests, one per file.
