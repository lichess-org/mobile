import 'package:dartchess/dartchess.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';

part 'challenge_request.freezed.dart';

/// Represents a challenge request to play a game.
///
/// TODO: Add support for game rules
/// See: https://lichess.org/api#tag/Challenges/operation/challengeCreate
@freezed
class ChallengeRequest with _$ChallengeRequest {
  const ChallengeRequest._();

  @Assert(
    'clock != null || days != null',
    'Either clock or days must be set but not both.',
  )
  @Assert(
    'variant == null || variant.isPlaySupported',
    'Variant is not supported for playing.',
  )
  const factory ChallengeRequest({
    /// Time control for the game.
    (Duration time, Duration increment)? clock,

    /// Days to play the game. If set, the game will be played in correspondence
    /// mode.
    int? days,

    /// Whether the game is rated.
    required bool rated,

    /// Variant of the game.
    Variant? variant,

    /// Which side you get to play. Default is random.
    Side? side,
  }) = _ChallengeRequest;

  Map<String, dynamic> get toRequestBody => {
        if (clock != null) 'clock.limit': (clock!.$1.inSeconds / 60).toString(),
        if (clock != null) 'clock.increment': clock!.$2.inSeconds.toString(),
        if (days != null) 'days': days.toString(),
        'rated': rated.toString(),
        if (variant != null) 'variant': variant!.name,
        if (side != null) 'color': side!.name,
      };
}

@freezed
class AiChallengeRequest with _$AiChallengeRequest {
  const AiChallengeRequest._();

  const factory AiChallengeRequest({
    required ChallengeRequest challenge,

    /// AI Strength
    required int level,
  }) = _AiChallengeRequest;

  Map<String, dynamic> get toRequestBody => {
        'level': level.toString(),
        if (challenge.clock != null)
          'clock.limit': (challenge.clock!.$1.inSeconds / 60).toString(),
        if (challenge.clock != null)
          'clock.increment': challenge.clock!.$2.inSeconds.toString(),
        if (challenge.days != null) 'days': challenge.days.toString(),
        'color': challenge.side?.name ?? 'random',
      };
}
