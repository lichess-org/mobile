import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/common/id.dart';

part 'tv_channel.freezed.dart';

enum ChannelVariant {
  classical('Classical'),
  bullet('Bullet'),
  blitz('Blitz'),
  rapid('Rapid'),
  topRated('Top Rated');

  const ChannelVariant(this.title);

  final String title;
}

final IMap<String, ChannelVariant> channelVariantNameMap =
    IMap({for (var value in ChannelVariant.values) value.title: value});
//IMap(ChannelVariant.values.asNameMap());

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
          if (channelVariantNameMap.containsKey(entry.key))
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
