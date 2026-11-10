import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/relation/friend_list_sort.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';

part 'relation_preferences.freezed.dart';
part 'relation_preferences.g.dart';

/// Provider for [RelationPreferences].
final relationPreferencesProvider = NotifierProvider<RelationPreferences, RelationPrefs>(
  RelationPreferences.new,
  name: 'RelationPreferencesProvider',
);

/// Relation preferences, defined client-side only.
class RelationPreferences() extends Notifier<RelationPrefs> with PreferencesStorage<RelationPrefs> {
  @override
  @protected
  final prefCategory = PrefCategory.relation;

  @override
  @protected
  RelationPrefs get defaults => RelationPrefs.defaults;

  @override
  RelationPrefs fromJson(Map<String, dynamic> json) => RelationPrefs.fromJson(json);

  @override
  RelationPrefs build() {
    return fetch();
  }

  Future<void> setFriendSort(FriendListSort friendSort) {
    return save(state.copyWith(friendSort: friendSort));
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class RelationPrefs with _$RelationPrefs implements Serializable {
  const factory({FriendListSort? friendSort}) = _RelationPrefs;

  static const defaults = RelationPrefs(friendSort: FriendListSort.lastSeen);

  factory fromJson(Map<String, dynamic> json) => _$RelationPrefsFromJson(json);
}
