import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/features/user/model/leaderboard.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/constants.dart';

class LeaderboardRepository {
  const LeaderboardRepository({required this.apiClient, required Logger logger})
      : _log = logger;

  final ApiClient apiClient;
  final Logger _log;

  FutureResult<Leaderboard> getLeaderboard() {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/player'))
        .flatMap((response) {
      return readJsonObject(response.body,
          mapper: Leaderboard.fromJson, logger: _log);
    });
  }

  void dispose() => apiClient.close();
}

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo = LeaderboardRepository(
      apiClient: apiClient, logger: Logger('LeaderboardRepository'));
  ref.onDispose(() => repo.dispose());
  return repo;
});
