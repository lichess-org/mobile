import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/notification_service.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_repository.dart';
import 'bearer.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> signIn() async {
    state = const AsyncLoading();

    final client = ref.read(httpClientFactoryProvider)();
    final appAuth = ref.read(appAuthProvider);
    final repo = AuthRepository(client, appAuth);

    try {
      final authResp = await repo.signIn();
      if (authResp.accessToken == null) {
        throw Exception('Access token not found.');
      }
      final session = await client.readBytes(
        Uri.parse('$kLichessHost/api/account'),
        headers: {
          'Authorization': 'Bearer ${signBearerToken(authResp.accessToken!)}',
        },
      ).then((bytes) {
        final user = readJsonObjectFromBytes(
          bytes,
          mapper: User.fromServerJson,
        );
        return AuthSessionState(
          token: authResp.accessToken!,
          user: user.lightUser,
        );
      });

      ref.read(authSessionProvider.notifier).update(session);
      ref.read(notificationServiceProvider).registerDevice();

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      client.close();
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final client = ref.read(httpClientFactoryProvider)();
    final repo = AuthRepository(client, ref.read(appAuthProvider));
    try {
      await repo.signOut();
      ref.read(notificationServiceProvider).unregister();
      await ref.read(authSessionProvider.notifier).delete();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      client.close();
    }
  }
}
