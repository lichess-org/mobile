# End-to-end tests

The tests in `patrol_test/` run the real app on an Android emulator or device with
[Patrol](https://patrol.leancode.co).

Install the CLI in the version that pairs with the `patrol` package in `pubspec.yaml`
([compatibility table](https://patrol.leancode.co/documentation/compatibility-table)):

```sh
dart pub global activate patrol_cli
```

With an emulator booted:

```sh
# all tests
patrol test

# one test
patrol test --target patrol_test/scenarios/puzzle_themes_test.dart

# build once, then hot restart the test with `r`
patrol develop --target patrol_test/scenarios/puzzle_themes_test.dart
```
