import 'package:flutter_secure_storage/flutter_secure_storage.dart';

AndroidOptions _getAndroidOptions() =>
    const AndroidOptions(sharedPreferencesName: 'org.lichess.mobile.secure');

class SecureStorage extends FlutterSecureStorage {
  const SecureStorage._({super.aOptions});

  static final instance = SecureStorage._(aOptions: _getAndroidOptions());
}
