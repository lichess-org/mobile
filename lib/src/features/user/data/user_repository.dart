import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import '../model/user.dart';

class UserRepository {
  const UserRepository({required this.apiClient, required Logger logger})
      : _log = logger;

  final ApiClient apiClient;
  final Logger _log;

  AsyncResult<User> getUser(String username) {
    return apiClient.get(Uri.parse('$kLichessHost/api/user/$username')).then(
        (result) => result.flatMap((response) => readJsonObject(response.body,
            mapper: User.fromJson, logger: _log)));
  }

  AsyncResult<List<UserStatus>> getUsersStatus(List<String> ids) {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/users/status?ids=${ids.join(',')}'))
        .then((result) => result.flatMap((response) => readJsonListOfObjects(
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
