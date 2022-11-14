import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';

enum AccountMenu { logout }

class SignInAppBarWidget extends ConsumerWidget {
  const SignInAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    return authState.maybeWhen(
        data: (account) => account != null
            ? PopupMenuButton<AccountMenu>(
                icon: const Icon(Icons.person),
                onSelected: (AccountMenu item) {
                  switch (item) {
                    case AccountMenu.logout:
                      // TODO handle errors
                      ref.read(authRepositoryProvider).signOut().run();
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<AccountMenu>>[
                  const PopupMenuItem<AccountMenu>(
                    value: AccountMenu.logout,
                    child: Text('Sign out'),
                  ),
                ],
              )
            : TextButton(
                onPressed: () async {
                  // TODO handle errors
                  await ref.read(authRepositoryProvider).signIn().run();
                },
                child: const Text('Sign in'),
              ),
        orElse: () => const CircularProgressIndicator());
  }
}
