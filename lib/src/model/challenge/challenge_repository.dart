import 'package:result_extensions/result_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/constants.dart';

import './challenge_request.dart';

class ChallengeRepository {
  const ChallengeRepository({
    required this.apiClient,
  });

  final ApiClient apiClient;

  FutureResult<void> challenge(String username, ChallengeRequest req) {
    return apiClient.post(
      Uri.parse('$kLichessHost/api/challenge/$username'),
      body: req.toRequestBody,
    );
  }

  FutureResult<void> challengeAI(AiChallengeRequest req) {
    return apiClient.post(
      Uri.parse('$kLichessHost/api/challenge/ai'),
      body: req.toRequestBody,
    );
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
