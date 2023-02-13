import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/common/api_client.dart';
import 'auth_repository.dart';

part 'auth_repository_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  const auth = FlutterAppAuth();
  const storage = FlutterSecureStorage();
  final repo = AuthRepository(
    ref.watch(apiClientProvider),
    auth,
    storage,
    Logger('AuthRepository'),
  );
  return repo;
}
