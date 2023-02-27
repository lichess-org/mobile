import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:result_extensions/result_extensions.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';

import 'user_session.dart';
import 'auth_repository.dart';

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
          final apiClient = ref.read(apiClientProvider);
          return apiClient.get(
            Uri.parse('$kLichessHost/api/account'),
            headers: {'Authorization': 'Bearer ${oAuthResp.accessToken}'},
          ).flatMap((response) {
            return readJsonObject(response.body, mapper: User.fromJson)
                .map((user) {
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

    result.match(
      onSuccess: (session) {
        ref.read(userSessionStateProvider.notifier).update(session);
      },
    );

    state = const AsyncData(null);
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await ref.read(authRepositoryProvider).signOut();
    await ref.read(userSessionStateProvider.notifier).delete();
    state = const AsyncData(null);
  }
}
