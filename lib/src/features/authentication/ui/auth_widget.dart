import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/async_value.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import '../data/auth_repository.dart';
import './auth_widget_notifier.dart';

enum AccountMenu { logout }

class AuthWidget extends ConsumerWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    final authActionsAsync = ref.watch(authWidgetProvider);
    ref.listen<AsyncValue>(
      authWidgetProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    return authState.maybeWhen(
        data: (account) => account != null
            ? PopupMenuButton<AccountMenu>(
                icon: const Icon(Icons.person),
                onSelected: (AccountMenu item) {
                  switch (item) {
                    case AccountMenu.logout:
                      if (!authActionsAsync.isLoading) {
                        ref.read(authWidgetProvider.notifier).signOut();
                      }
                      break;
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<AccountMenu>>[
                  PopupMenuItem<AccountMenu>(
                    value: AccountMenu.logout,
                    child: authActionsAsync.isLoading
                        ? const CircularProgressIndicator.adaptive()
                        : Text(context.l10n.logOut),
                  ),
                ],
              )
            : TextButton(
                onPressed: authActionsAsync.isLoading
                    ? null
                    : () => ref.read(authWidgetProvider.notifier).signIn(),
                child: authActionsAsync.isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : Text(context.l10n.signIn),
              ),
        orElse: () => const CircularProgressIndicator.adaptive());
  }
}
