import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/account/home_widgets.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_preferences.freezed.dart';
part 'home_preferences.g.dart';

@Riverpod(keepAlive: true)
class HomePreferences extends _$HomePreferences
    with SessionPreferencesStorage<HomePrefs> {
  @override
  @protected
  PrefCategory get prefCategory => PrefCategory.home;

  @override
  @protected
  HomePrefs defaults({LightUser? user}) => HomePrefs.defaults;

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
      disabledWidgets: state.disabledWidgets.contains(widget)
          ? state.disabledWidgets.remove(widget)
          : state.disabledWidgets.add(widget),
    );
    return save(newState);
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class HomePrefs with _$HomePrefs implements Serializable {
  const factory HomePrefs({
    required IList<HomeEditableWidget> disabledWidgets,
  }) = _HomePrefs;

  static const defaults = HomePrefs(disabledWidgets: _defaultList);

  factory HomePrefs.fromJson(Map<String, dynamic> json) {
    try {
      return _$HomePrefsFromJson(json);
    } catch (e) {
      return defaults;
    }
  }
}

const _defaultList = IListConst<HomeEditableWidget>([
  HomeEditableWidget.quickPairing,
]);
