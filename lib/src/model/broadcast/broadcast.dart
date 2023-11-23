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
  }) = _Tour;
}
