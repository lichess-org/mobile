import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';

class AuthActionsNotifier extends StateNotifier<AsyncValue<void>> {
  AuthActionsNotifier({required this.authRepository})
      : super(const AsyncData<void>(null));

  final AuthRepository authRepository;

  Future<void> signIn() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(authRepository.signIn);
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(authRepository.signOut);
  }
}

final authActionsProvider =
    StateNotifierProvider.autoDispose<AuthActionsNotifier, AsyncValue<void>>(
        (ref) {
  return AuthActionsNotifier(
    authRepository: ref.watch(authRepositoryProvider),
  );
});
