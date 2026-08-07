import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

/// Number of characters of a login code.
const _kLoginCodeLength = 6;

/// The two steps of the email login flow.
enum _EmailLoginStep { email, code }

/// Screen that signs the user in with a login code emailed to them.
class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const EmailLoginScreen());
  }

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  _EmailLoginStep step = _EmailLoginStep.email;

  /// The address the code was sent to. Only set once the first step succeeded.
  String? email;

  void onCodeSent(String value) {
    setState(() {
      email = value;
      step = _EmailLoginStep.code;
    });
  }

  void backToEmailStep() {
    setState(() {
      step = _EmailLoginStep.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Sign in with an email'),
        leading: step == _EmailLoginStep.code
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: backToEmailStep,
              )
            : null,
      ),
      body: PopScope(
        canPop: step == _EmailLoginStep.email,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) backToEmailStep();
        },
        child: SafeArea(
          child: switch (step) {
            .email => _EmailForm(initialValue: email, onCodeSent: onCodeSent),
            .code => _CodeForm(email: email!),
          },
        ),
      ),
    );
  }
}

/// First step: asks for the email address and requests a login code for it.
class _EmailForm extends ConsumerStatefulWidget {
  const _EmailForm({required this.initialValue, required this.onCodeSent});

  final String? initialValue;
  final void Function(String email) onCodeSent;

  @override
  ConsumerState<_EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends ConsumerState<_EmailForm> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController controller = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit() {
    if (formKey.currentState?.validate() != true) return;

    final email = controller.text.trim();

    FocusScope.of(context).unfocus();

    // The error is surfaced via the [ref.listen] in [build]; ignore the rethrown future so it does
    // not become an unhandled exception.
    emailLoginCodeRequestMutation.run(ref, (tsx) async {
      await tsx.get(authControllerProvider.notifier).requestEmailLoginCode(email);
      widget.onCodeSent(email);
    }).ignore();
  }

  @override
  Widget build(BuildContext context) {
    final requestState = ref.watch(emailLoginCodeRequestMutation);

    ref.listen(emailLoginCodeRequestMutation, (_, next) => showEmailLoginError(context, next));

    return Form(
      key: formKey,
      child: ListView(
        padding: Styles.bodySectionPadding,
        children: [
          const Text('We will email you a code to sign in with.'),
          const SizedBox(height: 24.0),
          TextFormField(
            controller: controller,
            autofocus: true,
            autofillHints: const [AutofillHints.email],
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: context.l10n.email,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              final email = value?.trim() ?? '';
              // Deliberately lenient: the server is the authority on what a valid address is, this
              // only catches obvious typos before spending a request.
              if (email.isEmpty || !email.contains('@') || email.contains(' ')) {
                return 'Please enter a valid email address.';
              }
              return null;
            },
            onFieldSubmitted: (_) => submit(),
          ),
          const SizedBox(height: 24.0),
          FilledButton(
            onPressed: switch (requestState) {
              MutationPending() => null,
              _ => submit,
            },
            child: const Text('Send me a code'),
          ),
        ],
      ),
    );
  }
}

/// Second step: asks for the code that was emailed, and exchanges it for a session.
class _CodeForm extends ConsumerStatefulWidget {
  const _CodeForm({required this.email});

  final String email;

  @override
  ConsumerState<_CodeForm> createState() => _CodeFormState();
}

class _CodeFormState extends ConsumerState<_CodeForm> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit() {
    if (formKey.currentState?.validate() != true) return;

    final code = controller.text.trim();

    FocusScope.of(context).unfocus();

    // The error is surfaced via the [ref.listen] in [build]; ignore the rethrown future so it does
    // not become an unhandled exception.
    emailLoginCodeSignInMutation.run(ref, (tsx) async {
      await tsx
          .get(authControllerProvider.notifier)
          .signInWithEmailCode(email: widget.email, code: code);
    }).ignore();
  }

  @override
  Widget build(BuildContext context) {
    final signInState = ref.watch(emailLoginCodeSignInMutation);

    ref.listen(emailLoginCodeSignInMutation, (_, next) {
      switch (next) {
        case MutationSuccess():
          Navigator.of(context).pop();
        case MutationError():
          // A wrong code is the expected mistake here, so clear the field to let the user try
          // again without having to erase it first.
          controller.clear();
          showEmailLoginError(context, next);
        case _:
          break;
      }
    });

    return Form(
      key: formKey,
      child: ListView(
        padding: Styles.bodySectionPadding,
        children: [
          Text(
            'If an account matches ${widget.email}, a $_kLoginCodeLength character code was sent '
            'to it. Check your inbox and enter the code below.',
          ),
          const SizedBox(height: 24.0),
          TextFormField(
            controller: controller,
            autofocus: true,
            autofillHints: const [AutofillHints.oneTimeCode],
            textInputAction: TextInputAction.done,
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.none,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
              LengthLimitingTextInputFormatter(_kLoginCodeLength),
            ],
            decoration: const InputDecoration(labelText: 'Code', border: OutlineInputBorder()),
            validator: (value) {
              if ((value?.trim() ?? '').length != _kLoginCodeLength) {
                return 'The code is $_kLoginCodeLength characters long.';
              }
              return null;
            },
            onFieldSubmitted: (_) => submit(),
          ),
          const SizedBox(height: 24.0),
          FilledButton(
            onPressed: switch (signInState) {
              MutationPending() => null,
              _ => submit,
            },
            child: Text(context.l10n.signIn),
          ),
          const SizedBox(height: 8.0),
          Text(
            'The code expires after 5 minutes and can only be used once.',
            style: TextTheme.of(context).bodySmall,
          ),
        ],
      ),
    );
  }
}

/// Shows an error snackbar when one of the email login mutations fails.
void showEmailLoginError(BuildContext context, MutationState<void> state) {
  if (state case MutationError(:final error)) {
    showSnackBar(context, switch (error) {
      EmailLoginRateLimitException() => 'Too many attempts. Please try again later.',
      InvalidEmailLoginCodeException() => 'This code is invalid or has expired.',
      _ => context.l10n.mobileSomethingWentWrong,
    }, type: SnackBarType.error);
  }
}
