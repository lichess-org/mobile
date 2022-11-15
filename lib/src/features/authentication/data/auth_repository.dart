import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/in_memory_store.dart';
import '../../../constants.dart';
import '../domain/account.codegen.dart';

const lichessClientId = 'lichess_mobile';
const redirectUri = 'org.lichess.mobile://login-callback';
const accountUrl = '$kLichessHost/api/account';
const oauthScopes = ['board:play'];

class AuthError {
  AuthError(this.error);

  final Object error;
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
    return _getToken().andThen(getAccount).match((_) {
      _log.info('No account found during init');
    }, (account) {
      _authState.value = account;
    }).run();
  }

  TaskEither<AuthError, void> signIn() {
    return TaskEither.tryCatch(() async {
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
        throw Exception('FlutterAppAuth.authorizeAndExchangeCode error');
      }
    }, (error, trace) {
      _log.severe('Could not sign in', error, trace);
      return AuthError(error);
    }).andThen(getAccount).map((account) {
      _authState.value = account;
    });
  }

  TaskEither<AuthError, void> signOut() {
    return TaskEither.tryCatch(() async {
      if (_authState.value != null) {
        await client.delete(Uri.parse('$kLichessHost/api/token'));
        await _storage.delete(key: lichessClientId);
        _authState.value = null;
      }
    }, (error, trace) {
      _log.severe('signOut error', error, trace);
      return AuthError(error);
    });
  }

  TaskEither<AuthError, Account> getAccount() {
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
      return AuthError(error);
    });
  }

  void dispose() {
    _authState.close();
    client.close();
  }

  TaskEither<AuthError, String?> _getToken() =>
      TaskEither.tryCatch(() => _storage.read(key: lichessClientId), (error, trace) {
        _log.severe('_getToken error', error, trace);
        return AuthError(error);
      });
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
