import 'dart:convert';
import 'dart:developer' as developer;
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
  AuthError(this.message);

  final String message;
}

class AuthRepository {
  AuthRepository(
    FlutterAppAuth appAuth,
    FlutterSecureStorage storage, {
    required this.client,
  })  : _appAuth = appAuth,
        _storage = storage;

  final AuthClient client;

  final FlutterAppAuth _appAuth;
  final FlutterSecureStorage _storage;

  final _authState = InMemoryStore<Account?>(null);

  Stream<Account?> authStateChanges() => _authState.stream;
  Account? get currentAccount => _authState.value;

  Future<void> init() {
    return _getToken().andThen(getAccount).match((_) {
      developer.log('[AuthRepository] no account found during init');
    }, (account) {
      _authState.value = account;
    }).run();
  }

  TaskEither<AuthError, void> signIn() {
    return TaskEither.tryCatch(
      () async {
        final result = await _appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
          lichessClientId,
          redirectUri,
          serviceConfiguration: const AuthorizationServiceConfiguration(
              authorizationEndpoint: '$kLichessHost/oauth',
              tokenEndpoint: '$kLichessHost/api/token'),
          scopes: oauthScopes,
        ));
        if (result != null) {
          developer.log('[AuthRepository] got accessToken ${result.accessToken}');
          await _storage.write(key: lichessClientId, value: result.accessToken);
        } else {
          throw Exception('[AuthRepository] Could not login');
        }
      },
      (error, _) => AuthError(error.toString()),
    ).andThen(getAccount).map((account) {
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
    }, (error, _) => AuthError(error.toString()));
  }

  TaskEither<AuthError, Account> getAccount() {
    return TaskEither.tryCatch(() async {
      final uri = Uri.parse('$kLichessHost/api/account');
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        return Account.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('[AuthRepository] Could not get account (error ${response.statusCode})');
      }
    }, (error, _) => AuthError(error.toString()));
  }

  void dispose() {
    _authState.close();
    client.close();
  }

  TaskEither<AuthError, String?> _getToken() => TaskEither.tryCatch(
      () => _storage.read(key: lichessClientId), (error, _) => AuthError(error.toString()));
}

class AuthClient extends http.BaseClient {
  final http.Client _inner;
  final FlutterSecureStorage storage;

  AuthClient(this._inner, this.storage);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await storage.read(key: lichessClientId);
    request.headers['Authorization'] = 'Bearer ${(token ?? '')}';
    developer.log('http authorization header: ${request.headers['Authorization']!}');
    return _inner.send(request);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  const auth = FlutterAppAuth();
  const storage = FlutterSecureStorage();
  final client = AuthClient(http.Client(), storage);
  final repo = AuthRepository(auth, storage, client: client);
  ref.onDispose(() => repo.dispose());
  return repo;
});

final authStateChangesProvider = StreamProvider.autoDispose<Account?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
