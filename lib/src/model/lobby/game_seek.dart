import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';

part 'game_seek.freezed.dart';

@freezed
class GameSeek with _$GameSeek {
  const GameSeek._();
  const factory GameSeek({
    required Duration time,
    required Duration increment,
    required bool rated,
    Variant? variant,
    Side? side,
  }) = _GameSeek;

  Map<String, String> get requestBody => {
        'time': time.inMinutes.toString(),
        'increment': increment.inSeconds.toString(),
        'rated': rated.toString(),
        if (variant != null) 'variant': variant!.name,
        if (side != null) 'side': side!.name,
      };
}
