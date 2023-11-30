import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';

class RelationRepository {
  const RelationRepository({required this.apiClient, required Logger logger})
      : _log = logger;

  final AuthClient apiClient;
  final Logger _log;

  FutureResult<IList<User>> getFollowing() async {
    return apiClient.get(
      Uri.parse('$kLichessHost/api/rel/following'),
      headers: {'Accept': 'application/x-ndjson'},
    ).then(
      (result) => result.flatMap(
        (response) => readNdJsonListFromResponse<User>(
          response,
          mapper: (json) => User.fromJson(json),
          logger: _log,
        ),
      ),
    );
  }

  FutureResult<void> follow(String username) async {
    return apiClient.post(
      Uri.parse('$kLichessHost/api/rel/follow/$username'),
    );
  }

  FutureResult<void> unfollow(String username) async {
    return apiClient.post(
      Uri.parse('$kLichessHost/api/rel/unfollow/$username'),
    );
  }
}
