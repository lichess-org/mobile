# Lichess Mobile

Second iteration of the [Lichess mobile app](https://lichess.org/mobile).

## How to contribute

Contributions to this project are welcome!

If you want to contribute, please read the [contributing guide](./CONTRIBUTING.md).

## Setup and Run

See [the dev environment docs](./docs/setting_dev_env.md) for detailed instructions.

## Internationalisation

Do not edit the `app_en.arb` file by hand, this file is generated.
For more information, see [Internationalisation](./docs/internationalisation.md).

## Releasing

Only for members of lichess team.

1. Bump the pubspec.yaml version number. This can be in a PR making a change or a separate PR. Use semantic versioning to determine which part to increment. The version number after the + should also be incremented. For example 0.3.3+000303 with a patch should become 0.3.4+000304.
2. Run workflow [Deploy to Play Store](https://github.com/lichess-org/mobile/actions/workflows/deploy_play_store.yml)
