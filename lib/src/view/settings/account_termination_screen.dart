import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

/// How an [AccountTerminationScreen] terminates the account.
enum AccountTermination() {
  /// The account is closed: it can be reopened, unless it is closed forever.
  close,

  /// The account is scheduled for deletion: it cannot be recovered.
  delete,
}

/// A screen to close or delete the account of the signed in user, after checking their
/// credentials.
class const AccountTerminationScreen(final AccountTermination termination, {super.key})
    extends ConsumerStatefulWidget {
  static Route<dynamic> buildRoute(AccountTermination termination) {
    return buildScreenRoute(screen: AccountTerminationScreen(termination));
  }

  @override
  ConsumerState<AccountTerminationScreen> createState() => _AccountTerminationScreenState();
}

class _AccountTerminationScreenState() extends ConsumerState<AccountTerminationScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _tokenController = TextEditingController();
  late final _closeInsteadRecognizer = TapGestureRecognizer()..onTap = _closeInstead;
  bool _obscurePassword = true;
  bool _forever = false;
  bool _understand = false;
  bool _showTokenField = false;
  String? _usernameError;
  String? _passwordError;
  String? _tokenError;

  late final _fields = Listenable.merge([
    _usernameController,
    _passwordController,
    _tokenController,
  ]);

  bool get _isDelete => widget.termination == .delete;

  Mutation<void> get _mutation => switch (widget.termination) {
    .close => closeAccountMutation,
    .delete => deleteAccountMutation,
  };

  bool get _canSubmit {
    if (_usernameController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      return false;
    }
    if (_showTokenField && _tokenController.text.trim().isEmpty) {
      return false;
    }
    if (_isDelete && !_understand) {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _tokenController.dispose();
    _closeInsteadRecognizer.dispose();
    super.dispose();
  }

  void _closeInstead() {
    if (ref.read(_mutation) is MutationPending) return;
    Navigator.of(context)
        .pushReplacement(AccountTerminationScreen.buildRoute(AccountTermination.close));
  }

  void _submit() {
    if (ref.read(_mutation) is MutationPending || !_canSubmit) return;
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog.adaptive(
          title: Text(
            _isDelete
                ? 'Are you sure you want to delete your account?'
                : context.l10n.settingsCloseAccountAreYouSure,
            style: TextTheme.of(context).bodyLarge,
          ),
          actions: [
            PlatformDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(context.l10n.no),
            ),
            PlatformDialogAction(
              cupertinoIsDestructiveAction: true,
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _performTermination();
              },
              child: Text(context.l10n.yes),
            ),
          ],
        );
      },
    );
  }

  void _performTermination() {
    FocusScope.of(context).unfocus();
    setState(() {
      _usernameError = null;
      _passwordError = null;
      _tokenError = null;
    });
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final token = _showTokenField ? _tokenController.text.trim() : '';
    final forever = _forever;
    // The mutation signs the user out once the account is terminated, so the sign out happens even
    // if the screen is left while the request is pending.
    _mutation.run(ref, (tsx) async {
      final authController = tsx.get(authControllerProvider.notifier);
      switch (widget.termination) {
        case .close:
          await authController.closeAccount(
            username: username,
            password: password,
            token: token,
            forever: forever,
          );
        case .delete:
          await authController.deleteAccount(username: username, password: password);
      }
    }).ignore();
  }

  void _onError(Object error) {
    if (error is ServerException) {
      if (error.statusCode == 404) {
        showSnackBar(
          context,
          context.l10n.settingsManagedAccountCannotBeClosed,
          type: SnackBarType.error,
        );
        return;
      }
      if (error.statusCode == 429) {
        showSnackBar(context, context.l10n.mobileTooManyLoginAttempts, type: SnackBarType.error);
        return;
      }
      final jsonError = error.jsonError ?? const <String, dynamic>{};
      if (jsonError.containsKey('token')) {
        setState(() {
          _showTokenField = true;
          _tokenError = context.l10n.invalidAuthenticationCode;
        });
        return;
      }
      if (jsonError.containsKey('passwd')) {
        setState(() {
          _passwordError = context.l10n.incorrectPassword;
        });
        return;
      }
      if (jsonError.containsKey('username')) {
        setState(() {
          _usernameError = context.l10n.invalidUsernameOrPassword;
        });
        return;
      }
    }
    showSnackBar(context, context.l10n.mobileSomethingWentWrong, type: SnackBarType.error);
  }

  @override
  Widget build(BuildContext context) {
    final authUser = ref.watch(authControllerProvider);
    final mutationState = ref.watch(_mutation);

    ref.listen(_mutation, (_, next) {
      switch (next) {
        case MutationSuccess():
          // Taken before popping, to inform the user on the screen below.
          final navigator = Navigator.of(context);
          final snackBar = SnackBarPresenter.of(context);
          final closedMessage = context.l10n.settingsThisAccountIsClosed;
          final okLabel = context.l10n.mobileOkButton;
          navigator.popUntil((route) => route.isFirst);
          switch (widget.termination) {
            case .close:
              snackBar.show(closedMessage, type: .success);
            case .delete:
              // The wording of the page lichess.org shows after a deletion
              // (/account/delete/done): the user must know that they can still cancel it.
              showDialog<void>(
                context: navigator.context,
                builder: (dialogContext) => AlertDialog.adaptive(
                  title: const Text('Account deletion is pending'),
                  content: const Text(
                    'Your account has been closed, and is scheduled for complete deletion in 7 '
                    'days from now.\n\n'
                    'You can reopen your account and cancel the scheduled deletion by logging '
                    'into your account.\n\n'
                    "If you don't log into your account, it will be permanently deleted.",
                  ),
                  actions: [
                    PlatformDialogAction(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: Text(okLabel),
                    ),
                  ],
                ),
              );
          }
        case MutationError(:final error):
          _onError(error);
        case _:
          break;
      }
    });

    // The form stays disabled after a successful termination, until the screen is popped.
    final pending = mutationState is MutationPending || mutationState is MutationSuccess;
    final subtitleStyle = ListTileTheme.of(context).subtitleTextStyle
        ?.copyWith(fontSize: TextTheme.of(context).bodySmall?.fontSize);
    final title = _isDelete
        ? context.l10n.settingsDeleteYourAccount
        : context.l10n.settingsCloseAccount;
    final closeInsteadLink = context.l10n.settingsCloseYourAccount;
    final closeInsteadText = context.l10n.settingsWouldYouLikeToXInstead(closeInsteadLink);
    final closeInsteadLinkStart = closeInsteadText.indexOf(closeInsteadLink);

    Widget body;
    // The user is signed out as part of the termination: keep the form on screen until it is
    // popped.
    if (authUser == null && !pending) {
      body = Center(child: Text(context.l10n.mobileMustBeLoggedIn));
    } else {
      body = AutofillGroup(
        // The padding is read below the scaffold, which adds the bar heights to it.
        child: Builder(
          builder: (context) => ListView(
            padding: Styles.bodySectionPadding.add(MediaQuery.paddingOf(context)),
            children: [
              Text(context.l10n.settingsWereSorryToSeeYouGo, style: subtitleStyle),
              const SizedBox(height: 8.0),
              Text(
                _isDelete
                    ? context.l10n.settingsDeleteAccountWarning
                    : context.l10n.settingsCloseAccountAreYouSure,
                style: TextTheme.of(context).bodyLarge,
              ),
              const SizedBox(height: 8.0),
              Text(context.l10n.settingsCantOpenSimilarAccount, style: subtitleStyle),
              if (_isDelete) ...[
                const SizedBox(height: 8.0),
                Text.rich(
                  closeInsteadLinkStart < 0
                      ? TextSpan(text: closeInsteadText)
                      : TextSpan(
                          children: [
                            TextSpan(text: closeInsteadText.substring(0, closeInsteadLinkStart)),
                            TextSpan(
                              text: closeInsteadLink,
                              style: TextStyle(color: ColorScheme.of(context).primary),
                              recognizer: _closeInsteadRecognizer,
                            ),
                            TextSpan(
                              text: closeInsteadText.substring(
                                closeInsteadLinkStart + closeInsteadLink.length,
                              ),
                            ),
                          ],
                        ),
                  style: subtitleStyle,
                ),
              ],
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _usernameController,
                autocorrect: false,
                enableSuggestions: false,
                autofillHints: const [AutofillHints.username],
                textCapitalization: .none,
                textInputAction: .next,
                decoration: InputDecoration(
                  labelText: context.l10n.username,
                  errorText: _usernameError,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                enableSuggestions: false,
                autocorrect: false,
                autofillHints: const [AutofillHints.password],
                textInputAction: _showTokenField ? .next : .done,
                decoration: InputDecoration(
                  labelText: context.l10n.password,
                  errorText: _passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Symbols.visibility : Symbols.visibility_off),
                    tooltip: context.l10n.showPassword,
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                onFieldSubmitted: (_) => _submit(),
              ),
              if (_showTokenField) ...[
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _tokenController,
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: .none,
                  textInputAction: .done,
                  decoration: InputDecoration(
                    labelText: context.l10n.tfaAuthenticationCode,
                    helperText: context.l10n.tfaOpenTwoFactorApp,
                    errorText: _tokenError,
                  ),
                  onFieldSubmitted: (_) => _submit(),
                ),
              ],
              const SizedBox(height: 16.0),
              Card(
                margin: EdgeInsets.zero,
                clipBehavior: .hardEdge,
                child: _isDelete
                    ? CheckboxListTile(
                        value: _understand,
                        title: Text(
                          context.l10n.settingsDeleteAccountConfirmText,
                          style: TextTheme.of(context).bodyMedium,
                        ),
                        onChanged: pending
                            ? null
                            : (value) {
                                setState(() {
                                  _understand = value ?? false;
                                });
                              },
                      )
                    : CheckboxListTile(
                        value: _forever,
                        title: Text(
                          context.l10n.settingsCloseAccountForeverLabel,
                          style: TextTheme.of(context).bodyMedium,
                        ),
                        subtitle: Text(
                          context.l10n.settingsCloseAccountForeverWarning,
                          style: subtitleStyle,
                        ),
                        onChanged: pending
                            ? null
                            : (value) {
                                setState(() {
                                  _forever = value ?? false;
                                });
                              },
                      ),
              ),
              const SizedBox(height: 24.0),
              ListenableBuilder(
                listenable: _fields,
                builder: (context, _) => FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: ColorScheme.of(context).error,
                    foregroundColor: ColorScheme.of(context).onError,
                  ),
                  onPressed: pending || !_canSubmit ? null : _submit,
                  child: pending ? const ButtonLoadingIndicator() : Text(title),
                ),
              ),
              const SizedBox(height: 8.0),
              TextButton(
                onPressed: pending ? null : () => Navigator.of(context).pop(),
                child: Text(context.l10n.cancel),
              ),
            ],
          ),
        ),
      );
    }

    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(title)),
      body: body,
    );
  }
}
