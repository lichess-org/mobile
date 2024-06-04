import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: 'lichess_secure_storage',
      preferencesKeyPrefix: 'lichess.secure.',
    );

@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return FlutterSecureStorage(aOptions: _getAndroidOptions());
}
