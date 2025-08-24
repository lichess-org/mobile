# Contributing

## I want to contribute code to Lichess Mobile

- [Set up your development environment](https://github.com/lichess-org/mobile/blob/main/docs/setting_dev_env.md);
- Communicate with other devs on [Discord](https://discord.gg/lichess).
- check the [docs](https://github.com/lichess-org/mobile/tree/main/docs) for more documentation

### What to work on

To find a task to work on, you can check the [good first issue](https://github.com/lichess-org/mobile/labels/%22good%20first%20issue%22)
and [help wanted](https://github.com/lichess-org/mobile/labels/%22help%20wanted%22)
labels on GitHub.

These tags are useful, but there are many other good issues that are not tagged with
them, and you can also contribute by fixing bugs or adding features that are not
listed in the issues.
Note that new feature requests may be rejected if they
don't fit the project's goals. It is best to discuss them with the maintainers
before starting to work on them, either on Discord or by opening a discussion on
GitHub.

Most appreciated contributions are those that:
- **Fix bugs**
- **Add missing tests**. Flutter widget tests are easy to write and very useful to
  test the UI. They are reliable and fast. You can already find examples in the `test/` directory, but the project is still lacking a lot of tests.

We don't assign issues to contributors, so feel free to work on any issue you
like, but check the existing pull requests to avoid duplicated work. Once you
start working on an issue, submit a pull request as soon as possible (in draft
mode if it's not ready yet) to let others know that you're working on it.

## Before submitting a Pull Request

- Make sure your code follows the [coding style guide](https://github.com/lichess-org/mobile/blob/main/docs/coding_style.md)
- Don't manually edit the `app_en.arb` file! See the [internalizations docs](https://github.com/lichess-org/mobile/blob/main/docs/internationalisation.md) for instructions on how to add new translations.
- If possible, write a new widget test for your bugfix or new feature.
- Consider adding a screenshot and/or screen recording to the PR description.
- Run the linter and tests:
```sh
flutter analyze
flutter test
```
- Ensure your code is formatted correctly (or use your editor's "format on save" feature):
```sh
dart format --output=none --set-exit-if-changed $(find lib/src -name "*.dart" -not \( -name "*.*freezed.dart" -o -name "*.*g.dart" -o -name "*lichess_icons.dart" \) )
dart format --output=none --set-exit-if-changed $(find test -name "*.dart" -not \( -name "*.*freezed.dart" -o -name "*.*g.dart" \) )
```

## I want to report a bug or a problem about Lichess Mobile

[**Make an issue**](https://github.com/lichess-org/mobile/issues/new).
Before creating an issue, make sure that:

1. You list the steps to reproduce the problem to show that other users may
experience it as well, if the issue is not self-descriptive.
2. Search to make sure it isn't a duplicate. [The advanced search syntax](https://help.github.com/articles/searching-issues/) may come in handy.
3. It is not a trivial problem or demands unrealistic dev time to fix. Such
issues may be closed.
4. You're not posting a one liner such as "X feature is missing". It is useless, we already know exactly what features are missing. Feature request are allowed if you're suggesting a new idea, while explaining it in the most detailed and clear possible way.
5. You provide device hardware and operating system information to help with the
debug.

## I want to suggest a feature for Lichess

See [that guide](https://github.com/lichess-org/lila/blob/master/CONTRIBUTING.md#i-want-to-suggest-a-feature-for-lichess).

## I want to help translate Lichess

Check out [Lichess on crowdin.com](https://crowdin.com/project/lichess).

## Other ways to contribute

Also see https://lichess.org/help/contribute.
