import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/in_memory_store.dart';
import '../../../utils/errors.dart';
import '../../../constants.dart';
import '../../../http.dart';
import '../domain/account.codegen.dart';

const redirectUri = 'org.lichess.mobile://login-callback';
const oauthScopes = ['board:play'];

class AuthError {
  AuthError(this.message, this.stackTrace);

  final String message;
  final StackTrace stackTrace;
}

class AuthRepository {
  AuthRepository(
    FlutterAppAuth appAuth,
    FlutterSecureStorage storage,
    Logger log, {
    required this.apiClient,
  })  : _appAuth = appAuth,
        _storage = storage,
        _log = log;

  final ApiClient apiClient;

  final Logger _log;
  final FlutterAppAuth _appAuth;
  final FlutterSecureStorage _storage;

  final _authState = InMemoryStore<Account?>(null);

  Stream<Account?> authStateChanges() => _authState.stream;
  Account? get currentAccount => _authState.value;
  bool get isAuthenticated => _authState.value != null;

  Future<void> init() {
    return TaskEither<IOError, void>.tryCatch(
            () => _storage.read(key: kOAuthTokenStorageKey),
            (error, trace) => GenericError(trace))
        .andThen(getAccount)
        .map((account) {
      _authState.value = account;
    }).run();
  }

  TaskEither<IOError, void> signIn() {
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
    }).andThen(getAccount).map((account) {
      _authState.value = account;
    });
  }

  TaskEither<IOError, void> signOut() {
    return apiClient
        .delete(Uri.parse('$kLichessHost/api/token'))
        .map((_) async {
      await _storage.delete(key: kOAuthTokenStorageKey);
      _authState.value = null;
    });
  }

  TaskEither<IOError, Account> getAccount() {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/account'))
        .map((response) => Account.fromJson(jsonDecode(response.body)));
  }

  void dispose() {
    _authState.close();
    apiClient.close();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  const auth = FlutterAppAuth();
  const storage = FlutterSecureStorage();
  final authClient = AuthClient(storage, http.Client());
  final apiClient = ApiClient(Logger('ApiClient'), authClient);
  final repo = AuthRepository(auth, storage, Logger('AuthRepository'),
      apiClient: apiClient);
  ref.onDispose(() => repo.dispose());
  return repo;
});

final authStateChangesProvider = StreamProvider.autoDispose<Account?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
