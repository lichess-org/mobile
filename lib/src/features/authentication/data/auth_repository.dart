import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../constants.dart';

const lichessClientId = 'lichess_mobile';
const redirectUri = 'org.lichess.mobile://login-callback';
const accountUrl = '$kLichessHost/api/account';

class AuthRepository {
  AuthRepository(
    FlutterAppAuth appAuth, {
    required this.client,
    required this.storage,
  }) : _appAuth = appAuth;

  final FlutterAppAuth _appAuth;
  final http.Client client;
  final FlutterSecureStorage storage;

  Future<void> login() async {
    try {
      final result = await _appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
        lichessClientId,
        redirectUri,
        serviceConfiguration: const AuthorizationServiceConfiguration(
            authorizationEndpoint: '$kLichessHost/oauth', tokenEndpoint: '$kLichessHost/api/token'),
        scopes: ['board:play'],
      ));
      if (result != null) {
        developer.log('Got accessToken ${result.accessToken}');
        await storage.write(key: lichessClientId, value: result.accessToken);
        // await _getMyAccount();
      } else {
        throw Exception('Could not login');
      }
    } on Exception catch (e, s) {
      developer.log('Error on login: $e, $s');
    }
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
    developer.log('http authorization header: ${request.headers['Authorization']!}');
    return _inner.send(request);
  }
}
