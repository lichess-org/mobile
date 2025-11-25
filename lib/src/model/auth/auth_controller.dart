import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';

/// A provider for [AuthController].
final authControllerProvider = AsyncNotifierProvider.autoDispose<AuthController, void>(
  AuthController.new,
  name: 'AuthControllerProvider',
);

class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() {
    return Future.value();
  }

  Future<void> signIn() async {
    state = const AsyncLoading();

    final appAuth = ref.read(appAuthProvider);

    try {
      final session = await ref.withClient((client) => AuthRepository(client, appAuth).signIn());

      await ref.read(authSessionProvider.notifier).update(session);

      // register device and reconnect to the current socket once the session token is updated
      await Future.wait([
        ref.read(notificationServiceProvider).registerDevice(),
        // force reconnect to the current socket with the new token
        ref.read(socketPoolProvider).currentClient.connect(),
      ]);

      if (!ref.mounted) return;
      state = const AsyncValue.data(null);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final appAuth = ref.read(appAuthProvider);

    try {
      await ref.read(notificationServiceProvider).unregister();
      await ref.withClient((client) => AuthRepository(client, appAuth).signOut());
      await ref.read(authSessionProvider.notifier).delete();
      // force reconnect to the current socket
      await ref.read(socketPoolProvider).currentClient.connect();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
