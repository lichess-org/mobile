import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/utils/in_memory_store.dart';
import 'package:lichess_mobile/src/constants.dart';
import '../../user/model/user.dart';

const redirectUri = 'org.lichess.mobile://login-callback';
const oauthScopes = ['board:play'];

class AuthError {
  AuthError(this.message, this.stackTrace);

  final String message;
  final StackTrace stackTrace;
}

class AuthRepository {
  AuthRepository(ApiClient apiClient, FlutterAppAuth appAuth,
      FlutterSecureStorage storage, Logger log)
      : _apiClient = apiClient,
        _appAuth = appAuth,
        _storage = storage,
        _log = log;

  final ApiClient _apiClient;
  final Logger _log;
  final FlutterAppAuth _appAuth;
  final FlutterSecureStorage _storage;

  final _authState = InMemoryStore<User?>(null);

  Stream<User?> authStateChanges() => _authState.stream;
  User? get currentAccount => _authState.value;
  bool get isAuthenticated => _authState.value != null;

  Future<void> init() {
    return TaskEither<IOError, void>.tryCatch(
            () => _storage.read(key: kOAuthTokenStorageKey),
            (error, trace) => GenericError(trace))
        .andThen(getAccountTask)
        .map((account) {
      _authState.value = account;
    }).run();
  }

  TaskEither<IOError, void> signInTask() {
    return TaskEither<IOError, void>.tryCatch(() async {
      final result =
          await _appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
        kLichessClientId,
        redirectUri,
        serviceConfiguration: const AuthorizationServiceConfiguration(
            authorizationEndpoint: '$kLichessHost/oauth',
            tokenEndpoint: '$kLichessHost/api/token'),
        scopes: oauthScopes,
      ));
      if (result != null) {
        _log.fine('Got accessToken ${result.accessToken}');
        await _storage.write(
            key: kOAuthTokenStorageKey, value: result.accessToken);
      } else {
        throw Exception('FlutterAppAuth.authorizeAndExchangeCode null result');
      }
    }, (error, trace) {
      _log.severe('signIn error', error, trace);
      return GenericError(trace);
    }).andThen(getAccountTask).map((account) {
      _authState.value = account;
    });
  }

  TaskEither<IOError, void> signOutTask() {
    return _apiClient
        .delete(Uri.parse('$kLichessHost/api/token'))
        .map((_) async {
      await _storage.delete(key: kOAuthTokenStorageKey);
      _authState.value = null;
    });
  }

  TaskEither<IOError, User> getAccountTask() {
    return _apiClient.get(Uri.parse('$kLichessHost/api/account')).map(
        (response) =>
            User.fromJson(jsonDecode(response.body) as Map<String, dynamic>));
  }

  void dispose() {
    _authState.close();
    _apiClient.close();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  const auth = FlutterAppAuth();
  const storage = FlutterSecureStorage();
  final apiClient = ref.watch(apiClientProvider);
  final repo =
      AuthRepository(apiClient, auth, storage, Logger('AuthRepository'));
  ref.onDispose(() => repo.dispose());
  return repo;
});

final authStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
