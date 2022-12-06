import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

part 'fen_event.freezed.dart';
part 'fen_event.g.dart';

/// Event sent by lichess TV stream when the position of the game changes.
@freezed
class FenEvent with _$FenEvent {
  const factory FenEvent({
    required String fen,
    @JsonKey(name: 'lm', fromJson: Move.fromUci) required Move lastMove,
    @JsonKey(name: 'wc') required int whiteSeconds,
    @JsonKey(name: 'bc') required int blackSeconds,
  }) = _FenEvent;

  factory FenEvent.fromJson(Map<String, dynamic> json) =>
      _$FenEventFromJson(json);
}
