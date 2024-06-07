import 'package:deep_pick/deep_pick.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'challenge.freezed.dart';

@freezed
class Challenge with _$Challenge {
  const Challenge._();

  const factory Challenge({
    required String id,
    required ChallengeStatus status,
    required Variant variant,
    required String initialFen,
    required ChallengeTimeControl timeControl,
    required bool rated,
    required SideChoice sideChoice,
    required LightUser challenger,
    required LightUser destUser,
    required ChallengeDirection direction,
  }) = _Challenge;
}

enum ChallengeDirection {
  outward,
  inward,
}

enum ChallengeStatus {
  created,
  offline,
  canceled,
  declined,
  accepted,
}

enum ChallengeTimeControlType {
  unlimited,
  clock,
  correspondence,
}

typedef ChallengeTimeControl = ({
  ChallengeTimeControlType? type,
  Duration? time,
  Duration? increment,
  int? days,
  bool? show,
});

enum SideChoice {
  random,
  white,
  black,
}

extension SideChoiceExtension on Pick {
  SideChoice asSideChoiceOrThrow() {
    final value = this.required().value;
    if (value is SideChoice) {
      return value;
    }
    if (value is String) {
      switch (value) {
        case 'random':
          return SideChoice.random;
        case 'white':
          return SideChoice.white;
        case 'black':
          return SideChoice.black;
        default:
          throw PickException(
            "value $value at $debugParsingExit can't be casted to SideChoice: invalid string.",
          );
      }
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to SideChoice",
    );
  }

  SideChoice? asSideChoiceOrNull() {
    if (value == null) return null;
    try {
      return asSideChoiceOrThrow();
    } catch (_) {
      return null;
    }
  }
}
