import 'package:flutter_secure_storage/flutter_secure_storage.dart';

AndroidOptions _getAndroidOptions() =>
    const AndroidOptions(storageNamespace: 'org.lichess.mobile.secure');

class const SecureStorage._({super.aOptions}) extends FlutterSecureStorage {
  static final instance = SecureStorage._(aOptions: _getAndroidOptions());
}
