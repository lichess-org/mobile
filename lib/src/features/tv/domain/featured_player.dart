import 'package:meta/meta.dart';
import 'package:dartchess/dartchess.dart';

@immutable
class FeaturedPlayer {
  final Side side;
  final String name;
  final String? title;
  final int? rating;
  final int seconds;

  const FeaturedPlayer(
      {required this.side,
      required this.name,
      this.title,
      this.rating,
      required this.seconds});

  FeaturedPlayer.fromJson(Map<String, dynamic> json)
      : side = json['color'] == 'white' ? Side.white : Side.black,
        name = json['user']['name'],
        title = json['user']['title'],
        rating = json['rating'],
        seconds = json['seconds'];

  FeaturedPlayer withSeconds(int newSeconds) {
    return FeaturedPlayer(
      side: side,
      name: name,
      title: title,
      rating: rating,
      seconds: newSeconds,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FeaturedPlayer &&
        other.side == side &&
        other.name == name &&
        other.title == title &&
        other.rating == rating &&
        other.seconds == seconds;
  }

  @override
  int get hashCode => Object.hash(side, name, title, rating, seconds);

  @override
  toString() {
    return 'Player($side, $name, $rating, $title)';
  }
}
