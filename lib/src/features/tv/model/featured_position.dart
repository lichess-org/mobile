import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

part 'featured_position.freezed.dart';

@freezed
class FeaturedPosition with _$FeaturedPosition {
  const FeaturedPosition._();

  const factory FeaturedPosition({
    required String fen,
    Move? lastMove,
    required Side turn,
    required Chess position,
  }) = _FeaturedPosition;

  factory FeaturedPosition.fromJson(Map<String, dynamic> json) {
    return FeaturedPosition(
      fen: json['fen'] as String,
      turn: json['fen'].substring(json['fen'].length - 1) == 'w'
          ? Side.white
          : Side.black,
      lastMove: json['lm'] != null ? Move.fromUci(json['lm'] as String) : null,
      position: Chess.fromSetup(Setup.parseFen(json['fen'] as String)),
    );
  }

  bool get isGameOver => position.isGameOver;
}
