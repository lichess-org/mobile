import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_session.freezed.dart';
part 'auth_session.g.dart';

@Riverpod(keepAlive: true)
class AuthSession extends _$AuthSession {
  @override
  AuthSessionState? build() {
    return ref.read(preloadedDataProvider).requireValue.userSession;
  }

  Future<void> update(AuthSessionState session) async {
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

@Freezed(fromJson: true, toJson: true)
sealed class AuthSessionState with _$AuthSessionState {
  const factory AuthSessionState({required LightUser user, required String token}) =
      _AuthSessionState;

  factory AuthSessionState.fromJson(Map<String, dynamic> json) => _$AuthSessionStateFromJson(json);
}

@riverpod
bool isLoggedIn(Ref ref) {
  return ref.watch(authSessionProvider.select((authSession) => authSession != null));
}
