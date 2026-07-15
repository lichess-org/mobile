import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/account/account_pref_types.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';

export 'account_pref_types.dart';

/// Represents the account preferences for a user.
///
/// If the user is authenticated, the preferences are fetched from the server. If the user is not authenticated, the preferences are fetched from local storage.
/// Technically an anonymous user does not have account preferences, but we still store them locally for convenience, because some settings are useful even for anonymous users (e.g. piece notation, premoves, etc.).

/// A provider that tells if the user wants to see ratings in the app.
final showRatingsPrefProvider = FutureProvider<ShowRatings>((Ref ref) async {
  final prefs = await ref.watch(accountPreferencesProvider.future);
  return prefs.showRatings;
});

/// A provider that tells if the user wants clock sounds.
final clockSoundProvider = FutureProvider<bool>((Ref ref) async {
  final prefs = await ref.watch(accountPreferencesProvider.future);
  return prefs.clockSound.value;
});

/// A provider that gives the user's preferred piece notation.
final pieceNotationProvider = FutureProvider<PieceNotation>((Ref ref) async {
  final prefs = await ref.watch(accountPreferencesProvider.future);
  return prefs.pieceNotation;
});

/// A provider that gives the user's preferred clock tenths display.
final clockTenthsProvider = FutureProvider<ClockTenths>((Ref ref) async {
  final prefs = await ref.watch(accountPreferencesProvider.future);
  return prefs.clockTenths;
});

/// A provider that gives the account preferences for the current user.
final accountPreferencesProvider = AsyncNotifierProvider<AccountPreferences, AccountPrefState>(
  AccountPreferences.new,
  name: 'AccountPreferencesProvider',
);

/// Get the account preferences for the current user.
///
/// The result is cached for the lifetime of the app, until refreshed.
/// If the server returns an error, default values are returned.
///
/// If the user is authenticated, the preferences are fetched from the server. If the user is not authenticated, the preferences are fetched from local storage.
/// See also [AccountPrefState] for more details.
class AccountPreferences extends AsyncNotifier<AccountPrefState> {
  @override
  Future<AccountPrefState> build() async {
    final authUser = ref.watch(authControllerProvider);

    if (authUser == null) {
      return _fetchLocal();
    }

    try {
      return await ref.read(accountRepositoryProvider).getPreferences();
    } catch (e) {
      debugPrint('[AccountPreferences] Error getting account preferences: $e');
      return defaultAccountPreferences;
    }
  }

  Future<void> setZen(Zen value) =>
      _setPref('zen', value, (prefs) => prefs.copyWith(zenMode: value));
  Future<void> setPieceNotation(PieceNotation value) =>
      _setPref('pieceNotation', value, (prefs) => prefs.copyWith(pieceNotation: value));
  Future<void> setShowRatings(ShowRatings value) =>
      _setPref('ratings', value, (prefs) => prefs.copyWith(showRatings: value));

  Future<void> setPremove(BooleanPref value) =>
      _setPref('premove', value, (prefs) => prefs.copyWith(premove: value));
  Future<void> setTakeback(Takeback value) =>
      _setPref('takeback', value, (prefs) => prefs.copyWith(takeback: value));
  Future<void> setAutoQueen(AutoQueen value) =>
      _setPref('autoQueen', value, (prefs) => prefs.copyWith(autoQueen: value));
  Future<void> setAutoThreefold(AutoThreefold value) =>
      _setPref('autoThreefold', value, (prefs) => prefs.copyWith(autoThreefold: value));
  Future<void> setMoretime(Moretime value) =>
      _setPref('moretime', value, (prefs) => prefs.copyWith(moretime: value));
  Future<void> setClockTenths(ClockTenths value) =>
      _setPref('clockTenths', value, (prefs) => prefs.copyWith(clockTenths: value));
  Future<void> setClockSound(BooleanPref value) =>
      _setPref('clockSound', value, (prefs) => prefs.copyWith(clockSound: value));
  Future<void> setConfirmResign(BooleanPref value) =>
      _setPref('confirmResign', value, (prefs) => prefs.copyWith(confirmResign: value));
  Future<void> setSubmitMove(SubmitMove value) =>
      _setPref('submitMove', value, (prefs) => prefs.copyWith(submitMove: value));
  Future<void> setFollow(BooleanPref value) =>
      _setPref('follow', value, (prefs) => prefs.copyWith(follow: value));
  Future<void> setChallenge(Challenge value) =>
      _setPref('challenge', value, (prefs) => prefs.copyWith(challenge: value));
  Future<void> setMessage(Message value) =>
      _setPref('message', value, (prefs) => prefs.copyWith(message: value));

  Future<void> _setPref<T>(
    String key,
    AccountPref<T> value,
    AccountPrefState Function(AccountPrefState prefs) updateLocal,
  ) async {
    final authUser = ref.read(authControllerProvider);
    if (authUser == null) {
      await _saveLocal(updateLocal(state.value ?? _fetchLocal()));
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 200));
    await ref.read(accountRepositoryProvider).setPreference(key, value);
    ref.invalidateSelf();
  }

  Future<void> _saveLocal(AccountPrefState value) async {
    await LichessBinding.instance.sharedPreferences.setString(
      PrefCategory.account.storageKey,
      jsonEncode(value.toJson()),
    );

    if (!ref.mounted) return;

    state = AsyncValue.data(value);
  }

  AccountPrefState _fetchLocal() {
    final stored = LichessBinding.instance.sharedPreferences.getString(
      PrefCategory.account.storageKey,
    );
    if (stored == null) {
      return defaultAccountPreferences;
    }
    try {
      return AccountPrefState.fromJson(jsonDecode(stored) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('[AccountPreferences] Error reading local account preferences: $e');
      return defaultAccountPreferences;
    }
  }
}
