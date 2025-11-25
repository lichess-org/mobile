import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'auth_session.freezed.dart';
part 'auth_session.g.dart';

/// A provider for [AuthSessionNotifier].
final authSessionProvider = NotifierProvider<AuthSessionNotifier, AuthSession?>(
  AuthSessionNotifier.new,
  name: 'AuthSessionProvider',
);

/// A provider that indicates whether the user is logged in.
final isLoggedInProvider = Provider.autoDispose<bool>((Ref ref) {
  return ref.watch(authSessionProvider.select((authSession) => authSession != null));
}, name: 'IsLoggedInProvider');

class AuthSessionNotifier extends Notifier<AuthSession?> {
  @override
  AuthSession? build() {
    return ref.read(preloadedDataProvider).requireValue.userSession;
  }

  Future<void> update(AuthSession session) async {
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
sealed class AuthSession with _$AuthSession {
  const factory AuthSession({required LightUser user, required String token}) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) => _$AuthSessionFromJson(json);
}
