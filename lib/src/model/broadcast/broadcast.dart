import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'broadcast.freezed.dart';

@freezed
class Broadcast with _$Broadcast {
  const factory Broadcast({
    required Tour tour,
  }) = _Broadcast;
}

@freezed
class Tour with _$Tour {
  const factory Tour({
    required String name,
    required String description,
    required String? imageUrl,
  }) = _Tour;

  Widget image(double width) => (imageUrl != null)
      ? Image.network(imageUrl!, width: width)
      : SizedBox(
          height: width / 2,
          width: width,
        ); // we should use the same default image as on the website
}
