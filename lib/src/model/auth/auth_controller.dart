import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:result_extensions/result_extensions.dart';

import 'package:lichess_mobile/src/app_dependencies.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/errors.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';

import 'user_session.dart';
import 'auth_repository.dart';
import 'session_storage.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> signIn() async {
    state = const AsyncLoading();

    final Result<UserSession> result =
        await ref.read(authRepositoryProvider).signIn().flatMap(
      (oAuthResp) {
        if (oAuthResp.accessToken != null) {
          final apiClient = ref.read(authClientProvider);
          return apiClient.get(
            Uri.parse('$kLichessHost/api/account'),
            headers: {'Authorization': 'Bearer ${oAuthResp.accessToken}'},
          ).flatMap((response) {
            return readJsonObject(response, mapper: User.fromJson).map((user) {
              return UserSession(
                token: oAuthResp.accessToken!,
                user: user.lightUser,
              );
            });
          });
        } else {
          return Future.value(
            Result<UserSession>.error(ApiRequestException()),
          );
        }
      },
    );

    state = result.fold(
      (session) {
        ref.read(authSessionProvider.notifier).update(session);
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
      await ref.read(authSessionProvider.notifier).delete();
    }
    state = result.asAsyncValue;
  }
}

@Riverpod(keepAlive: true)
class AuthSession extends _$AuthSession {
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
