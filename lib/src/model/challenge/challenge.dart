import 'package:deep_pick/deep_pick.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'challenge.freezed.dart';

abstract mixin class BaseChallenge {
  Variant get variant;
  Speed get speed;
  ChallengeTimeControlType get timeControl;
  ({Duration time, Duration increment})? get clock;
  int? get days;
  bool get rated;
  SideChoice get sideChoice;
  String? get initialFen;

  TimeIncrement? get timeIncrement => clock != null
      ? TimeIncrement(clock!.time.inSeconds, clock!.increment.inSeconds)
      : null;

  Perf get perf => Perf.fromVariantAndSpeed(
        variant,
        timeIncrement != null
            ? Speed.fromTimeIncrement(timeIncrement!)
            : Speed.correspondence,
      );
}

/// A challenge already created server-side.
@freezed
class Challenge with _$Challenge, BaseChallenge implements BaseChallenge {
  const Challenge._();

  @Assert(
    'clock != null || days != null',
    'Either clock or days must be set but not both.',
  )
  const factory Challenge({
    required int socketVersion,
    required ChallengeId id,
    GameFullId? gameFullId,
    required ChallengeStatus status,
    required Variant variant,
    required Speed speed,
    required ChallengeTimeControlType timeControl,
    required bool rated,
    ({Duration time, Duration increment})? clock,
    int? days,
    required SideChoice sideChoice,
    ChallengeUser? challenger,
    ChallengeUser? destUser,
    DeclineReason? declineReason,
    String? initialFen,
    ChallengeDirection? direction,
  }) = _Challenge;
}

/// A challenge request to play a game with another user.
@freezed
class ChallengeRequest
    with _$ChallengeRequest, BaseChallenge
    implements BaseChallenge {
  const ChallengeRequest._();

  @Assert(
    'clock != null || days != null',
    'Either clock or days must be set but not both.',
  )
  const factory ChallengeRequest({
    required LightUser destUser,
    required Variant variant,
    required ChallengeTimeControlType timeControl,
    ({Duration time, Duration increment})? clock,
    int? days,
    required bool rated,
    required SideChoice sideChoice,
    String? initialFen,
  }) = _ChallengeSetup;

  @override
  Speed get speed => Speed.fromTimeIncrement(
        TimeIncrement(
          clock != null ? clock!.time.inSeconds : 0,
          clock != null ? clock!.increment.inSeconds : 0,
        ),
      );

  Map<String, dynamic> get toRequestBody => {
        if (clock != null) 'clock.limit': clock!.time.inSeconds.toString(),
        if (clock != null)
          'clock.increment': clock!.increment.inSeconds.toString(),
        if (days != null) 'days': days.toString(),
        'rated': rated.toString(),
        'variant': variant.name,
        if (sideChoice != SideChoice.random) 'color': sideChoice.name,
      };
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

enum DeclineReason {
  generic,
  later,
  tooFast,
  tooSlow,
  timeControl,
  rated,
  casual,
  standard,
  variant,
  noBot,
  onlyBot,
}

typedef ChallengeUser = ({
  LightUser user,
  bool? provisionalRating,
  int? lagRating,
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

  DeclineReason asDeclineReasonOrThrow() {
    final value = this.required().value;
    if (value is DeclineReason) {
      return value;
    }
    if (value is String) {
      switch (value) {
        case 'generic':
          return DeclineReason.generic;
        case 'later':
          return DeclineReason.later;
        case 'tooFast':
          return DeclineReason.tooFast;
        case 'tooSlow':
          return DeclineReason.tooSlow;
        case 'timeControl':
          return DeclineReason.timeControl;
        case 'rated':
          return DeclineReason.rated;
        case 'casual':
          return DeclineReason.casual;
        case 'standard':
          return DeclineReason.standard;
        case 'variant':
          return DeclineReason.variant;
        case 'noBot':
          return DeclineReason.noBot;
        case 'onlyBot':
          return DeclineReason.onlyBot;
        default:
          throw PickException(
            "value $value at $debugParsingExit can't be casted to DeclineReason: invalid string.",
          );
      }
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to DeclineReason",
    );
  }

  DeclineReason? asDeclineReasonOrNull() {
    if (value == null) return null;
    try {
      return asDeclineReasonOrThrow();
    } catch (_) {
      return null;
    }
  }
}
