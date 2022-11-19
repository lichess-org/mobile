import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';

class AuthWidgetController extends StateNotifier<AsyncValue<void>> {
  AuthWidgetController({required this.authRepository})
      : super(const AsyncData<void>(null));

  final AuthRepository authRepository;

  Future<void> signIn() async {
    state = const AsyncLoading();
    state = (await authRepository.signIn().run()).match(
        (error) => AsyncValue.error(error.message, error.stackTrace),
        AsyncValue.data);
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = (await authRepository.signOut().run()).match(
        (error) => AsyncValue.error(error.message, error.stackTrace),
        AsyncValue.data);
  }
}

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthWidgetController, AsyncValue<void>>(
        (ref) {
  return AuthWidgetController(
    authRepository: ref.watch(authRepositoryProvider),
  );
});
