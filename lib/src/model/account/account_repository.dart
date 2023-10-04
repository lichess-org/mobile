import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';

import 'account_preferences.dart';

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
Future<User?> account(AccountRef ref) async {
  final session = ref.watch(authSessionProvider);
  final link = ref.cacheFor(const Duration(minutes: 5));
  final repo = ref.watch(accountRepositoryProvider);
  if (session != null) {
    final result = await repo.getProfile();
    if (result.isError) {
      link.close();
    }
    return result.asFuture;
  }
  return null;
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

  FutureResult<AccountPrefState> getPreferences() {
    return _apiClient
        .get(Uri.parse('$kLichessHost/api/account/preferences'))
        .then(
          (result) => result.flatMap(
            (response) => readJsonObject(
              response,
              mapper: (Map<String, dynamic> json) {
                return _accountPreferencesFromPick(
                  pick(json, 'prefs').required(),
                );
              },
              logger: _log,
            ),
          ),
        );
  }

  FutureResult<void> setPreference<T>(String prefKey, AccountPref<T> pref) {
    return _apiClient.post(
      Uri.parse('$kLichessHost/api/account/preferences/$prefKey'),
      body: {prefKey: pref.toFormData},
    );
  }
}

AccountPrefState _accountPreferencesFromPick(RequiredPick pick) {
  return (
    zenMode: Zen.fromInt(
      pick('zen').asIntOrThrow(),
    ),
    showRatings: BooleanPref.fromInt(pick('ratings').asIntOrThrow()),
    premove: BooleanPref(pick('premove').asBoolOrThrow()),
    autoQueen: AutoQueen.fromInt(
      pick('autoQueen').asIntOrThrow(),
    ),
    autoThreefold: AutoThreefold.fromInt(
      pick('autoThreefold').asIntOrThrow(),
    ),
    takeback: Takeback.fromInt(
      pick('takeback').asIntOrThrow(),
    ),
    moretime: Moretime.fromInt(
      pick('moretime').asIntOrThrow(),
    ),
    confirmResign: BooleanPref.fromInt(
      pick('confirmResign').asIntOrThrow(),
    ),
    submitMove: SubmitMove.fromInt(
      pick('submitMove').asIntOrThrow(),
    ),
  );
}
