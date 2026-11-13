import 'dart:async';

import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_storage.dart';
import 'package:lichess_mobile/src/model/auth/auth_user.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:logging/logging.dart';

export 'auth_user.dart';

enum AuthEvent() {
  signIn,
  signOut,
}

final _logger = Logger('AuthController');

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

final signInMutation = Mutation<void>();
final signOutMutation = Mutation<void>();

/// Mutation for closing the account of the signed in user.
final closeAccountMutation = Mutation<void>();

/// Mutation for deleting the account of the signed in user.
final deleteAccountMutation = Mutation<void>();

/// Mutation for requesting the login code email.
final emailLoginCodeRequestMutation = Mutation<void>();

/// Mutation for exchanging the login code for a session.
final emailLoginCodeSignInMutation = Mutation<void>();

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

  Future<void> _onSignedIn(AuthUser authUser) async {
    await ref.read(authStorageProvider).write(authUser);

    if (!ref.mounted) return;
    state = authUser;

    _authEventsController.add(AuthEvent.signIn);
  }

  /// Signs out the user.
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    _authEventsController.add(AuthEvent.signOut);
    await ref.read(authRepositoryProvider).signOut();
    await ref.read(authStorageProvider).delete();
    if (!ref.mounted) return;
    state = null;
  }

  /// Closes the account of the signed in user, then signs them out of the app.
  Future<void> closeAccount({
    required String username,
    required String password,
    required String token,
    required bool forever,
  }) async {
    await ref
        .read(accountRepositoryProvider)
        .closeAccount(username: username, password: password, token: token, forever: forever);
    await _signOutTerminatedAccount();
  }

  /// Schedules the deletion of the account of the signed in user, then signs them out of the app.
  Future<void> deleteAccount({required String username, required String password}) async {
    await ref.read(accountRepositoryProvider).deleteAccount(username: username, password: password);
    await _signOutTerminatedAccount();
  }

  /// Signs out of a closed or deleted account.
  ///
  /// The server revokes the account tokens and unregisters its devices from push notifications
  /// when it closes or deletes the account, so the sign out only clears the local session.
  Future<void> _signOutTerminatedAccount() async {
    try {
      await ref.read(authStorageProvider).delete();
    } catch (e, st) {
      // The account is closed: a failure here must not be reported as a failure to close it. The
      // stored session is dropped by the next token check, since its token is revoked.
      _logger.severe('Could not delete the session of the closed account:', e, st);
    }
    if (!ref.mounted) return;
    state = null;
    _authEventsController.add(AuthEvent.signOut);
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
