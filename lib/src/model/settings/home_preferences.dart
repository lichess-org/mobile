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
      disabledWidgets:
          state.disabledWidgets.contains(widget)
              ? state.disabledWidgets.remove(widget)
              : state.disabledWidgets.add(widget),
    );
    return save(newState);
  }
}

enum HomeEditableWidget {
  hello(false),
  perfCards(false),
  ongoingGames(true),
  quickPairing(false),
  featuredTournaments(false),
  recentGames(false);

  String label(AppLocalizations l10n) => switch (this) {
    HomeEditableWidget.ongoingGames => 'Ongoing Games',
    HomeEditableWidget.hello => 'Hello',
    HomeEditableWidget.perfCards => 'Performance Cards',
    HomeEditableWidget.quickPairing => l10n.quickPairing,
    HomeEditableWidget.featuredTournaments => l10n.openTournaments,
    HomeEditableWidget.recentGames => l10n.recentGames,
  };

  const HomeEditableWidget(this.alwaysEnabled);

  /// True if the widget should always be enabled and cannot be disabled.
  final bool alwaysEnabled;
}

@Freezed(fromJson: true, toJson: true)
sealed class HomePrefs with _$HomePrefs implements Serializable {
  const factory HomePrefs({required IList<HomeEditableWidget> disabledWidgets}) = _HomePrefs;

  static const defaults = HomePrefs(disabledWidgets: _kEmptyList);

  factory HomePrefs.fromJson(Map<String, dynamic> json) {
    try {
      return _$HomePrefsFromJson(json);
    } catch (e) {
      return defaults;
    }
  }
}

const _kEmptyList = IListConst<HomeEditableWidget>([]);
