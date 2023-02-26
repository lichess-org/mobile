import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/app_dependencies.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

import 'session_storage.dart';

part 'user_session.freezed.dart';
part 'user_session.g.dart';

@Freezed(fromJson: true, toJson: true)
class UserSession with _$UserSession {
  const factory UserSession({
    required LightUser user,
    required String token,
  }) = _UserSession;

  factory UserSession.fromJson(Map<String, dynamic> json) =>
      _$UserSessionFromJson(json);
}

@riverpod
class UserSessionState extends _$UserSessionState {
  @override
  UserSession? build() {
    // requireValue is possible because appDependenciesProvider is loaded before
    // anything. See: lib/src/app.dart
    return ref.watch(
      appDependenciesProvider.select((data) => data.requireValue.userSession),
    );
  }

  Future<void> update(UserSession session) async {
    final sessionStorage = ref.read(sessionStorageProvider);
    await sessionStorage.write(session);
    state = session;
  }

  Future<void> delete() async {
    final sessionStorage = ref.read(sessionStorageProvider);
    await sessionStorage.delete();
    state = null;
  }
}
