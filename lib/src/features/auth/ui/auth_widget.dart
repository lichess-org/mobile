import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/async_value.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/features/settings/ui/theme_mode_notifier.dart';
import '../data/auth_repository.dart';
import './auth_widget_notifier.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    final authActionsAsync = ref.watch(authWidgetProvider);
    final brightness = ref.watch(selectedBrigthnessProvider);
    ref.listen<AsyncValue<void>>(
      authWidgetProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    return authState.maybeWhen(
        data: (account) => TextButton(
              onPressed: authActionsAsync.isLoading
                  ? null
                  : () => account == null
                      ? ref.read(authWidgetProvider.notifier).signIn()
                      : ref.read(authWidgetProvider.notifier).signOut(),
              child: authActionsAsync.isLoading
                  ? const ButtonLoadingIndicator()
                  : Text(
                      account == null
                          ? context.l10n.signIn
                          : context.l10n.logOut,
                      style: defaultTargetPlatform == TargetPlatform.android &&
                              brightness == Brightness.light
                          ? const TextStyle(color: Colors.white)
                          : null),
            ),
        orElse: () => const ButtonLoadingIndicator());
  }
}
