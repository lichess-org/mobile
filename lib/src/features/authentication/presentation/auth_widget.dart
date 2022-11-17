import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beamer/beamer.dart';

import '../../../utils/extensions.dart';
import '../data/auth_repository.dart';
import './auth_widget_controller.dart';

import '../../profile/presentation/profile_screen.dart';

enum AccountMenu { logout }

class AuthWidget extends ConsumerWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    final uiState = ref.watch(authControllerProvider);
    ref.listen<AsyncValue>(
      authControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    return authState.maybeWhen(
        data: (account) => account != null
            ? IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Beamer.of(context, root: true).beamToNamed('/profile');
                  // Navigator.of(context, rootNavigator: true).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const ProfileScreen(),
                  //     fullscreenDialog: true,
                  //   ),
                  // );
                },
              )
            : TextButton(
                onPressed: uiState.isLoading
                    ? null
                    : () => ref.read(authControllerProvider.notifier).signIn(),
                child:
                    uiState.isLoading ? const CircularProgressIndicator() : const Text('Sign in'),
              ),
        orElse: () => const CircularProgressIndicator());
  }
}
