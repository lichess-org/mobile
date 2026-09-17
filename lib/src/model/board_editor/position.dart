import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.freezed.dart';

@freezed
sealed class Position with _$Position {
  const factory({required String name, required String fen, required String eco}) = _Position;

  factory fromJson(Map<String, dynamic> json) => Position(
    name: json['name'] as String,
    fen: json['fen'] as String,
    eco: json['eco'] as String,
  );
}
