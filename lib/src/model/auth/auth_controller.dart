import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/network/socket.dart';

/// A provider for [AuthController].
final authControllerProvider = NotifierProvider.autoDispose<AuthController, AuthSession?>(
  AuthController.new,
  name: 'AuthControllerProvider',
);

final signInMutation = Mutation<void>();
final signOutMutation = Mutation<void>();

class AuthController extends Notifier<AuthSession?> {
  @override
  AuthSession? build() {
    return ref.read(preloadedDataProvider).requireValue.userSession;
  }

  /// Signs in the user.
  Future<void> signIn() async {
    final session = await ref.read(authRepositoryProvider).signIn();

    await ref.read(sessionStorageProvider).write(session);

    // register device and reconnect to the current socket once the session token is updated
    await Future.wait([
      ref.read(notificationServiceProvider).registerDevice(),
      // force reconnect to the current socket with the new token
      ref.read(socketPoolProvider).currentClient.connect(),
    ]);

    if (!ref.mounted) return;
    state = session;
  }

  /// Signs out the user.
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    await ref.read(notificationServiceProvider).unregister();
    await ref.read(authRepositoryProvider).signOut();
    await ref.read(sessionStorageProvider).delete();
    // force reconnect to the current socket
    await ref.read(socketPoolProvider).currentClient.connect();
    if (!ref.mounted) return;
    state = null;
  }

  /// Checks if the current session token is still valid.
  ///
  /// If the token is invalid, it deletes the session from storage.
  Future<void> checkToken() async {
    if (state == null) {
      return;
    }

    final isValid = await ref.read(authRepositoryProvider).checkToken(state!);
    if (!isValid) {
      await ref.read(sessionStorageProvider).delete();
    }
    if (!ref.mounted) return;
    state = null;
  }
}
