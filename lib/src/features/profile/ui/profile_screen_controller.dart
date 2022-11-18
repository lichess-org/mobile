import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/data/auth_repository.dart';

class ProfileScreenController extends StateNotifier<AsyncValue<void>> {
  ProfileScreenController({required this.authRepository}) : super(const AsyncData<void>(null));

  final AuthRepository authRepository;

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = (await authRepository.signOut().run())
        .match((error) => AsyncValue.error(error.message, error.stackTrace), AsyncValue.data);
  }
}

final profileScreenControllerProvider =
    StateNotifierProvider.autoDispose<ProfileScreenController, AsyncValue<void>>((ref) {
  return ProfileScreenController(
    authRepository: ref.watch(authRepositoryProvider),
  );
});
