import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';

class AuthWidgetNotifier extends StateNotifier<AsyncValue<void>> {
  AuthWidgetNotifier({required this.authRepository})
      : super(const AsyncData<void>(null));

  final AuthRepository authRepository;

  Future<void> signIn() async {
    state = const AsyncLoading();
    state = (await authRepository.signInTask().run()).match(
        (error) => AsyncValue.error(error.message, error.stackTrace),
        AsyncValue.data);
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = (await authRepository.signOutTask().run()).match(
        (error) => AsyncValue.error(error.message, error.stackTrace),
        AsyncValue.data);
  }
}

final authWidgetProvider =
    StateNotifierProvider.autoDispose<AuthWidgetNotifier, AsyncValue<void>>(
        (ref) {
  return AuthWidgetNotifier(
    authRepository: ref.watch(authRepositoryProvider),
  );
});
