import 'package:deep_pick/deep_pick.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'challenge.freezed.dart';
part 'challenge.g.dart';

abstract mixin class BaseChallenge {
  Variant get variant;
  Speed get speed;
  ChallengeTimeControlType get timeControl;
  ({Duration time, Duration increment})? get clock;
  int? get days;
  bool get rated;
  SideChoice get sideChoice;
  String? get initialFen;

  TimeIncrement? get timeIncrement =>
      clock != null ? TimeIncrement(clock!.time.inSeconds, clock!.increment.inSeconds) : null;

  Perf get perf => Perf.fromVariantAndSpeed(
    variant,
    timeIncrement != null ? Speed.fromTimeIncrement(timeIncrement!) : Speed.correspondence,
  );
}

/// A challenge already created server-side.
@Freezed(fromJson: true, toJson: true)
sealed class Challenge with _$Challenge, BaseChallenge implements BaseChallenge {
  const Challenge._();

  const factory Challenge({
    int? socketVersion,
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
    ChallengeDeclineReason? declineReason,
    String? initialFen,
    ChallengeDirection? direction,
  }) = _Challenge;

  factory Challenge.fromJson(Map<String, dynamic> json) => _$ChallengeFromJson(json);

  factory Challenge.fromServerJson(Map<String, dynamic> json) {
    return _challengeFromPick(pick(json).required());
  }

  factory Challenge.fromPick(RequiredPick pick) => _challengeFromPick(pick);

  /// The description of the challenge.
  String description(AppLocalizations l10n) {
    if (!variant.isPlaySupported) {
      // TODO: l10n
      return 'This variant is not yet supported on the app.';
    }

    final time = switch (timeControl) {
      ChallengeTimeControlType.clock => () {
        final minutes = switch (clock!.time.inSeconds) {
          15 => '¼',
          30 => '½',
          45 => '¾',
          90 => '1.5',
          _ => clock!.time.inMinutes,
        };
        return '$minutes+${clock!.increment.inSeconds}';
      }(),
      ChallengeTimeControlType.correspondence => '${l10n.daysPerTurn}: $days',
      ChallengeTimeControlType.unlimited => '∞',
    };

    final variantStr = variant == Variant.standard ? '' : ' • ${variant.label}';

    final sidePiece =
        sideChoice == SideChoice.black
            ? '♔ '
            : sideChoice == SideChoice.white
            ? '♚ '
            : '';

    final side =
        sideChoice == SideChoice.black
            ? l10n.white
            : sideChoice == SideChoice.white
            ? l10n.black
            : l10n.randomColor;

    final mode = rated ? l10n.rated : l10n.casual;

    return '$sidePiece$side • $mode • $time$variantStr';
  }
}

/// A challenge request to play a game with another user.
@freezed
sealed class ChallengeRequest with _$ChallengeRequest, BaseChallenge implements BaseChallenge {
  const ChallengeRequest._();

  @Assert('clock != null || days != null', 'Either clock or days must be set but not both.')
  const factory ChallengeRequest({
    required LightUser destUser,
    required Variant variant,
    required ChallengeTimeControlType timeControl,
    ({Duration time, Duration increment})? clock,
    int? days,
    required bool rated,
    required SideChoice sideChoice,
    String? initialFen,
  }) = _ChallengeRequest;

  @override
  Speed get speed => Speed.fromTimeIncrement(
    TimeIncrement(
      clock != null ? clock!.time.inSeconds : 0,
      clock != null ? clock!.increment.inSeconds : 0,
    ),
  );

  Map<String, dynamic> get toRequestBody {
    return {
      if (clock != null) 'clock.limit': clock!.time.inSeconds.toString(),
      if (clock != null) 'clock.increment': clock!.increment.inSeconds.toString(),
      if (days != null) 'days': days.toString(),
      'rated': variant == Variant.fromPosition ? 'false' : rated.toString(),
      'variant': variant.name,
      if (variant == Variant.fromPosition) 'fen': initialFen,
      if (sideChoice != SideChoice.random) 'color': sideChoice.name,
    };
  }
}

enum ChallengeDirection { outward, inward }

enum ChallengeStatus { created, offline, canceled, declined, accepted }

enum ChallengeTimeControlType { unlimited, clock, correspondence }

enum ChallengeDeclineReason {
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
  onlyBot;

  String label(AppLocalizations l10n) => switch (this) {
    ChallengeDeclineReason.generic => l10n.challengeDeclineGeneric,
    ChallengeDeclineReason.later => l10n.challengeDeclineLater,
    ChallengeDeclineReason.tooFast => l10n.challengeDeclineTooFast,
    ChallengeDeclineReason.tooSlow => l10n.challengeDeclineTooSlow,
    ChallengeDeclineReason.timeControl => l10n.challengeDeclineTimeControl,
    ChallengeDeclineReason.rated => l10n.challengeDeclineRated,
    ChallengeDeclineReason.casual => l10n.challengeDeclineCasual,
    ChallengeDeclineReason.standard => l10n.challengeDeclineStandard,
    ChallengeDeclineReason.variant => l10n.challengeDeclineVariant,
    ChallengeDeclineReason.noBot => l10n.challengeDeclineNoBot,
    ChallengeDeclineReason.onlyBot => l10n.challengeDeclineOnlyBot,
  };
}

typedef ChallengeUser = ({LightUser user, int? rating, bool? provisionalRating, int? lagRating});

extension ChallengeExtension on Pick {
  ChallengeDirection asChallengeDirectionOrThrow() {
    final value = this.required().value;
    if (value is ChallengeDirection) {
      return value;
    }
    if (value is String) {
      switch (value) {
        case 'outward' || 'out':
          return ChallengeDirection.outward;
        case 'inward' || 'in':
          return ChallengeDirection.inward;
        default:
          throw PickException(
            "value $value at $debugParsingExit can't be casted to ChallengeDirection: invalid string.",
          );
      }
    }
    throw PickException("value $value at $debugParsingExit can't be casted to ChallengeDirection");
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
    throw PickException("value $value at $debugParsingExit can't be casted to ChallengeStatus");
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
    throw PickException("value $value at $debugParsingExit can't be casted to SideChoice");
  }

  SideChoice? asSideChoiceOrNull() {
    if (value == null) return null;
    try {
      return asSideChoiceOrThrow();
    } catch (_) {
      return null;
    }
  }

  ChallengeDeclineReason asDeclineReasonOrThrow() {
    final value = this.required().value;
    if (value is ChallengeDeclineReason) {
      return value;
    }
    if (value is String) {
      return ChallengeDeclineReason.values.firstWhere(
        (element) => element.name.toLowerCase() == value,
        orElse:
            () =>
                throw PickException(
                  "value $value at $debugParsingExit can't be casted to ChallengeDeclineReason: invalid string.",
                ),
      );
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to ChallengeDeclineReason",
    );
  }

  ChallengeDeclineReason? asDeclineReasonOrNull() {
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
    socketVersion: pick('socketVersion').asIntOrNull(),
    id: pick('id').asChallengeIdOrThrow(),
    gameFullId: pick('fullId').asGameFullIdOrNull(),
    status: pick('status').asChallengeStatusOrThrow(),
    variant: pick('variant').asVariantOrThrow(),
    speed: pick('speed').asSpeedOrThrow(),
    timeControl: pick('timeControl', 'type').asChallengeTimeControlTypeOrThrow(),
    clock: pick('timeControl').letOrThrow((clockPick) {
      final time = clockPick('limit').asDurationFromSecondsOrNull();
      final increment = clockPick('increment').asDurationFromSecondsOrNull();
      return time != null && increment != null ? (time: time, increment: increment) : null;
    }),
    days: pick('timeControl', 'daysPerTurn').asIntOrNull(),
    rated: pick('rated').asBoolOrThrow(),
    sideChoice: pick('color').asSideChoiceOrThrow(),
    challenger: pick('challenger').letOrNull((challengerPick) {
      final challengerUser = pick('challenger').asLightUserOrThrow();
      return (
        user: challengerUser,
        rating: challengerPick('rating').asIntOrNull(),
        provisionalRating: challengerPick('provisional').asBoolOrNull(),
        lagRating: challengerPick('lag').asIntOrNull(),
      );
    }),
    destUser: pick('destUser').letOrNull((destPick) {
      final destUser = pick('destUser').asLightUserOrThrow();
      return (
        user: destUser,
        rating: destPick('rating').asIntOrNull(),
        provisionalRating: destPick('provisional').asBoolOrNull(),
        lagRating: destPick('lag').asIntOrNull(),
      );
    }),
    initialFen: pick('initialFen').asStringOrNull(),
    direction: pick('direction').asChallengeDirectionOrNull(),
    declineReason: pick('declineReasonKey').asDeclineReasonOrNull(),
  );
}
