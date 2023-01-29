import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class LightUser with _$LightUser {
  const factory LightUser({
    required String name,
    String? title,
    bool? isPatron,
  }) = _LightUser;
}
