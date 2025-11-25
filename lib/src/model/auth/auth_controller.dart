import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_storage.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/socket.dart';

part 'auth_controller.freezed.dart';
part 'auth_controller.g.dart';

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

    // register device and reconnect to the current socket once the authUser token is updated
    await Future.wait([
      ref.read(notificationServiceProvider).registerDevice(),
      // force reconnect to the current socket with the new token
      ref.read(socketPoolProvider).currentClient.connect(),
    ]);

    if (!ref.mounted) return;
    state = authUser;
  }

  /// Signs out the user.
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    await ref.read(notificationServiceProvider).unregister();
    await ref.read(authRepositoryProvider).signOut();
    await ref.read(authStorageProvider).delete();
    // force reconnect to the current socket
    await ref.read(socketPoolProvider).currentClient.connect();
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

@Freezed(fromJson: true, toJson: true)
sealed class AuthUser with _$AuthUser {
  const factory AuthUser({required LightUser user, required String token}) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);
}
