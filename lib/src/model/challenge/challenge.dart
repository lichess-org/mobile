import 'package:deep_pick/deep_pick.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

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

  factory Challenge.fromServerJson(Map<String, dynamic> json) {
    return _challengeFromPick(pick(json).required());
  }

  factory Challenge.fromPick(RequiredPick pick) => _challengeFromPick(pick);
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

String declineReasonMessage(BuildContext context, DeclineReason key) {
  switch (key) {
    case DeclineReason.generic:
      return context.l10n.challengeDeclineGeneric;
    case DeclineReason.later:
      return context.l10n.challengeDeclineLater;
    case DeclineReason.tooFast:
      return context.l10n.challengeDeclineTooFast;
    case DeclineReason.tooSlow:
      return context.l10n.challengeDeclineTooSlow;
    case DeclineReason.timeControl:
      return context.l10n.challengeDeclineTimeControl;
    case DeclineReason.rated:
      return context.l10n.challengeDeclineRated;
    case DeclineReason.casual:
      return context.l10n.challengeDeclineCasual;
    case DeclineReason.standard:
      return context.l10n.challengeDeclineStandard;
    case DeclineReason.variant:
      return context.l10n.challengeDeclineVariant;
    case DeclineReason.noBot:
      return context.l10n.challengeDeclineNoBot;
    case DeclineReason.onlyBot:
      return context.l10n.challengeDeclineOnlyBot;
  }
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

Challenge _challengeFromPick(RequiredPick pick) {
  return Challenge(
    socketVersion: pick('socketVersion').asIntOrThrow(),
    id: pick('id').asChallengeIdOrThrow(),
    gameFullId: pick('fullId').asGameFullIdOrNull(),
    status: pick('status').asChallengeStatusOrThrow(),
    variant: pick('variant').asVariantOrThrow(),
    speed: pick('speed').asSpeedOrThrow(),
    timeControl:
        pick('timeControl', 'type').asChallengeTimeControlTypeOrThrow(),
    clock: pick('timeControl').letOrThrow(
      (clockPick) {
        final time = clockPick('limit').asDurationFromSecondsOrNull();
        final increment = clockPick('increment').asDurationFromSecondsOrNull();
        return time != null && increment != null
            ? (time: time, increment: increment)
            : null;
      },
    ),
    days: pick('timeControl', 'daysPerTurn').asIntOrNull(),
    rated: pick('rated').asBoolOrThrow(),
    sideChoice: pick('color').asSideChoiceOrThrow(),
    challenger: pick('challenger').letOrNull(
      (challengerPick) {
        final challengerUser = pick('challenger').asLightUserOrThrow();
        return (
          user: challengerUser,
          provisionalRating: challengerPick('provisional').asBoolOrNull(),
          lagRating: challengerPick('lag').asIntOrNull(),
        );
      },
    ),
    destUser: pick('destUser').letOrNull(
      (destPick) {
        final destUser = pick('destUser').asLightUserOrThrow();
        return (
          user: destUser,
          provisionalRating: destPick('provisional').asBoolOrNull(),
          lagRating: destPick('lag').asIntOrNull(),
        );
      },
    ),
    initialFen: pick('initialFen').asStringOrNull(),
    direction: pick('direction').asChallengeDirectionOrNull(),
    declineReason: pick('declineReasonKey').asDeclineReasonOrNull(),
  );
}
