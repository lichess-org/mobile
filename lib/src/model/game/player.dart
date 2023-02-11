import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'player.freezed.dart';

@freezed
class Player with _$Player {
  const Player._();

  const factory Player({
    UserId? id,
    required String name,
    int? rating,
    int? ratingDiff,
    bool? provisional,
    String? title,
    bool? patron,
    int? aiLevel,
  }) = _Player;

  LightUser? get lightUser => id != null
      ? LightUser(
          id: id!,
          name: name,
          title: title,
          isPatron: patron,
        )
      : null;
}
