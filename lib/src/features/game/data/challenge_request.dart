import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

part 'challenge_request.freezed.dart';

@freezed
class ChallengeRequest with _$ChallengeRequest {
  const ChallengeRequest._();

  const factory ChallengeRequest({
    /// Clock initial time
    required Duration time,

    /// Clock increment
    required Duration increment,

    /// Which side you get to play. Default is random.
    Side? side,
  }) = _ChallengeRequest;

  Map<String, dynamic> get toRequestBody => {
        'clock.limit': time.inSeconds.toString(),
        'clock.increment': increment.inSeconds.toString(),
        'color': side?.name ?? 'random',
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
        'clock.limit': challenge.time.inSeconds.toString(),
        'clock.increment': challenge.increment.inSeconds.toString(),
        'color': challenge.side?.name ?? 'random',
      };
}
