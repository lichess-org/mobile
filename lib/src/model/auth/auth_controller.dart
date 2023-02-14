import 'package:flutter/foundation.dart';
import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:http/http.dart' as http;

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/model/auth/session_providers.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';

import 'user_session.dart';
import 'auth_repository.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  Future<void> build() async {}

  Future<void> signIn() async {
    state = const AsyncLoading();
    state = (await ref
            .read(authRepositoryProvider)
            .signIn()
            .flatMap((oAuthResp) async {
      if (oAuthResp.accessToken != null) {
        final sessionRepo = ref.read(sessionRepositoryProvider);
        final client = http.Client();
        try {
          final resp = await client.get(
            Uri.parse('$kLichessHost/api/account'),
            headers: {'Authorization': 'Bearer ${oAuthResp.accessToken}'},
          );
          return readJsonObject(resp.body, mapper: User.fromJson).map((user) {
            sessionRepo.write(
              UserSession(token: oAuthResp.accessToken!, user: user.lightUser),
            );
          }).mapError((err, st) {
            debugPrint(
              'SEVERE: [AuthController] could not fetch account; $err\n$st',
            );
            return GenericIOException();
          });
        } catch (err, st) {
          debugPrint(
            'SEVERE: [AuthController] could not fetch account; $err\n$st',
          );
          return Result<void>.error(err, st);
        } finally {
          client.close();
        }
      } else {
        return Result<void>.error(ApiRequestException());
      }
    }))
        .asAsyncValue;
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).signOut();
    final sessionRepo = ref.read(sessionRepositoryProvider);
    result.match(
      onSuccess: (_) => sessionRepo.delete(),
      onError: (_, __) => sessionRepo.delete(),
    );
    state = result.asAsyncValue;
  }
}
