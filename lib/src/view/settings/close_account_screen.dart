import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
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

class const CloseAccountScreen({super.key}) extends ConsumerStatefulWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const CloseAccountScreen());
  }

  @override
  ConsumerState<CloseAccountScreen> createState() => _CloseAccountScreenState();
}

class _CloseAccountScreenState() extends ConsumerState<CloseAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _tokenController = TextEditingController();
  bool _obscurePassword = true;
  bool _forever = false;
  bool _showTokenField = false;
  String? _usernameError;
  String? _passwordError;
  String? _tokenError;

  OutlineInputBorder _pillBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(28.0)),
      borderSide: BorderSide(color: color),
    );
  }

  bool get _canSubmit {
    if (_usernameController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      return false;
    }
    if (_showTokenField && _tokenController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onFieldsChanged);
    _passwordController.addListener(_onFieldsChanged);
    _tokenController.addListener(_onFieldsChanged);
  }

  void _onFieldsChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _usernameController.removeListener(_onFieldsChanged);
    _passwordController.removeListener(_onFieldsChanged);
    _tokenController.removeListener(_onFieldsChanged);
    _usernameController.dispose();
    _passwordController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _usernameError = _usernameController.text.trim().isEmpty
          ? context.l10n.invalidUsernameOrPassword
          : null;
      _passwordError = _passwordController.text.isEmpty ? context.l10n.incorrectPassword : null;
      if (_showTokenField && _tokenController.text.trim().isEmpty) {
        _tokenError = context.l10n.invalidAuthenticationCode;
      } else {
        _tokenError = null;
      }
    });
    if (_usernameError != null || _passwordError != null || _tokenError != null) {
      return;
    }
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog.adaptive(
          title: Text(
            context.l10n.settingsCloseAccountAreYouSure,
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
                _performClose();
              },
              child: Text(context.l10n.yes),
            ),
          ],
        );
      },
    );
  }

  void _performClose() {
    FocusScope.of(context).unfocus();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final token = _showTokenField ? _tokenController.text.trim() : '';
    final forever = _forever;
    closeAccountMutation.run(ref, (tsx) async {
      await tsx
          .get(accountRepositoryProvider)
          .closeAccount(username: username, password: password, token: token, forever: forever);
    }).ignore();
  }

  Future<void> _onSuccess() async {
    await signOutMutation.run(ref, (tsx) async {
      await tsx.get(authControllerProvider.notifier).signOut();
    });
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _onError(Object error) {
    if (error is ServerException) {
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
    final kidMode = ref.watch(kidModeProvider).value ?? false;
    final closeState = ref.watch(closeAccountMutation);

    ref.listen(closeAccountMutation, (_, next) {
      switch (next) {
        case MutationSuccess():
          _onSuccess();
        case MutationError(:final error):
          _onError(error);
        case _:
          break;
      }
    });

    final pending = closeState is MutationPending;
    final outline = ColorScheme.of(context).outline;
    final error = ColorScheme.of(context).error;

    Widget body;
    if (authUser == null) {
      body = Center(child: Text(context.l10n.mobileMustBeLoggedIn));
    } else if (kidMode) {
      body = ListView(
        padding: Styles.bodySectionPadding,
        children: [Text(context.l10n.settingsManagedAccountCannotBeClosed)],
      );
    } else {
      body = Form(
        key: _formKey,
        child: AutofillGroup(
          child: ListView(
            padding: Styles.bodySectionPadding,
            children: [
              Text(
                context.l10n.settingsWereSorryToSeeYouGo,
                style: ListTileTheme.of(context).subtitleTextStyle
                    ?.copyWith(fontSize: TextTheme.of(context).bodySmall?.fontSize),
              ),
              const SizedBox(height: 8.0),
              Text(
                context.l10n.settingsCloseAccountAreYouSure,
                style: TextTheme.of(context).bodyLarge,
              ),
              const SizedBox(height: 8.0),
              Text(
                context.l10n.settingsCantOpenSimilarAccount,
                style: ListTileTheme.of(context).subtitleTextStyle
                    ?.copyWith(fontSize: TextTheme.of(context).bodySmall?.fontSize),
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _usernameController,
                autocorrect: false,
                enableSuggestions: false,
                autofillHints: const [AutofillHints.username],
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: context.l10n.username,
                  border: _pillBorder(outline.withValues(alpha: 0.5)),
                  enabledBorder: _pillBorder(outline.withValues(alpha: 0.5)),
                  focusedBorder: _pillBorder(outline),
                  disabledBorder: _pillBorder(outline.withValues(alpha: 0.1)),
                  errorBorder: _pillBorder(error.withValues(alpha: 0.5)),
                  focusedErrorBorder: _pillBorder(error),
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
                textInputAction: _showTokenField ? TextInputAction.next : TextInputAction.done,
                decoration: InputDecoration(
                  labelText: context.l10n.password,
                  border: _pillBorder(outline.withValues(alpha: 0.5)),
                  enabledBorder: _pillBorder(outline.withValues(alpha: 0.5)),
                  focusedBorder: _pillBorder(outline),
                  disabledBorder: _pillBorder(outline.withValues(alpha: 0.1)),
                  errorBorder: _pillBorder(error.withValues(alpha: 0.5)),
                  focusedErrorBorder: _pillBorder(error),
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
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: context.l10n.tfaAuthenticationCode,
                    helperText: context.l10n.tfaOpenTwoFactorApp,
                    border: _pillBorder(outline.withValues(alpha: 0.5)),
                    enabledBorder: _pillBorder(outline.withValues(alpha: 0.5)),
                    focusedBorder: _pillBorder(outline),
                    disabledBorder: _pillBorder(outline.withValues(alpha: 0.1)),
                    errorBorder: _pillBorder(error.withValues(alpha: 0.5)),
                    focusedErrorBorder: _pillBorder(error),
                    errorText: _tokenError,
                  ),
                  onFieldSubmitted: (_) => _submit(),
                ),
              ],
              const SizedBox(height: 16.0),
              Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.hardEdge,
                child: CheckboxListTile(
                  value: _forever,
                  title: Text(
                    context.l10n.settingsCloseAccountForeverLabel,
                    style: TextTheme.of(context).bodyMedium,
                  ),
                  subtitle: Text(
                    context.l10n.settingsCloseAccountForeverWarning,
                    style: ListTileTheme.of(context).subtitleTextStyle
                        ?.copyWith(fontSize: TextTheme.of(context).bodySmall?.fontSize),
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
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: ColorScheme.of(context).error,
                  foregroundColor: ColorScheme.of(context).onError,
                ),
                onPressed: pending || !_canSubmit ? null : _submit,
                child: pending
                    ? const ButtonLoadingIndicator()
                    : Text(context.l10n.settingsCloseAccount),
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
      appBar: PlatformAppBar(title: Text(context.l10n.settingsCloseAccount)),
      body: body,
    );
  }
}
