import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/async_value.dart';

import '../data/auth_repository.dart';
import './auth_widget_controller.dart';

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
            ? PopupMenuButton<AccountMenu>(
                icon: const Icon(Icons.person),
                onSelected: (AccountMenu item) {
                  switch (item) {
                    case AccountMenu.logout:
                      if (!uiState.isLoading) {
                        ref.read(authControllerProvider.notifier).signOut();
                      }
                      break;
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<AccountMenu>>[
                  PopupMenuItem<AccountMenu>(
                    value: AccountMenu.logout,
                    child: uiState.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Sign out'),
                  ),
                ],
              )
            : TextButton(
                onPressed: uiState.isLoading
                    ? null
                    : () => ref.read(authControllerProvider.notifier).signIn(),
                child: uiState.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Sign in'),
              ),
        orElse: () => const CircularProgressIndicator());
  }
}
