import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:result_extensions/result_extensions.dart';

import 'package:lichess_mobile/src/model/account/account_providers.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'auth_repository_providers.dart';

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
            .flatMap((_) => ref.read(accountRepositoryProvider).getProfile())
            .map(
              (account) =>
                  ref.read(authUserProvider.notifier).update(account.lightUser),
            ))
        .asAsyncValue;
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).signOut();
    final notifier = ref.read(authUserProvider.notifier);
    result.match(
      onSuccess: (_) => notifier.update(null),
      onError: (_, __) => notifier.update(null),
    );
    state = result.asAsyncValue;
  }
}

/// A provider that retrieves the authenticated user
@Riverpod(keepAlive: true)
class AuthUser extends _$AuthUser {
  @override
  LightUser? build() {
    return null;
  }

  Future<void> appInit() async {
    final accountRepo = ref.read(accountRepositoryProvider);
    final result = await accountRepo.getProfile();
    result.match(
      onSuccess: (account) {
        state = account.lightUser;
      },
    );
  }

  // ignore: use_setters_to_change_properties
  void update(LightUser? user) {
    state = user;
  }
}
