import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/async_value.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';

class SignInWidget extends ConsumerWidget {
  const SignInWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);
    final session = ref.watch(authSessionProvider);

    ref.listen<AsyncValue<void>>(
      authControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );

    final button = AppBarTextButton(
      onPressed: authController.isLoading
          ? null
          : () => ref.read(authControllerProvider.notifier).signIn(),
      child: Text(
        context.l10n.signIn,
      ),
    );
    return session == null ? button : const SizedBox.shrink();
  }
}
