import 'package:async/async.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/firebase_messaging.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/errors.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:result_extensions/result_extensions.dart';
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

    final Result<AuthSessionState> result =
        await ref.read(authRepositoryProvider).signIn().flatMap(
      (oAuthResp) {
        if (oAuthResp.accessToken != null) {
          final apiClient = ref.read(authClientProvider);
          return apiClient.get(
            Uri.parse('$kLichessHost/api/account'),
            headers: {
              'Authorization':
                  'Bearer ${signBearerToken(oAuthResp.accessToken!)}',
            },
          ).flatMap((response) {
            return readJsonObjectFromResponse(
              response,
              mapper: User.fromServerJson,
            ).map((user) {
              return AuthSessionState(
                token: oAuthResp.accessToken!,
                user: user.lightUser,
              );
            });
          });
        } else {
          return Future.value(
            Result<AuthSessionState>.error(
              const ApiRequestException(500, 'Access token not found.'),
            ),
          );
        }
      },
    );

    state = result.fold(
      (session) {
        ref.read(authSessionProvider.notifier).update(session);
        ref.read(firebaseMessagingServiceProvider).registerDevice();
        return const AsyncValue.data(null);
      },
      (e, st) {
        return AsyncValue.error(e, st ?? StackTrace.current);
      },
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final result = await ref.read(authRepositoryProvider).signOut();
    if (result.isValue) {
      ref.read(firebaseMessagingServiceProvider).unregister();
      await ref.read(authSessionProvider.notifier).delete();
    }
    state = result.asAsyncValue;
  }
}
