import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_preferences.freezed.dart';
part 'home_preferences.g.dart';

@riverpod
class HomePreferences extends _$HomePreferences with PreferencesStorage<HomePrefs> {
  // ignore: avoid_public_notifier_properties
  @override
  PrefCategory get prefCategory => PrefCategory.home;

  // ignore: avoid_public_notifier_properties
  @override
  HomePrefs get defaults => HomePrefs.defaults;

  @override
  HomePrefs fromJson(Map<String, dynamic> json) => HomePrefs.fromJson(json);

  @override
  HomePrefs build() {
    return fetch();
  }

  Future<void> toggleWidget(EnabledWidget widget) {
    final newState = state.copyWith(
      enabledWidgets:
          state.enabledWidgets.contains(widget)
              ? state.enabledWidgets.difference({widget})
              : state.enabledWidgets.union({widget}),
    );
    return save(newState);
  }
}

enum EnabledWidget { hello, perfCards, quickPairing }

@Freezed(fromJson: true, toJson: true)
class HomePrefs with _$HomePrefs implements Serializable {
  const factory HomePrefs({required Set<EnabledWidget> enabledWidgets}) = _HomePrefs;

  static const defaults = HomePrefs(
    enabledWidgets: {EnabledWidget.hello, EnabledWidget.perfCards, EnabledWidget.quickPairing},
  );

  factory HomePrefs.fromJson(Map<String, dynamic> json) {
    try {
      return _$HomePrefsFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}
