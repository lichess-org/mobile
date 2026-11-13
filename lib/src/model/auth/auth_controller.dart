import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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

final otherAccountsProvider = FutureProvider.autoDispose<IList<AuthUser>>((Ref ref) {
  ref.watch(authControllerProvider);
  return ref.read(authStorageProvider).readOthers();
}, name: 'OtherAccountsProvider');

final signInMutation = Mutation<void>();
final signOutMutation = Mutation<void>();
final switchAccountMutation = Mutation<void>();

/// Mutation for closing the account of the signed in user.
final closeAccountMutation = Mutation<void>();

/// Mutation for deleting the account of the signed in user.
final deleteAccountMutation = Mutation<void>();

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
      await _serialized(() async {
        final storage = ref.read(authStorageProvider);
        final others = await storage.readOthers();
        await storage.writeOthers(others.removeWhere((a) => a.user.id == account.user.id));
      });
      if (ref.mounted) ref.invalidate(otherAccountsProvider);
      throw const AccountSessionExpiredException();
    }
    await _onSignedIn(account);
  }

  Future<void> _onSignedIn(AuthUser authUser) async {
    final replaced = await _serialized(() async {
      final storage = ref.read(authStorageProvider);
      final previous = state;
      final stored = await storage.readOthers();
      final others = stored.removeWhere(
        (a) => a.user.id == authUser.user.id || a.user.id == previous?.user.id,
      );
      await storage.writeOthers(
        previous != null && previous.user.id != authUser.user.id
            ? others.insert(0, previous)
            : others,
      );
      await storage.write(authUser);

      if (ref.mounted) {
        state = authUser;
        _authEventsController.add(AuthEvent.signIn);
      }

      // The session this sign in replaces, when the user signed in again to an account they were
      // already signed in to.
      return [
        ?previous,
        ...stored,
      ].where((a) => a.user.id == authUser.user.id && a.token != authUser.token).firstOrNull;
    });

    // The replaced token is not stored anymore, so it could never be revoked later.
    if (replaced != null) {
      unawaited(
        ref.read(authRepositoryProvider).revokeToken(replaced).catchError((
          Object e,
          StackTrace st,
        ) {
          _logger.warning('Could not revoke the token of a replaced session:', e, st);
        }),
      );
    }
  }

  /// Signs out the user from the active account.
  /// If the user is signed in to other accounts, the most recently used one becomes active.
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final signedOut = state;
    _authEventsController.add(AuthEvent.signOut);
    await ref.read(authRepositoryProvider).signOut();
    if (signedOut != null) await _activateNextAccount(replacing: signedOut);
  }

  /// Signs out of every account the user is signed in to.
  ///
  /// The tokens are revoked on a best effort basis: the sessions are forgotten even if it fails,
  /// e.g. offline.
  Future<void> signOutOfAllAccounts() async {
    final storage = ref.read(authStorageProvider);
    // Forgotten first, so that a token check of a 401 response meanwhile can't make one active.
    final others = await _serialized(() async {
      final others = await storage.readOthers();
      await storage.writeOthers(const IListConst([]));
      return others;
    });

    final repository = ref.read(authRepositoryProvider);
    for (final other in others) {
      unawaited(
        repository.revokeToken(other).catchError((Object e, StackTrace st) {
          _logger.warning('Could not revoke the token of ${other.user.id}:', e, st);
        }),
      );
    }

    if (state != null) {
      _authEventsController.add(AuthEvent.signOut);
      try {
        await repository.signOut();
      } catch (e, st) {
        _logger.warning('Could not revoke the token of the active session:', e, st);
      }
    }

    await _serialized(() async {
      await storage.delete();
      if (ref.mounted) state = null;
    });
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

  /// Checks whether the token of [authUser], a session that got a 401 response, is still valid.
  ///
  /// If it is invalid and [authUser] is still the active session, the session is deleted and the
  /// next account the user is signed in to becomes active, if any. The check is skipped if
  /// [authUser] is not the active session anymore, e.g. when a request made before the user signed
  /// out of it gets its 401 response after that.
  Future<void> checkToken(AuthUser authUser) async {
    if (state?.token != authUser.token) return;

    final isValid = await ref.read(authRepositoryProvider).checkToken(authUser);
    if (!isValid) {
      _logger.info('The token of the active session is invalid, signing out of it');
      await _activateNextAccount(replacing: authUser);
    }
  }

  /// Replaces the [replacing] session with the most recently used other account whose token is
  /// valid, or signs the user out if there is none.
  ///
  /// Does nothing if [replacing] is not the active session anymore: another transition already
  /// replaced it.
  Future<void> _activateNextAccount({required AuthUser replacing}) {
    return _serialized(() async {
      if (!ref.mounted || state?.token != replacing.token) return;

      final storage = ref.read(authStorageProvider);
      var others = await storage.readOthers();
      AuthUser? next;
      while (next == null && others.isNotEmpty) {
        final candidate = others.first;
        others = others.removeAt(0);
        if (await _isTokenValidOrUnknown(candidate)) next = candidate;
      }
      await storage.writeOthers(others);

      if (next == null) {
        await storage.delete();
        if (!ref.mounted) return;
        state = null;
        return;
      }

      await storage.write(next);
      if (!ref.mounted) return;
      state = next;
      _authEventsController.add(AuthEvent.signIn);
    });
  }

  /// Whether the token of [authUser] is valid, or `true` if it can't be checked, e.g. offline.
  ///
  /// An unknown token is kept: if it is invalid, the first request made with it gets a 401 response,
  /// and [checkToken] then replaces it.
  Future<bool> _isTokenValidOrUnknown(AuthUser authUser) async {
    try {
      return await ref.read(authRepositoryProvider).checkToken(authUser);
    } catch (e, st) {
      _logger.warning('Could not check the token of ${authUser.user.id}:', e, st);
      return true;
    }
  }

  /// The last session transition, which the next one waits for.
  ///
  /// Each transition reads the stored sessions, then writes them back across several awaits, so two
  /// concurrent ones (e.g. a sign out and the token check of a 401 response) would otherwise lose
  /// the writes of each other.
  Future<void> _lastTransition = Future<void>.value();

  /// Runs [transition] once the previous session transitions have completed.
  Future<T> _serialized<T>(Future<T> Function() transition) {
    final result = _lastTransition.then((_) => transition());
    _lastTransition = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }
}
