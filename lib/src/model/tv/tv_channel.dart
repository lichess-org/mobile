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

final IMap<String, ChannelVariant> channelVariantTitleMap =
    IMap({for (var value in ChannelVariant.values) value.title: value});

typedef TvChannels = IMap<ChannelVariant, TvChannel>;

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
