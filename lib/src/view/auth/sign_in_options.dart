import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/view/auth/email_login_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';

/// Lets the user pick how to sign in, then starts the chosen flow.
///
/// The OAuth browser flow is the default, but it is unreliable on some Android browsers and OEMs,
/// hence the email login code alternative.
///
/// Failures of the browser flow are reported through [signInMutation], so callers are expected to
/// already listen to it with `showSignInErrorSnackBar`.
Future<void> showSignInOptions(BuildContext context, WidgetRef ref) {
  final navigator = Navigator.of(context, rootNavigator: true);

  return showAdaptiveActionSheet<void>(
    context: context,
    actions: [
      BottomSheetAction(
        makeLabel: (context) => const Text('Sign in with the browser'),
        leading: const Icon(Icons.open_in_browser),
        onPressed: () {
          // The error is surfaced by the caller's [ref.listen] on [signInMutation]; ignore the
          // rethrown future so it does not become an unhandled exception.
          signInMutation.run(ref, (tsx) async {
            await tsx.get(authControllerProvider.notifier).signIn();
          }).ignore();
        },
      ),
      BottomSheetAction(
        makeLabel: (context) => const Text('Sign in with an email'),
        leading: const Icon(Icons.mail_outline),
        onPressed: () {
          navigator.push(EmailLoginScreen.buildRoute());
        },
      ),
    ],
  );
}
