import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_storage.dart';
import 'package:lichess_mobile/src/model/auth/auth_user.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';

export 'auth_user.dart';

/// A provider for [AuthController].
final authControllerProvider = NotifierProvider.autoDispose<AuthController, AuthUser?>(
  AuthController.new,
  name: 'AuthControllerProvider',
);

/// A provider that indicates whether the user is logged in.
final isLoggedInProvider = Provider.autoDispose<bool>((Ref ref) {
  return ref.watch(authControllerProvider.select((authUser) => authUser != null));
}, name: 'IsLoggedInProvider');

final signInMutation = Mutation<void>();
final signOutMutation = Mutation<void>();

class AuthController extends Notifier<AuthUser?> {
  @override
  AuthUser? build() {
    return ref.read(preloadedDataProvider).requireValue.authUser;
  }

  /// Signs in the user.
  Future<void> signIn() async {
    final authUser = await ref.read(authRepositoryProvider).signIn();

    await ref.read(authStorageProvider).write(authUser);

    if (!ref.mounted) return;
    state = authUser;

    authEventsController.add(AuthEvent.signIn);
  }

  /// Signs out the user.
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    authEventsController.add(AuthEvent.signOut);
    await ref.read(authRepositoryProvider).signOut();
    await ref.read(authStorageProvider).delete();
    if (!ref.mounted) return;
    state = null;
  }

  /// Checks if the current authUser token is still valid.
  ///
  /// If the token is invalid, it deletes the authUser from storage.
  Future<void> checkToken() async {
    if (state == null) {
      return;
    }

    final isValid = await ref.read(authRepositoryProvider).checkToken(state!);
    if (!isValid) {
      await ref.read(authStorageProvider).delete();
      if (!ref.mounted) return;
      state = null;
    }
  }
}
