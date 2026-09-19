import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'team.freezed.dart';

@freezed
sealed class LightTeam with _$LightTeam {
  const factory({required TeamId id, required String name, String? flair}) = _LightTeam;

  factory fromPick(RequiredPick pick) {
    return LightTeam(
      id: pick('id').asTeamIdOrThrow(),
      name: pick('name').asStringOrThrow(),
      flair: pick('flair').asStringOrNull(),
    );
  }
}

extension LightTeamExtension on Pick {
  LightTeam asLightTeamOrThrow() {
    final requiredPick = this.required();
    final value = requiredPick.value;
    if (value is LightTeam) {
      return value;
    }
    return LightTeam.fromPick(requiredPick);
  }

  LightTeam? asLightTeamOrNull() {
    if (value == null) return null;
    try {
      return asLightTeamOrThrow();
    } catch (_) {
      return null;
    }
  }
}

@freezed
sealed class TeamUpdateMsg with _$TeamUpdateMsg {
  const factory({
    required String id,
    required DateTime date,
    required LightUser sender,
    required String text,
    required LightTeam team,
  }) = _TeamUpdateMsg;

  factory fromPick(RequiredPick pick) {
    return TeamUpdateMsg(
      id: pick('id').asStringOrThrow(),
      date: pick('date').asDateTimeFromMillisecondsOrThrow(),
      sender: pick('sender').asLightUserOrThrow(),
      text: pick('text').asStringOrThrow(),
      team: pick('team').asLightTeamOrThrow(),
    );
  }
}

@freezed
sealed class TeamUpdateItem with _$TeamUpdateItem {
  const factory({required TeamUpdateMsg msg, required bool seen}) = _TeamUpdateItem;

  factory fromPick(RequiredPick pick) {
    return TeamUpdateItem(
      msg: TeamUpdateMsg.fromPick(pick('msg').required()),
      seen: pick('seen').asBoolOrThrow(),
    );
  }
}

@freezed
sealed class TeamUpdatesPager with _$TeamUpdatesPager {
  const factory({
    required int currentPage,
    required int maxPerPage,
    required IList<TeamUpdateItem> currentPageResults,
    int? previousPage,
    int? nextPage,
    required int nbResults,
    required int nbPages,
  }) = _TeamUpdatesPager;

  factory fromPick(RequiredPick pick) {
    return TeamUpdatesPager(
      currentPage: pick('currentPage').asIntOrThrow(),
      maxPerPage: pick('maxPerPage').asIntOrThrow(),
      currentPageResults: pick('currentPageResults')
          .asListOrEmpty((it) => TeamUpdateItem.fromPick(it))
          .toIList(),
      previousPage: pick('previousPage').asIntOrNull(),
      nextPage: pick('nextPage').asIntOrNull(),
      nbResults: pick('nbResults').asIntOrThrow(),
      nbPages: pick('nbPages').asIntOrThrow(),
    );
  }
}

@freezed
sealed class TeamUpdatesByTeam with _$TeamUpdatesByTeam {
  const factory({required LightTeam team, required DateTime last, required int unread}) =
      _TeamUpdatesByTeam;

  factory fromPick(RequiredPick pick) {
    return TeamUpdatesByTeam(
      team: pick('team').asLightTeamOrThrow(),
      last: pick('last').asDateTimeFromMillisecondsOrThrow(),
      unread: pick('unread').asIntOrThrow(),
    );
  }
}

@freezed
sealed class TeamUpdates with _$TeamUpdates {
  const factory({required IList<TeamUpdatesByTeam> byTeam}) = _TeamUpdates;

  factory fromServerJson(Map<String, dynamic> json) {
    return TeamUpdates.fromPick(pick(json).required());
  }

  factory fromPick(RequiredPick pick) {
    return TeamUpdates(
      byTeam: pick('byTeam').asListOrEmpty((it) => TeamUpdatesByTeam.fromPick(it)).toIList(),
    );
  }
}

@freezed
sealed class TeamUpdatesOfTeam with _$TeamUpdatesOfTeam {
  const factory({
    required LightTeam team,
    required bool subscribed,
    required IList<TeamUpdatesByTeam> byTeam,
    required TeamUpdatesPager updates,
  }) = _TeamUpdatesOfTeam;

  factory fromServerJson(Map<String, dynamic> json) {
    return TeamUpdatesOfTeam.fromPick(pick(json).required());
  }

  factory fromPick(RequiredPick pick) {
    return TeamUpdatesOfTeam(
      team: pick('team').asLightTeamOrThrow(),
      subscribed: pick('subscribed').asBoolOrThrow(),
      byTeam: pick('byTeam').asListOrEmpty((it) => TeamUpdatesByTeam.fromPick(it)).toIList(),
      updates: TeamUpdatesPager.fromPick(pick('updates').required()),
    );
  }
}

@freezed
sealed class TeamChannelState with _$TeamChannelState {
  const factory({
    required IList<TeamUpdateItem> updates,
    required LightTeam currentTeam,
    required bool isSubscribed,
    int? nextPage,
    required bool hasMore,
  }) = _TeamChannelState;
}
