import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:result_extensions/result_extensions.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';

part 'account_repository.g.dart';

@Riverpod(keepAlive: true)
AccountRepository accountRepository(AccountRepositoryRef ref) {
  final apiClient = ref.watch(authClientProvider);
  return AccountRepository(
    logger: Logger('UserRepository'),
    apiClient: apiClient,
  );
}

@riverpod
Future<User> account(AccountRef ref) async {
  final link = ref.cacheFor(const Duration(minutes: 5));
  final repo = ref.watch(accountRepositoryProvider);
  final result = await repo.getProfile();
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}

class AccountRepository {
  const AccountRepository({
    required AuthClient apiClient,
    required Logger logger,
  })  : _apiClient = apiClient,
        _log = logger;

  final AuthClient _apiClient;
  final Logger _log;

  FutureResult<User> getProfile() {
    return _apiClient.get(Uri.parse('$kLichessHost/api/account')).then(
          (result) => result.flatMap(
            (response) => readJsonObject(
              response,
              mapper: User.fromJson,
              logger: _log,
            ),
          ),
        );
  }
}
