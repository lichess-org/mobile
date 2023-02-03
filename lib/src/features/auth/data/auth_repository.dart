import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/common/package_info.dart';
import 'package:lichess_mobile/src/utils/in_memory_store.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/constants.dart';
import '../../user/model/user.dart';

const redirectUri = 'org.lichess.mobile://login-callback';
const oauthScopes = ['board:play'];

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  const auth = FlutterAppAuth();
  const storage = FlutterSecureStorage();
  final info = ref.watch(packageInfoProvider);
  final repo = AuthRepository(
    info,
    http.Client(),
    auth,
    storage,
    Logger('AuthRepository'),
  );
  ref.onDispose(() => repo.dispose());
  return repo;
});

/// A provider that gets current authenticated user.
final currentAccountProvider = Provider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.currentAccount;
});

/// A provider that stream the changes of the authenticated user.
final authStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

class AuthError {
  AuthError(this.message, this.stackTrace);

  final String message;
  final StackTrace stackTrace;
}

class AuthRepository {
  AuthRepository(
    PackageInfo info,
    http.Client client,
    FlutterAppAuth appAuth,
    FlutterSecureStorage storage,
    Logger log,
  )   : _info = info,
        _client = client,
        _appAuth = appAuth,
        _storage = storage,
        _log = log;

  final PackageInfo _info;
  final http.Client _client;
  final Logger _log;
  final FlutterAppAuth _appAuth;
  final FlutterSecureStorage _storage;

  final _authState = InMemoryStore<User?>(null);

  Stream<User?> authStateChanges() => _authState.stream;
  User? get currentAccount => _authState.value;
  bool get isAuthenticated => _authState.value != null;

  Future<void> init() {
    return getAccount().forEach((account) {
      _authState.value = account;
    });
  }

  FutureResult<void> signIn() {
    final future = (() async {
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          kLichessClientId,
          redirectUri,
          allowInsecureConnections: kDebugMode,
          serviceConfiguration: const AuthorizationServiceConfiguration(
            authorizationEndpoint: '$kLichessHost/oauth',
            tokenEndpoint: '$kLichessHost/api/token',
          ),
          scopes: oauthScopes,
        ),
      );
      if (result != null) {
        _log.fine('Got accessToken ${result.accessToken}');
        await _storage.write(
          key: kOAuthTokenStorageKey,
          value: result.accessToken,
        );
      } else {
        throw Exception('FlutterAppAuth.authorizeAndExchangeCode null result');
      }
    })();

    return Result.capture(future)
        .mapError((error, trace) {
          _log.severe('signIn error', error, trace);
          return ApiRequestException();
        })
        .flatMap((_) => getAccount())
        .map((account) {
          _authState.value = account;
        });
  }

  FutureResult<void> signOut() async {
    final token = await _storage.read(key: kOAuthTokenStorageKey);
    final headers = {
      'user-agent': ApiClient.userAgent(_info, currentAccount),
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final uri = Uri.parse('$kLichessHost/api/token');
    _log.info('DELETE $uri $headers');
    return Result.capture(
      _client.delete(uri, headers: headers).then((_) async {
        await _storage.delete(key: kOAuthTokenStorageKey);
        _authState.value = null;
      }),
    ).mapError((error, trace) {
      _log.severe('signOut error', error, trace);
      return ApiRequestException();
    });
  }

  FutureResult<User> getAccount() async {
    final token = await _storage.read(key: kOAuthTokenStorageKey);
    final uri = Uri.parse('$kLichessHost/api/account');
    final headers = {
      'user-agent': ApiClient.userAgent(_info, currentAccount),
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    _log.info('GET $uri $headers');
    return Result.capture(
      _client.get(uri, headers: headers).then((response) async {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        // server returns {"error":"No such token"} in case of wrong token
        if (json['error'] != null) {
          await _storage.delete(key: kOAuthTokenStorageKey);
          throw Exception('Server does not recognize token: $token');
        }
        return readJsonObject(
          response.body,
          mapper: User.fromJson,
          logger: _log,
        ).asFuture;
      }),
    ).mapError((error, trace) {
      _log.severe('getAccount error', error, trace);
      return ApiRequestException();
    });
  }

  void dispose() {
    _authState.close();
    _client.close();
  }
}
