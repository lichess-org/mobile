import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/async_value.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/features/settings/ui/theme_mode_notifier.dart';
import '../data/auth_repository.dart';
import './auth_actions_notifier.dart';

class SignInWidget extends ConsumerWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    final authActionsAsync = ref.watch(authActionsProvider);
    final brightness = ref.watch(selectedBrigthnessProvider);
    ref.listen<AsyncValue<void>>(
      authActionsProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    return authState.maybeWhen(
        data: (account) => account == null
            ? TextButton(
                onPressed: authActionsAsync.isLoading
                    ? null
                    : () => ref.read(authActionsProvider.notifier).signIn(),
                child: authActionsAsync.isLoading
                    ? const ButtonLoadingIndicator()
                    : Text(context.l10n.signIn,
                        style:
                            defaultTargetPlatform == TargetPlatform.android &&
                                    brightness == Brightness.light
                                ? const TextStyle(color: Colors.white)
                                : null),
              )
            : const SizedBox.shrink(),
        orElse: () => const ButtonLoadingIndicator());
  }
}
