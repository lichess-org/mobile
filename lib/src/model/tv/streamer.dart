import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/common/models.dart';

part 'streamer.freezed.dart';

@freezed
class Streamer with _$Streamer {
  const factory Streamer({
    required UserId id,
    required String username,
    required String streamStatus,
    required String streamService,
    required String lang,
    required String streamerName,
    required String streamerDesc,
    required String streamerHeadline,
    required String image,
    bool? patron,
    String? twitch,
    String? youTube,
  }) = _Streamer;
}
