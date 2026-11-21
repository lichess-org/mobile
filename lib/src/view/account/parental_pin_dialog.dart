import 'package:clock/clock.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/parental_pin.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';
import 'package:material_ui/material_ui.dart';

/// Asks for the parental PIN if it is required to leave the active account (see
/// [ParentalPinController.isRequiredToLeaveAccount]), before switching to another account or
/// signing out.
///
/// Returns whether the user may leave the active account.
Future<bool> confirmLeavingAccount(BuildContext context, WidgetRef ref) async {
  if (!await ref.read(parentalPinProvider.notifier).isRequiredToLeaveAccount()) return true;
  if (!context.mounted) return false;
  final confirmed = await showAdaptiveDialog<bool>(
    context: context,
    builder: (_) => const ParentalPinDialog(mode: .verify),
  );
  return confirmed ?? false;
}

enum ParentalPinDialogMode() {
  /// Asks for the current PIN, with a "Forgot PIN?" action.
  verify,

  /// Asks for a new PIN twice, then sets it.
  create,
}

/// A dialog that asks for the parental PIN, popped with `true` once the PIN is checked or set.
class const ParentalPinDialog({super.key, required final ParentalPinDialogMode mode})
    extends ConsumerStatefulWidget {
  @override
  ConsumerState<ParentalPinDialog> createState() => _ParentalPinDialogState();
}

class _ParentalPinDialogState() extends ConsumerState<ParentalPinDialog> {
  final _controller = TextEditingController();

  /// In [ParentalPinDialogMode.create], the PIN entered the first time, to be confirmed.
  String? _newPin;
  String? _error;
  bool _isChecking = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onChanged(String value) async {
    if (value.length < kParentalPinLength || _isChecking) return;

    switch (widget.mode) {
      case .create:
        if (_newPin == null) {
          setState(() {
            _newPin = value;
            _error = null;
          });
          _controller.clear();
        } else if (_newPin != value) {
          setState(() {
            _newPin = null;
            _error = 'The PINs do not match, please try again.';
          });
          _controller.clear();
        } else {
          setState(() => _isChecking = true);
          await ref.read(parentalPinProvider.notifier).setPin(value);
          if (mounted) Navigator.of(context).pop(true);
        }
      case .verify:
        setState(() => _isChecking = true);
        final check = await ref.read(parentalPinProvider.notifier).verify(value);
        if (!mounted) return;
        if (check is ParentalPinCorrect) {
          Navigator.of(context).pop(true);
          return;
        }
        setState(() {
          _isChecking = false;
          _error = switch (check) {
            ParentalPinWrong(lockedUntil: final lockedUntil?) ||
            ParentalPinLocked(:final lockedUntil) => _lockedMessage(lockedUntil),
            _ => 'Wrong PIN.',
          };
        });
        _controller.clear();
    }
  }

  String _lockedMessage(DateTime lockedUntil) {
    final remaining = lockedUntil.difference(clock.now());
    final wait = remaining.inSeconds < 60
        ? '${remaining.inSeconds + 1} seconds'
        : '${(remaining.inSeconds / 60).ceil()} minutes';
    return 'Too many wrong PINs. Try again in $wait.';
  }

  Future<void> _forgotPin() async {
    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => YesNoDialog(
        title: const Text('Forgot PIN?'),
        content: const Text(
          'This signs you out of every account on this device and removes the PIN. You can then '
          'sign in again and set a new PIN.',
        ),
        onYes: () => Navigator.of(context).pop(true),
        onNo: () => Navigator.of(context).pop(false),
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _isChecking = true);
    await ref.read(parentalPinProvider.notifier).forgetPin();
    if (mounted) Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final title = switch (widget.mode) {
      .verify => 'Enter the parental PIN',
      .create => _newPin == null ? 'Choose a parental PIN' : 'Confirm the parental PIN',
    };

    return PlatformAlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12.0,
        children: [
          if (widget.mode == .create && _newPin == null)
            const Text(
              'It is asked before switching account or signing out while in kid mode. Choose a PIN '
              'your kid does not know.',
            ),
          Material(
            type: MaterialType.transparency,
            child: TextField(
              controller: _controller,
              autofocus: true,
              enabled: !_isChecking,
              obscureText: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: kParentalPinLength,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(fontSize: 24, letterSpacing: 16),
              decoration: InputDecoration(counterText: '', errorText: _error, errorMaxLines: 3),
              onChanged: _onChanged,
            ),
          ),
        ],
      ),
      actions: [
        if (widget.mode == .verify)
          PlatformDialogAction(
            onPressed: _isChecking ? null : _forgotPin,
            child: const Text('Forgot PIN?'),
          ),
        PlatformDialogAction(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.l10n.cancel),
        ),
      ],
    );
  }
}
