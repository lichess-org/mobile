import 'package:flutter/services.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/user/user_repository.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:material_ui/material_ui.dart';

/// Number of characters of a login code.
const _kLoginCodeLength = 6;

/// Address shapes accepted before a code is requested.
final _emailRegExp = RegExp(
  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+"
  '@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?'
  r'(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$',
);

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

  /// The account the code was requested for. Only set once the first step succeeded.
  String? username;

  /// The address the code was sent to. Only set once the first step succeeded.
  String? email;

  void onCodeSent({required String username, required String email}) {
    setState(() {
      this.username = username;
      this.email = email;
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
            .email => _EmailForm(
              initialUsername: username,
              initialEmail: email,
              onCodeSent: onCodeSent,
            ),
            .code => _CodeForm(username: username!, email: email!),
          },
        ),
      ),
    );
  }
}

/// First step: asks for the account name and email address, and requests a login code for them.
class _EmailForm extends ConsumerStatefulWidget {
  const _EmailForm({
    required this.initialUsername,
    required this.initialEmail,
    required this.onCodeSent,
  });

  final String? initialUsername;
  final String? initialEmail;
  final void Function({required String username, required String email}) onCodeSent;

  @override
  ConsumerState<_EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends ConsumerState<_EmailForm> {
  final formKey = GlobalKey<FormState>();
  late final usernameController = TextEditingController(text: widget.initialUsername);
  late final emailController = TextEditingController(text: widget.initialEmail);

  /// The name the server did not recognise, if any.
  String? unknownUsername;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void submit() {
    if (formKey.currentState?.validate() != true) return;

    final username = usernameController.text.trim();
    final email = emailController.text.trim();

    FocusScope.of(context).unfocus();

    // The error is surfaced via the [ref.listen] in [build]; ignore the rethrown future so it does
    // not become an unhandled exception.
    emailLoginCodeRequestMutation.run(ref, (tsx) async {
      if (!await usernameExists(tsx, username)) {
        if (!mounted) return;
        setState(() {
          unknownUsername = username;
        });
        formKey.currentState?.validate();
        return;
      }

      await tsx
          .get(authControllerProvider.notifier)
          .requestEmailLoginCode(username: username, email: email);
      widget.onCodeSent(username: username, email: email);
    }).ignore();
  }

  /// Checks the name against the server, catching typos before a code is requested.
  ///
  /// A check that could not be made lets the name through.
  Future<bool> usernameExists(MutationTransaction tsx, String username) async {
    try {
      return await tsx.get(userRepositoryProvider).usernameExists(username);
    } catch (_) {
      return true;
    }
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
            controller: usernameController,
            autofocus: true,
            autofillHints: const [AutofillHints.username],
            textInputAction: TextInputAction.next,
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.none,
            decoration: InputDecoration(
              labelText: context.l10n.username,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              final username = value?.trim() ?? '';
              if (username.isEmpty) {
                return 'Please enter your username.';
              }
              // Set by [submit] when the server did not know the name. Usernames are
              // case-insensitive, so a case-only edit is still the same rejected account.
              if (username.toLowerCase() == unknownUsername?.toLowerCase()) {
                return context.l10n.usernameNotFound(username);
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: emailController,
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
              if (!_emailRegExp.hasMatch(email)) {
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
  const _CodeForm({required this.username, required this.email});

  final String username;
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
          .signInWithEmailCode(username: widget.username, email: widget.email, code: code);
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
