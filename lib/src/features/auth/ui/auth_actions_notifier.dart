import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:result_extensions/result_extensions.dart';

import '../data/auth_repository.dart';

class AuthActionsNotifier extends StateNotifier<AsyncValue<void>> {
  AuthActionsNotifier({required this.authRepository})
      : super(const AsyncData<void>(null));

  final AuthRepository authRepository;

  Future<void> signIn() async {
    state = const AsyncLoading();
    state = (await authRepository.signIn()).fold(
      AsyncValue.data,
      (error, trace) => AsyncValue.error(error, trace ?? StackTrace.current),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = (await authRepository.signOut()).fold(
      AsyncValue.data,
      (error, trace) => AsyncValue.error(error, trace ?? StackTrace.current),
    );
  }
}

final authActionsProvider =
    StateNotifierProvider.autoDispose<AuthActionsNotifier, AsyncValue<void>>(
        (ref) {
  return AuthActionsNotifier(
    authRepository: ref.watch(authRepositoryProvider),
  );
});
