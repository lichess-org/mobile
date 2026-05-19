import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/account/home_widgets.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'home_preferences.freezed.dart';
part 'home_preferences.g.dart';

final homePreferencesProvider = NotifierProvider<HomePreferences, HomePrefs>(
  HomePreferences.new,
  name: 'HomePreferencesProvider',
);

class HomePreferences extends Notifier<HomePrefs> with SessionPreferencesStorage<HomePrefs> {
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

  Future<void> setTimeControlConfig({
    required IList<TimeIncrement> disabledTimeControls,
    required bool customButtonEnabled,
  }) {
    final enabledCount =
        TimeIncrement.matrixPresets.length -
        disabledTimeControls.length +
        (customButtonEnabled ? 1 : 0);
    if (enabledCount < 1) return Future.value();
    return save(
      state.copyWith(
        disabledTimeControls: disabledTimeControls,
        customButtonEnabled: customButtonEnabled,
      ),
    );
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class HomePrefs with _$HomePrefs implements Serializable {
  const factory HomePrefs({
    required IList<HomeEditableWidget> disabledWidgets,
    @Default(IListConst<TimeIncrement>([]))
    @_TimeIncrementIListConverter()
    IList<TimeIncrement> disabledTimeControls,
    @Default(true) bool customButtonEnabled,
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

const _defaultList = IListConst<HomeEditableWidget>([HomeEditableWidget.quickPairing]);

class _TimeIncrementIListConverter implements JsonConverter<IList<TimeIncrement>, List<dynamic>> {
  const _TimeIncrementIListConverter();

  @override
  IList<TimeIncrement> fromJson(List<dynamic> json) {
    return IList(json.map((e) => TimeIncrement.fromJson(e as Map<String, dynamic>)));
  }

  @override
  List<dynamic> toJson(IList<TimeIncrement> object) {
    return object.map((e) => e.toJson()).toList();
  }
}
