import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/constants.dart';

import './challenge_request.dart';

class ChallengeRepository {
  const ChallengeRepository({
    required this.apiClient,
  });

  final ApiClient apiClient;

  TaskEither<IOError, void> challengeTask(
      String username, ChallengeRequest req) {
    return apiClient.post(Uri.parse('$kLichessHost/api/challenge/$username'),
        body: req.toRequestBody);
  }

  TaskEither<IOError, void> challengeAITask(AiChallengeRequest req) {
    return apiClient.post(Uri.parse('$kLichessHost/api/challenge/ai'),
        body: req.toRequestBody);
  }

  void dispose() {
    apiClient.close();
  }
}

final challengeRepositoryProvider = Provider<ChallengeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo = ChallengeRepository(apiClient: apiClient);
  ref.onDispose(() => repo.dispose());
  return repo;
});
