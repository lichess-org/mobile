import 'dart:convert';
import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/db/secure_storage.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:logging/logging.dart';

part 'parental_pin.freezed.dart';
part 'parental_pin.g.dart';

const kParentalPinStorageKey = '$kLichessHost.parentalPin';

/// The number of digits of a parental PIN.
const kParentalPinLength = 4;

/// The number of wrong PINs allowed before the PIN is locked for a while.
const kParentalPinFreeAttempts = 5;

const _kFirstLockDuration = Duration(seconds: 30);
const _kMaxLockDuration = Duration(minutes: 15);

final _logger = Logger('ParentalPin');

/// The parental PIN as stored: a salted hash, and the count of wrong PINs entered.
///
/// The wrong attempts are stored with the hash so that restarting the app does not reset them.
@Freezed(fromJson: true, toJson: true)
sealed class const StoredParentalPin._() with _$StoredParentalPin {
  const factory({
    required String salt,
    required String hash,
    @Default(0) int failedAttempts,
    DateTime? lockedUntil,
  }) = _StoredParentalPin;

  factory fromJson(Map<String, dynamic> json) => _$StoredParentalPinFromJson(json);

  factory create(String pin) {
    final random = math.Random.secure();
    final salt = base64Encode([for (var i = 0; i < 16; i++) random.nextInt(256)]);
    return StoredParentalPin(salt: salt, hash: _hash(salt, pin));
  }

  bool matches(String pin) => _hash(salt, pin) == hash;

  static String _hash(String salt, String pin) =>
      sha256.convert(utf8.encode('$salt:$pin')).toString();
}

/// The result of [ParentalPinController.verify].
sealed class const ParentalPinCheck();

/// The PIN is correct.
class const ParentalPinCorrect() extends ParentalPinCheck;

/// The PIN is wrong. If [lockedUntil] is not null, no PIN is checked until then.
class const ParentalPinWrong({final DateTime? lockedUntil}) extends ParentalPinCheck;

/// Too many wrong PINs were entered: the PIN was not checked, and won't be until [lockedUntil].
class const ParentalPinLocked({required final DateTime lockedUntil}) extends ParentalPinCheck;

/// Whether a parental PIN is set on this device.
///
/// The PIN is opt-in: when it is set, it is asked before switching to another account or signing
/// out while the active account is in kid mode, so that a kid can't leave kid mode on their own.
/// Adding an account is not gated: it needs the credentials of that account.
final parentalPinProvider = AsyncNotifierProvider<ParentalPinController, bool>(
  ParentalPinController.new,
  name: 'ParentalPinProvider',
);

class ParentalPinController() extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    return await _read() != null;
  }

  /// Sets the parental PIN, replacing the current one if any.
  ///
  /// The caller must have checked the current PIN first, with [verify].
  Future<void> setPin(String pin) async {
    await _write(StoredParentalPin.create(pin));
    state = const AsyncData(true);
  }

  /// Removes the parental PIN.
  ///
  /// The caller must have checked the PIN first, with [verify].
  Future<void> removePin() async {
    await SecureStorage.instance.delete(key: kParentalPinStorageKey);
    state = const AsyncData(false);
  }

  /// Removes the parental PIN after signing out of every account on this device, for a parent who
  /// forgot it.
  ///
  /// It leaves a kid no better off than reinstalling the app, which also signs out of every account:
  /// to get back into an account, they need its credentials.
  Future<void> forgetPin() async {
    await ref.read(authControllerProvider.notifier).signOutOfAllAccounts();
    await removePin();
  }

  /// Checks [pin] against the parental PIN.
  ///
  /// After [kParentalPinFreeAttempts] wrong PINs, each wrong PIN locks the PIN for twice as long as
  /// the previous one, up to 15 minutes.
  Future<ParentalPinCheck> verify(String pin) async {
    final stored = await _read();
    if (stored == null) return const ParentalPinCorrect();

    final now = clock.now();
    if (stored.lockedUntil case final lockedUntil? when lockedUntil.isAfter(now)) {
      return ParentalPinLocked(lockedUntil: lockedUntil);
    }

    if (stored.matches(pin)) {
      if (stored.failedAttempts > 0 || stored.lockedUntil != null) {
        await _write(stored.copyWith(failedAttempts: 0, lockedUntil: null));
      }
      return const ParentalPinCorrect();
    }

    final failedAttempts = stored.failedAttempts + 1;
    // The number of times the PIN gets locked, the first one at the last allowed wrong PIN.
    final lockCount = failedAttempts - kParentalPinFreeAttempts + 1;
    final lockedUntil = lockCount > 0
        ? now.add(
            Duration(
              seconds: math.min(
                _kFirstLockDuration.inSeconds * math.pow(2, lockCount - 1).toInt(),
                _kMaxLockDuration.inSeconds,
              ),
            ),
          )
        : null;
    await _write(stored.copyWith(failedAttempts: failedAttempts, lockedUntil: lockedUntil));
    return ParentalPinWrong(lockedUntil: lockedUntil);
  }

  /// Whether the parental PIN must be entered before leaving the active account, by switching to
  /// another one or signing out.
  ///
  /// It is if a PIN is set and the active account is in kid mode. The kid mode is fetched again,
  /// since it may have been turned on or off on the website meanwhile, and assumed if the fetch
  /// fails.
  Future<bool> isRequiredToLeaveAccount() async {
    if (!await future) return false;
    if (ref.read(authControllerProvider) == null) return false;
    try {
      final account = await ref.read(accountRepositoryProvider).getProfile();
      return account.kid ?? false;
    } catch (e, st) {
      _logger.warning('Could not fetch the kid mode, assuming it is on:', e, st);
      return true;
    }
  }

  Future<StoredParentalPin?> _read() async {
    final string = await SecureStorage.instance.read(key: kParentalPinStorageKey);
    if (string == null) return null;
    try {
      return StoredParentalPin.fromJson(jsonDecode(string) as Map<String, dynamic>);
    } catch (e, st) {
      // Kept as a PIN that matches nothing: forgetting it would remove the protection. The parent
      // can still remove it with "Forgot PIN".
      _logger.severe('Could not read the parental PIN:', e, st);
      return const StoredParentalPin(salt: '', hash: '');
    }
  }

  Future<void> _write(StoredParentalPin pin) {
    return SecureStorage.instance.write(
      key: kParentalPinStorageKey,
      value: jsonEncode(pin.toJson()),
    );
  }
}
