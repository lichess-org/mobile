import 'package:lichess_mobile/src/model/settings/preferences.dart' as pref;
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_preferences.g.dart';

@riverpod
class HomePreferences extends _$HomePreferences
    with PreferencesStorage<pref.Home> {
  // ignore: avoid_public_notifier_properties
  @override
  pref.Category<pref.Home> get prefCategory => pref.Category.home;

  @override
  pref.Home build() {
    return fetch();
  }

  Future<void> toggleWidget(pref.EnabledWidget widget) {
    final newState = state.copyWith(
      enabledWidgets: state.enabledWidgets.contains(widget)
          ? state.enabledWidgets.difference({widget})
          : state.enabledWidgets.union({widget}),
    );
    return save(newState);
  }
}
