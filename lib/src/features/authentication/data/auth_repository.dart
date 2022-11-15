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
import '../domain/account.codegen.dart';

const lichessClientId = 'lichess_mobile';
const redirectUri = 'org.lichess.mobile://login-callback';
const accountUrl = '$kLichessHost/api/account';
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
    required this.client,
  })  : _appAuth = appAuth,
        _storage = storage,
        _log = log;

  final AuthClient client;

  final Logger _log;
  final FlutterAppAuth _appAuth;
  final FlutterSecureStorage _storage;

  final _authState = InMemoryStore<Account?>(null);

  Stream<Account?> authStateChanges() => _authState.stream;
  Account? get currentAccount => _authState.value;

  Future<void> init() {
    return TaskEither<IOError, void>.tryCatch(
            () => _storage.read(key: lichessClientId), (error, trace) => GenericError(trace))
        .andThen(getAccount)
        .map((account) {
      _authState.value = account;
    }).run();
  }

  TaskEither<IOError, void> signIn() {
    return TaskEither<IOError, void>.tryCatch(() async {
      final result = await _appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
        lichessClientId,
        redirectUri,
        serviceConfiguration: const AuthorizationServiceConfiguration(
            authorizationEndpoint: '$kLichessHost/oauth', tokenEndpoint: '$kLichessHost/api/token'),
        scopes: oauthScopes,
      ));
      if (result != null) {
        _log.fine('Got accessToken ${result.accessToken}');
        await _storage.write(key: lichessClientId, value: result.accessToken);
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
    return TaskEither.tryCatch(() async {
      if (_authState.value != null) {
        await client.delete(Uri.parse('$kLichessHost/api/token'));
        await _storage.delete(key: lichessClientId);
        _authState.value = null;
      }
    }, (error, trace) {
      _log.severe('signOut error', error, trace);
      return ApiRequestError(trace);
    });
  }

  TaskEither<IOError, Account> getAccount() {
    return TaskEither.tryCatch(() async {
      final uri = Uri.parse('$kLichessHost/api/account');
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        return Account.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    }, (error, trace) {
      _log.warning('getAccount error', error, trace);
      return ApiRequestError(trace);
    });
  }

  void dispose() {
    _authState.close();
    client.close();
  }
}

class AuthClient extends http.BaseClient {
  final http.Client _inner;
  final FlutterSecureStorage storage;

  AuthClient(this._inner, this.storage);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await storage.read(key: lichessClientId);
    request.headers['Authorization'] = 'Bearer ${(token ?? '')}';
    return _inner.send(request);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  const auth = FlutterAppAuth();
  const storage = FlutterSecureStorage();
  final client = AuthClient(http.Client(), storage);
  final log = Logger('AuthRepository');
  final repo = AuthRepository(auth, storage, log, client: client);
  ref.onDispose(() => repo.dispose());
  return repo;
});

final authStateChangesProvider = StreamProvider.autoDispose<Account?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
