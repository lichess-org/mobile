import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

part 'featured_player.freezed.dart';

@freezed
class FeaturedPlayer with _$FeaturedPlayer {
  const factory FeaturedPlayer(
      {required Side side,
      required String name,
      String? title,
      int? rating,
      int? seconds}) = _FeaturedPlayer;

  const FeaturedPlayer._();

  FeaturedPlayer withSeconds(int newSeconds) {
    return FeaturedPlayer(
      side: side,
      name: name,
      title: title,
      rating: rating,
      seconds: newSeconds,
    );
  }
}
