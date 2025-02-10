import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_preferences.freezed.dart';
part 'home_preferences.g.dart';

@Riverpod(keepAlive: true)
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
    if (widget == EnabledWidget.ongoingGames) {
      return Future.value();
    }
    final newState = state.copyWith(
      enabledWidgets:
          state.enabledWidgets.contains(widget)
              ? state.enabledWidgets.remove(widget)
              : state.enabledWidgets.add(widget),
    );
    return save(newState);
  }

  Future<void> moveToTop(EnabledWidget widget) {
    final newState = state.copyWith(
      enabledWidgets: [widget, ...state.enabledWidgets.where((w) => w != widget)].lock,
    );
    return save(newState);
  }

  Future<void> moveToBottom(EnabledWidget widget) {
    final newState = state.copyWith(
      enabledWidgets: [...state.enabledWidgets.where((w) => w != widget), widget].lock,
    );
    return save(newState);
  }

  Future<void> moveUp(EnabledWidget widget) {
    final index = state.enabledWidgets.indexOf(widget);
    if (index == 0) {
      return moveToBottom(widget);
    }
    final newState = state.copyWith(
      enabledWidgets:
          [
            ...state.enabledWidgets.sublist(0, index - 1),
            widget,
            state.enabledWidgets[index - 1],
            ...state.enabledWidgets.sublist(index + 1),
          ].lock,
    );
    return save(newState);
  }

  Future<void> moveDown(EnabledWidget widget) {
    final index = state.enabledWidgets.indexOf(widget);
    if (index == state.enabledWidgets.length - 1) {
      return moveToTop(widget);
    }
    final newState = state.copyWith(
      enabledWidgets:
          [
            ...state.enabledWidgets.sublist(0, index),
            state.enabledWidgets[index + 1],
            widget,
            ...state.enabledWidgets.sublist(index + 2),
          ].lock,
    );
    return save(newState);
  }
}

enum EnabledWidget {
  ongoingGames,
  hello,
  perfCards,
  quickPairing,
  recentGames;

  String get label => switch (this) {
    EnabledWidget.ongoingGames => 'Ongoing Games',
    EnabledWidget.hello => 'Hello',
    EnabledWidget.perfCards => 'Performance Cards',
    EnabledWidget.quickPairing => 'Quick Pairing',
    EnabledWidget.recentGames => 'Recent Games',
  };
}

@Freezed(fromJson: true, toJson: true)
class HomePrefs with _$HomePrefs implements Serializable {
  const factory HomePrefs({required IList<EnabledWidget> enabledWidgets}) = _HomePrefs;

  static const defaults = HomePrefs(
    enabledWidgets: IListConst([
      EnabledWidget.ongoingGames,
      EnabledWidget.hello,
      EnabledWidget.perfCards,
      EnabledWidget.quickPairing,
      EnabledWidget.recentGames,
    ]),
  );

  factory HomePrefs.fromJson(Map<String, dynamic> json) {
    try {
      return _$HomePrefsFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}
