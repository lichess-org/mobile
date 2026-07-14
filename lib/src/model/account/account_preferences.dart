import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_pref_types.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';

export 'account_pref_types.dart';

/// A provider that tells if the user wants to see ratings in the app.
final showRatingsPrefProvider = FutureProvider<ShowRatings>((Ref ref) async {
  final prefs = await ref.watch(accountPreferencesProvider.future);
  return prefs?.showRatings ?? defaultAccountPreferences.showRatings;
});

/// A provider that tells if the user wants clock sounds.
final clockSoundProvider = FutureProvider<bool>((Ref ref) async {
  final prefs = await ref.watch(accountPreferencesProvider.future);
  return prefs?.clockSound.value ?? defaultAccountPreferences.clockSound.value;
});

/// A provider that gives the user's preferred piece notation.
final pieceNotationProvider = FutureProvider<PieceNotation>((Ref ref) async {
  final prefs = await ref.watch(accountPreferencesProvider.future);
  return prefs?.pieceNotation ?? defaultAccountPreferences.pieceNotation;
});

/// A provider that gives the account preferences for the current user.
final accountPreferencesProvider = AsyncNotifierProvider<AccountPreferences, AccountPrefState?>(
  AccountPreferences.new,
  name: 'AccountPreferencesProvider',
);

/// Get the account preferences for the current user.
///
/// The result is cached for the lifetime of the app, until refreshed.
/// If the server returns an error, default values are returned.
class AccountPreferences extends AsyncNotifier<AccountPrefState?> {
  @override
  Future<AccountPrefState?> build() async {
    final authUser = ref.watch(authControllerProvider);

    if (authUser == null) {
      return null;
    }

    try {
      return ref.read(accountRepositoryProvider).getPreferences();
    } catch (e) {
      debugPrint('[AccountPreferences] Error getting account preferences: $e');
      return defaultAccountPreferences;
    }
  }

  Future<void> setZen(Zen value) => _setPref('zen', value);
  Future<void> setPieceNotation(PieceNotation value) => _setPref('pieceNotation', value);
  Future<void> setShowRatings(ShowRatings value) => _setPref('ratings', value);

  Future<void> setPremove(BooleanPref value) => _setPref('premove', value);
  Future<void> setTakeback(Takeback value) => _setPref('takeback', value);
  Future<void> setAutoQueen(AutoQueen value) => _setPref('autoQueen', value);
  Future<void> setAutoThreefold(AutoThreefold value) => _setPref('autoThreefold', value);
  Future<void> setMoretime(Moretime value) => _setPref('moretime', value);
  Future<void> setClockTenths(ClockTenths value) => _setPref('clockTenths', value);
  Future<void> setClockSound(BooleanPref value) => _setPref('clockSound', value);
  Future<void> setConfirmResign(BooleanPref value) => _setPref('confirmResign', value);
  Future<void> setSubmitMove(SubmitMove value) => _setPref('submitMove', value);
  Future<void> setFollow(BooleanPref value) => _setPref('follow', value);
  Future<void> setChallenge(Challenge value) => _setPref('challenge', value);
  Future<void> setMessage(Message value) => _setPref('message', value);

  Future<void> _setPref<T>(String key, AccountPref<T> value) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await ref.read(accountRepositoryProvider).setPreference(key, value);
    ref.invalidateSelf();
  }
}
