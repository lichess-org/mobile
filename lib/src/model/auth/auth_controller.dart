import 'package:flutter/foundation.dart';
import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:result_extensions/result_extensions.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';

import 'session_repository.dart';
import 'user_session.dart';
import 'auth_repository.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<UserSession?> build() {
    final repo = ref.watch(sessionRepositoryProvider);
    return repo.read();
  }

  Future<void> signIn() async {
    state = const AsyncLoading();
    state = (await ref.read(authRepositoryProvider).signIn().flatMap(
      (oAuthResp) {
        if (oAuthResp.accessToken != null) {
          final sessionRepo = ref.read(sessionRepositoryProvider);
          final apiClient = ref.read(apiClientProvider);
          return apiClient.get(
            Uri.parse('$kLichessHost/api/account'),
            headers: {'Authorization': 'Bearer ${oAuthResp.accessToken}'},
          ).flatMap((response) {
            return readJsonObject(response.body, mapper: User.fromJson)
                .map((user) {
              final newSession = UserSession(
                token: oAuthResp.accessToken!,
                user: user.lightUser,
              );
              sessionRepo.write(newSession);
              return newSession;
            });
          }).mapError((err, st) {
            debugPrint(
              'SEVERE: [AuthController] could not fetch account; $err\n$st',
            );
            return ApiRequestException();
          });
        } else {
          return Future.value(
            Result<UserSession?>.error(ApiRequestException()),
          );
        }
      },
    ))
        .asAsyncValue;
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).signOut();
    result.match(
      onSuccess: (_) => _deleteSession(),
      onError: (_, __) => _deleteSession(),
    );
    state = const AsyncData(null);
  }

  Future<void> _deleteSession() async {
    final sessionRepo = ref.read(sessionRepositoryProvider);
    sessionRepo.delete();
  }
}
