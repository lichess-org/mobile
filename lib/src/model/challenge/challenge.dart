import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'challenge.freezed.dart';

@freezed
class Challenge with _$Challenge {
  const Challenge._();

  const factory Challenge({
    required ChallengeId id,
    required ChallengeStatus status,
    required Variant variant,
    required Speed speed,
    required ChallengeTimeControl timeControl,
    required bool rated,
    required SideChoice sideChoice,
    required Side finalSide,
    required ChallengeUser challenger,
    required ChallengeUser destUser,
    String? initialFen,
    ChallengeDirection? direction,
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

typedef ChallengeUser = ({
  LightUser user,
  bool provisionalRating,
  int lagRating,
});

typedef ChallengeTimeControl = ({
  ChallengeTimeControlType type,
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

extension ChallengeExtension on Pick {
  ChallengeDirection asChallengeDirectionOrThrow() {
    final value = this.required().value;
    if (value is ChallengeDirection) {
      return value;
    }
    if (value is String) {
      switch (value) {
        case 'outward':
          return ChallengeDirection.outward;
        case 'inward':
          return ChallengeDirection.inward;
        default:
          throw PickException(
            "value $value at $debugParsingExit can't be casted to ChallengeDirection: invalid string.",
          );
      }
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to ChallengeDirection",
    );
  }

  ChallengeDirection? asChallengeDirectionOrNull() {
    if (value == null) return null;
    try {
      return asChallengeDirectionOrThrow();
    } catch (_) {
      return null;
    }
  }

  ChallengeStatus asChallengeStatusOrThrow() {
    final value = this.required().value;
    if (value is ChallengeStatus) {
      return value;
    }
    if (value is String) {
      switch (value) {
        case 'created':
          return ChallengeStatus.created;
        case 'offline':
          return ChallengeStatus.offline;
        case 'canceled':
          return ChallengeStatus.canceled;
        case 'declined':
          return ChallengeStatus.declined;
        case 'accepted':
          return ChallengeStatus.accepted;
        default:
          throw PickException(
            "value $value at $debugParsingExit can't be casted to ChallengeStatus: invalid string.",
          );
      }
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to ChallengeStatus",
    );
  }

  ChallengeStatus? asChallengeStatusOrNull() {
    if (value == null) return null;
    try {
      return asChallengeStatusOrThrow();
    } catch (_) {
      return null;
    }
  }

  ChallengeTimeControlType asChallengeTimeControlTypeOrThrow() {
    final value = this.required().value;
    if (value is ChallengeTimeControlType) {
      return value;
    }
    if (value is String) {
      switch (value) {
        case 'unlimited':
          return ChallengeTimeControlType.unlimited;
        case 'clock':
          return ChallengeTimeControlType.clock;
        case 'correspondence':
          return ChallengeTimeControlType.correspondence;
        default:
          throw PickException(
            "value $value at $debugParsingExit can't be casted to ChallengeTimeControlType: invalid string.",
          );
      }
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to ChallengeTimeControlType",
    );
  }

  ChallengeTimeControlType? asChallengeTimeControlTypeOrNull() {
    if (value == null) return null;
    try {
      return asChallengeTimeControlTypeOrThrow();
    } catch (_) {
      return null;
    }
  }

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
