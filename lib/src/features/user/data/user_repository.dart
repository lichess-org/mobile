import 'package:logging/logging.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import '../model/user.dart';

class UserRepository {
  const UserRepository({required this.apiClient, required Logger logger})
      : _log = logger;

  final ApiClient apiClient;
  final Logger _log;

  TaskEither<IOError, User> getUserTask(String username) {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/user/$username'))
        .flatMap((response) {
      return TaskEither.fromEither(
          readJsonObject(response.body, mapper: User.fromJson, logger: _log));
    });
  }

  TaskEither<IOError, UserPerfStats> getUserPerfStatsTask(
      String username, Perf perf) {
    final String perfApiString = perf.toString().split('.').last;
    // The above line gets the enum's (perf) name as a string, because the way they are named
    // corresponds to how the api expects them to be received. This line could be removed by, for example,
    // adding another field to the Perf enum, like 'apiName'.

    return apiClient
        .get(Uri.parse('$kLichessHost/api/user/$username/perf/$perfApiString'))
        .flatMap((response) => TaskEither.fromEither(readJsonObject(
            response.body,
            mapper: UserPerfStats.fromJson,
            logger: _log)));
  }

  TaskEither<IOError, List<UserStatus>> getUsersStatusTask(List<String> ids) {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/users/status?ids=${ids.join(',')}'))
        .flatMap((response) => TaskEither.fromEither(readJsonListOfObjects(
            response.body,
            mapper: UserStatus.fromJson,
            logger: _log)));
  }

  void dispose() {
    apiClient.close();
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo =
      UserRepository(apiClient: apiClient, logger: Logger('UserRepository'));
  ref.onDispose(() => repo.dispose());
  return repo;
});
