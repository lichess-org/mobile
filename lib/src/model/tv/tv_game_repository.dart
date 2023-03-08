import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/model/tv/tv_game.dart';

class TvGameRepository {
  const TvGameRepository({required this.apiClient, required Logger logger})
      : _log = logger;
  final ApiClient apiClient;
  final Logger _log;

  FutureResult<TvGames> getTvGames() {
    return apiClient.get(Uri.parse('$kLichessHost/api/tv/channels')).then(
          (result) => result.flatMap(
            (response) => readJsonObject(
              response.body,
              mapper: TvGames.fromJson,
              logger: _log,
            ),
          ),
        );
  }

  void dispose() => apiClient.close();
}
