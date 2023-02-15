import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';

import 'account_repository.dart';

part 'account_providers.g.dart';

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
  ref.cacheFor(RequestCacheDuration.standard);
  final repo = ref.watch(accountRepositoryProvider);
  return Result.release(repo.getProfile());
}
