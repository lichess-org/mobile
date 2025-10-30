import 'package:deep_pick/deep_pick.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/model/common/id.dart';

part 'streamer.freezed.dart';

@freezed
sealed class Streamer with _$Streamer {
  const factory Streamer({
    required UserId id,
    required String username,
    required String status,
    required String platform,
    required String lang,
    required String streamerName,
    String? image,
    String? headline,
    String? title,
    bool? patron,
    String? twitch,
    String? youTube,
  }) = _Streamer;

  factory Streamer.fromServerJson(Map<String, dynamic> json) {
    return _streamersFromJson(json);
  }
}

Streamer _streamersFromJson(Map<String, dynamic> json) =>
    _streamersFromPick(pick(json).required());

Streamer _streamersFromPick(RequiredPick pick) {
  final stream = pick('stream');
  final streamer = pick('streamer');
  return Streamer(
    username: pick('name').asStringOrThrow(),
    id: pick('id').asUserIdOrThrow(),
    patron: pick('patron').asBoolOrNull(),
    platform: stream('service').asStringOrThrow(),
    status: stream('status').asStringOrThrow(),
    lang: stream('lang').asStringOrThrow(),
    streamerName: streamer('name').asStringOrThrow(),
    headline: streamer('headline').asStringOrNull(),
    title: pick('title').asStringOrNull(),
    image: streamer('image').asStringOrNull(),
    twitch: streamer('twitch').asStringOrNull(),
    youTube: streamer('youTube').asStringOrNull(),
  );
}
