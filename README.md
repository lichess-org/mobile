# Lichess Mobile

Second iteration of the [Lichess mobile app](https://lichess.org/mobile).

## How to contribute

Contributions to this project are welcome!

If you want to contribute, please read the [contributing guide](./CONTRIBUTING.md).

## Setup

tl;dr: Install Flutter, clone the repo, run in order:
- `flutter pub get`
- `dart run build_runner watch`
- `flutter analyze --watch`,

and you're ready to code!

See [the dev environment docs](./docs/setting_dev_env.md) for detailed instructions.

## Running the app

To run the app, you can use the following command:

```bash
# if not already done, run the code generation
dart run build_runner build

# run the app on all available devices
flutter run -d all
```

## Running tests

To run the tests, you can use the following command:

```bash
# if not already done, run the code generation
dart run build_runner build

flutter test
```

## Internationalisation

Do not edit the `app_en.arb` file by hand, this file is generated.
For more information, see [Internationalisation](./docs/internationalisation.md).

## Releasing

Only for members of lichess team.

1. Bump the pubspec.yaml version number. This can be in a PR making a change or a separate PR. Use semantic versioning to determine which part to increment. The version number after the + should also be incremented. For example 0.3.3+000303 with a patch should become 0.3.4+000304.
2. Run workflow [Deploy to Play Store](https://github.com/lichess-org/mobile/actions/workflows/deploy_play_store.yml)
