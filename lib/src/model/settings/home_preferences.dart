import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_preferences.freezed.dart';
part 'home_preferences.g.dart';

@Riverpod(keepAlive: true)
class HomePreferences extends _$HomePreferences with PreferencesStorage<HomePrefs> {
  @override
  @protected
  PrefCategory get prefCategory => PrefCategory.home;

  @override
  @protected
  HomePrefs get defaults => HomePrefs.defaults;

  @override
  HomePrefs fromJson(Map<String, dynamic> json) => HomePrefs.fromJson(json);

  @override
  HomePrefs build() {
    return fetch();
  }

  Future<void> toggleWidget(HomeEditableWidget widget) {
    if (widget.alwaysEnabled) {
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

  Future<void> moveToTop(HomeEditableWidget widget) {
    final newState = state.copyWith(
      enabledWidgets: [widget, ...state.enabledWidgets.where((w) => w != widget)].lock,
    );
    return save(newState);
  }

  Future<void> moveToBottom(HomeEditableWidget widget) {
    final newState = state.copyWith(
      enabledWidgets: [...state.enabledWidgets.where((w) => w != widget), widget].lock,
    );
    return save(newState);
  }

  Future<void> moveUp(HomeEditableWidget widget) {
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

  Future<void> moveDown(HomeEditableWidget widget) {
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

enum HomeEditableWidget {
  ongoingGames(true),
  hello(false),
  perfCards(false),
  quickPairing(false),
  recentGames(false);

  String label(AppLocalizations l10n) => switch (this) {
    HomeEditableWidget.ongoingGames => 'Ongoing Games',
    HomeEditableWidget.hello => 'Hello',
    HomeEditableWidget.perfCards => 'Performance Cards',
    HomeEditableWidget.quickPairing => l10n.quickPairing,
    HomeEditableWidget.recentGames => l10n.recentGames,
  };

  const HomeEditableWidget(this.alwaysEnabled);

  /// True if the widget should always be enabled and cannot be disabled.
  final bool alwaysEnabled;
}

@Freezed(fromJson: true, toJson: true)
class HomePrefs with _$HomePrefs implements Serializable {
  const factory HomePrefs({required IList<HomeEditableWidget> enabledWidgets}) = _HomePrefs;

  static const defaults = HomePrefs(
    enabledWidgets: IListConst([
      HomeEditableWidget.ongoingGames,
      HomeEditableWidget.hello,
      HomeEditableWidget.perfCards,
      HomeEditableWidget.quickPairing,
      HomeEditableWidget.recentGames,
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
