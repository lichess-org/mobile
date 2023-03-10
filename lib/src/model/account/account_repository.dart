import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:result_extensions/result_extensions.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';

part 'account_repository.g.dart';

@Riverpod(keepAlive: true)
AccountRepository accountRepository(AccountRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AccountRepository(
    logger: Logger('UserRepository'),
    apiClient: apiClient,
  );
}

@riverpod
Future<User> account(AccountRef ref) {
  ref.cacheFor(const Duration(minutes: 5));
  final repo = ref.watch(accountRepositoryProvider);
  return Result.release(repo.getProfile());
}

class AccountRepository {
  const AccountRepository({
    required ApiClient apiClient,
    required Logger logger,
  })  : _apiClient = apiClient,
        _log = logger;

  final ApiClient _apiClient;
  final Logger _log;

  FutureResult<User> getProfile() {
    return _apiClient.get(Uri.parse('$kLichessHost/api/account')).then(
          (result) => result.flatMap(
            (response) => readJsonObject(
              response.body,
              mapper: User.fromJson,
              logger: _log,
            ),
          ),
        );
  }
}
