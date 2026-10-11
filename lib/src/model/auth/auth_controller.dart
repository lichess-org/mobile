import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_storage.dart';
import 'package:lichess_mobile/src/model/auth/auth_user.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';

export 'auth_user.dart';

enum AuthEvent() {
  signIn,
  signOut,
}

final _authEventsController = StreamController<AuthEvent>.broadcast();

Stream<AuthEvent> get authEventsStream => _authEventsController.stream;

/// A provider for [AuthController].
final authControllerProvider = NotifierProvider.autoDispose<AuthController, AuthUser?>(
  AuthController.new,
  name: 'AuthControllerProvider',
);

/// A provider that indicates whether the user is logged in.
final isLoggedInProvider = Provider.autoDispose<bool>((Ref ref) {
  return ref.watch(authControllerProvider.select((authUser) => authUser != null));
}, name: 'IsLoggedInProvider');

final otherAccountsProvider = FutureProvider.autoDispose<IList<AuthUser>>((Ref ref) {
  ref.watch(authControllerProvider);
  return ref.read(authStorageProvider).readOthers();
}, name: 'OtherAccountsProvider');

final signInMutation = Mutation<void>();
final signOutMutation = Mutation<void>();
final switchAccountMutation = Mutation<void>();

/// Mutation for requesting the login code email.
final emailLoginCodeRequestMutation = Mutation<void>();

/// Mutation for exchanging the login code for a session.
final emailLoginCodeSignInMutation = Mutation<void>();

class const AccountSessionExpiredException() implements Exception {
  @override
  String toString() => 'The account session has expired.';
}

class AuthController() extends Notifier<AuthUser?> {
  @override
  AuthUser? build() {
    return ref.read(preloadedDataProvider).requireValue.authUser;
  }

  /// Signs in the user with the OAuth browser flow.
  Future<void> signIn() async {
    final authUser = await ref.read(authRepositoryProvider).signIn();
    await _onSignedIn(authUser);
  }

  /// Asks lichess to email a login code for the [username] account to [email].
  Future<void> requestEmailLoginCode({required String username, required String email}) {
    return ref.read(authRepositoryProvider).requestEmailLoginCode(username: username, email: email);
  }

  /// Signs in the user on the [username] account with the login code they received by [email].
  Future<void> signInWithEmailCode({
    required String username,
    required String email,
    required String code,
  }) async {
    final authUser = await ref
        .read(authRepositoryProvider)
        .signInWithEmailCode(username: username, email: email, code: code);
    await _onSignedIn(authUser);
  }

  Future<void> switchAccount(AuthUser account) async {
    final isValid = await ref.read(authRepositoryProvider).checkToken(account);
    if (!isValid) {
      final storage = ref.read(authStorageProvider);
      final others = await storage.readOthers();
      await storage.writeOthers(others.removeWhere((a) => a.user.id == account.user.id));
      if (ref.mounted) ref.invalidate(otherAccountsProvider);
      throw const AccountSessionExpiredException();
    }
    await _onSignedIn(account);
  }

  Future<void> _onSignedIn(AuthUser authUser) async {
    final storage = ref.read(authStorageProvider);
    final previous = state;
    final others = (await storage.readOthers()).removeWhere(
      (a) => a.user.id == authUser.user.id || a.user.id == previous?.user.id,
    );
    await storage.writeOthers(
      previous != null && previous.user.id != authUser.user.id
          ? others.insert(0, previous)
          : others,
    );
    await storage.write(authUser);

    if (!ref.mounted) return;
    state = authUser;

    _authEventsController.add(AuthEvent.signIn);
  }

  /// Signs out the user from the active account.
  /// If the user is signed in to other accounts, the most recently used one becomes active.
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    _authEventsController.add(AuthEvent.signOut);
    await ref.read(authRepositoryProvider).signOut();
    await _activateNextAccount();
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

  Future<void> _activateNextAccount() async {
    final storage = ref.read(authStorageProvider);
    final others = await storage.readOthers();
    if (others.isEmpty) {
      await storage.delete();
      if (!ref.mounted) return;
      state = null;
      return;
    }

    final next = others.first;
    await storage.writeOthers(others.removeAt(0));
    await storage.write(next);
    if (!ref.mounted) return;
    state = next;

    _authEventsController.add(AuthEvent.signIn);
  }
}
