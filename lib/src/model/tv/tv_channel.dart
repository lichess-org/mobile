import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/utils/json.dart';

import 'package:lichess_mobile/src/common/models.dart';

part 'tv_channel.freezed.dart';

@freezed
class TvChannels with _$TvChannels {
  const factory TvChannels({
    required IMap<String, TvChannel> channels,
  }) = _TvChannels;

  factory TvChannels.fromJson(Map<String, dynamic> json) =>
      TvChannels.fromPick(pick(json).required());

  factory TvChannels.fromPick(RequiredPick pick) {
    final channelMap = pick.asMapOrEmpty<String, Map<String, dynamic>>();

    return TvChannels(
      channels: IMap({
        for (final entry in channelMap.entries)
          if (entry.key != 'Horde' &&
              entry.key != 'Race Kings' &&
              entry.key != 'Crazyhouse' &&
              entry.key != 'King of the Hill' &&
              entry.key != 'Antichess' &&
              entry.key != 'Computer' &&
              entry.key != 'Bot' &&
              entry.key != 'Atomic' &&
              entry.key != 'Racing Kings' &&
              entry.key != 'Three-check')
            entry.key: TvChannel.fromJson(entry.value)
      }),
    );
  }
}

@freezed
abstract class WatchParameter with _$WatchParameter {
  factory WatchParameter({
    required bool withSound,
    required String? gameId,
  }) = _WatchParameter;
}

@freezed
class TvChannel with _$TvChannel {
  const factory TvChannel({
    required String name,
    required String? title,
    required UserId id,
    required int? rating,
    required String gameId,
  }) = _TvChannel;

  factory TvChannel.fromJson(Map<String, dynamic> json) =>
      TvChannel.fromPick(pick(json).required());

  factory TvChannel.fromPick(RequiredPick pick) => TvChannel(
        name: pick('user', 'name').asStringOrThrow(),
        title: pick('user', 'title').asStringOrNull(),
        id: pick('user', 'id').asUserIdOrThrow(),
        rating: pick('rating').asIntOrNull(),
        gameId: pick('gameId').asStringOrThrow(),
      );
}
