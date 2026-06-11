import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';

typedef AccountPrefState = ({
  // game display
  Zen zenMode,
  PieceNotation pieceNotation,
  ShowRatings showRatings,
  // game behavior
  BooleanPref premove,
  AutoQueen autoQueen,
  AutoThreefold autoThreefold,
  Takeback takeback,
  BooleanPref confirmResign,
  SubmitMove submitMove,
  // clock
  Moretime moretime,
  ClockTenths clockTenths,
  BooleanPref clockSound,
  // privacy
  BooleanPref follow,
  Challenge challenge,
  Message message,
});

/// A provider that tells if the user wants to see ratings in the app.
final showRatingsPrefProvider = FutureProvider<ShowRatings>((Ref ref) async {
  final prefs = await ref.watch(effectiveAccountPreferencesProvider.future);
  return prefs.showRatings;
});

/// A provider that tells if the user wants clock sounds.
final clockSoundProvider = FutureProvider<bool>((Ref ref) async {
  final prefs = await ref.watch(effectiveAccountPreferencesProvider.future);
  return prefs.clockSound.value;
});

/// A provider that gives the user's preferred piece notation.
final pieceNotationProvider = FutureProvider<PieceNotation>((Ref ref) async {
  final prefs = await ref.watch(effectiveAccountPreferencesProvider.future);
  return prefs.pieceNotation;
});

/// A provider that gives the user's preferred clock tenths display.
final clockTenthsProvider = FutureProvider<ClockTenths>((Ref ref) async {
  final prefs = await ref.watch(effectiveAccountPreferencesProvider.future);
  return prefs.clockTenths;
});

final defaultAccountPreferences = (
  zenMode: Zen.no,
  pieceNotation: PieceNotation.symbol,
  showRatings: ShowRatings.yes,
  premove: const BooleanPref(true),
  autoQueen: AutoQueen.premove,
  autoThreefold: AutoThreefold.always,
  takeback: Takeback.always,
  moretime: Moretime.always,
  clockTenths: ClockTenths.lessThan10s,
  clockSound: const BooleanPref(true),
  confirmResign: const BooleanPref(true),
  submitMove: SubmitMove({SubmitMoveChoice.correspondence}),
  follow: const BooleanPref(true),
  challenge: Challenge.registered,
  message: Message.always,
);

/// A provider that gives the account preferences for the current user.
final accountPreferencesProvider = AsyncNotifierProvider<AccountPreferences, AccountPrefState?>(
  AccountPreferences.new,
  name: 'AccountPreferencesProvider',
);

/// Local account-style preferences used when the user is signed out.
final localAccountPreferencesProvider = NotifierProvider<LocalAccountPreferences, AccountPrefState>(
  LocalAccountPreferences.new,
  name: 'LocalAccountPreferencesProvider',
);

/// Account-style preferences with server values taking precedence when signed in.
final effectiveAccountPreferencesProvider = FutureProvider<AccountPrefState>((Ref ref) async {
  final localPrefs = ref.watch(localAccountPreferencesProvider);
  final authUser = ref.watch(authControllerProvider);
  if (authUser == null) {
    return localPrefs;
  }

  final serverPrefs = await ref.watch(accountPreferencesProvider.selectAsync((prefs) => prefs));
  return serverPrefs ?? localPrefs;
});

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
      return await ref.read(accountRepositoryProvider).getPreferences();
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

class LocalAccountPreferences extends Notifier<AccountPrefState> {
  @override
  AccountPrefState build() {
    return _fetch();
  }

  Future<void> setZen(Zen value) => _save(_copyWith(zenMode: value));
  Future<void> setPieceNotation(PieceNotation value) => _save(_copyWith(pieceNotation: value));
  Future<void> setShowRatings(ShowRatings value) => _save(_copyWith(showRatings: value));

  Future<void> setPremove(BooleanPref value) => _save(_copyWith(premove: value));
  Future<void> setTakeback(Takeback value) => _save(_copyWith(takeback: value));
  Future<void> setAutoQueen(AutoQueen value) => _save(_copyWith(autoQueen: value));
  Future<void> setAutoThreefold(AutoThreefold value) => _save(_copyWith(autoThreefold: value));
  Future<void> setMoretime(Moretime value) => _save(_copyWith(moretime: value));
  Future<void> setClockTenths(ClockTenths value) => _save(_copyWith(clockTenths: value));
  Future<void> setClockSound(BooleanPref value) => _save(_copyWith(clockSound: value));
  Future<void> setConfirmResign(BooleanPref value) => _save(_copyWith(confirmResign: value));
  Future<void> setSubmitMove(SubmitMove value) => _save(_copyWith(submitMove: value));

  Future<void> _save(AccountPrefState value) async {
    await LichessBinding.instance.sharedPreferences.setString(
      PrefCategory.account.storageKey,
      jsonEncode(_accountPreferencesToJson(value)),
    );
    state = value;
  }

  AccountPrefState _fetch() {
    final stored = LichessBinding.instance.sharedPreferences.getString(
      PrefCategory.account.storageKey,
    );
    if (stored == null) {
      return defaultAccountPreferences;
    }
    try {
      return _localAccountPreferencesFromJson(jsonDecode(stored) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('[LocalAccountPreferences] Error reading local account preferences: $e');
      return defaultAccountPreferences;
    }
  }

  AccountPrefState _copyWith({
    Zen? zenMode,
    PieceNotation? pieceNotation,
    ShowRatings? showRatings,
    BooleanPref? premove,
    AutoQueen? autoQueen,
    AutoThreefold? autoThreefold,
    Takeback? takeback,
    BooleanPref? confirmResign,
    SubmitMove? submitMove,
    Moretime? moretime,
    ClockTenths? clockTenths,
    BooleanPref? clockSound,
  }) {
    return (
      zenMode: zenMode ?? state.zenMode,
      pieceNotation: pieceNotation ?? state.pieceNotation,
      showRatings: showRatings ?? state.showRatings,
      premove: premove ?? state.premove,
      autoQueen: autoQueen ?? state.autoQueen,
      autoThreefold: autoThreefold ?? state.autoThreefold,
      takeback: takeback ?? state.takeback,
      moretime: moretime ?? state.moretime,
      clockTenths: clockTenths ?? state.clockTenths,
      clockSound: clockSound ?? state.clockSound,
      confirmResign: confirmResign ?? state.confirmResign,
      submitMove: submitMove ?? state.submitMove,
      follow: state.follow,
      challenge: state.challenge,
      message: state.message,
    );
  }
}

Map<String, dynamic> _accountPreferencesToJson(AccountPrefState prefs) {
  return {
    'zen': prefs.zenMode.value,
    'pieceNotation': prefs.pieceNotation.value,
    'ratings': prefs.showRatings.value,
    'premove': prefs.premove.value,
    'autoQueen': prefs.autoQueen.value,
    'autoThreefold': prefs.autoThreefold.value,
    'takeback': prefs.takeback.value,
    'moretime': prefs.moretime.value,
    'clockTenths': prefs.clockTenths.value,
    'clockSound': prefs.clockSound.value,
    'confirmResign': prefs.confirmResign.value,
    'submitMove': prefs.submitMove.value,
  };
}

AccountPrefState _localAccountPreferencesFromJson(Map<String, dynamic> json) {
  return (
    zenMode: Zen.fromInt(_intValue(json, 'zen', defaultAccountPreferences.zenMode.value)),
    pieceNotation: PieceNotation.fromInt(
      _intValue(json, 'pieceNotation', defaultAccountPreferences.pieceNotation.value),
    ),
    showRatings: ShowRatings.fromInt(
      _intValue(json, 'ratings', defaultAccountPreferences.showRatings.value),
    ),
    premove: BooleanPref(_boolValue(json, 'premove', defaultAccountPreferences.premove.value)),
    autoQueen: AutoQueen.fromInt(
      _intValue(json, 'autoQueen', defaultAccountPreferences.autoQueen.value),
    ),
    autoThreefold: AutoThreefold.fromInt(
      _intValue(json, 'autoThreefold', defaultAccountPreferences.autoThreefold.value),
    ),
    takeback: Takeback.fromInt(
      _intValue(json, 'takeback', defaultAccountPreferences.takeback.value),
    ),
    moretime: Moretime.fromInt(
      _intValue(json, 'moretime', defaultAccountPreferences.moretime.value),
    ),
    clockTenths: ClockTenths.fromInt(
      _intValue(json, 'clockTenths', defaultAccountPreferences.clockTenths.value),
    ),
    clockSound: BooleanPref(
      _boolValue(json, 'clockSound', defaultAccountPreferences.clockSound.value),
    ),
    confirmResign: BooleanPref(
      _boolValue(json, 'confirmResign', defaultAccountPreferences.confirmResign.value),
    ),
    submitMove: SubmitMove.fromInt(
      _intValue(json, 'submitMove', defaultAccountPreferences.submitMove.value),
    ),
    follow: defaultAccountPreferences.follow,
    challenge: defaultAccountPreferences.challenge,
    message: defaultAccountPreferences.message,
  );
}

int _intValue(Map<String, dynamic> json, String key, int fallback) {
  final value = json[key];
  return value is num ? value.toInt() : fallback;
}

bool _boolValue(Map<String, dynamic> json, String key, bool fallback) {
  final value = json[key];
  return switch (value) {
    final bool b => b,
    final num n => n != 0,
    _ => fallback,
  };
}

abstract class AccountPref<T> {
  T get value;
  String get toFormData;
}

class BooleanPref implements AccountPref<bool> {
  const BooleanPref(this.value);

  @override
  final bool value;

  @override
  String get toFormData => value ? '1' : '0';

  static BooleanPref fromInt(int value) {
    switch (value) {
      case 1:
        return const BooleanPref(true);
      case 0:
        return const BooleanPref(false);
      default:
        throw Exception('Invalid value for BooleanPref');
    }
  }
}

enum Zen implements AccountPref<int> {
  no(0),
  yes(1),
  gameAuto(2);

  const Zen(this.value);

  @override
  final int value;

  @override
  String get toFormData => value.toString();

  String label(AppLocalizations l10n) {
    switch (this) {
      case Zen.no:
        return l10n.no;
      case Zen.yes:
        return l10n.yes;
      case Zen.gameAuto:
        return l10n.preferencesInGameOnly;
    }
  }

  static Zen fromInt(int value) {
    switch (value) {
      case 0:
        return Zen.no;
      case 1:
        return Zen.yes;
      case 2:
        return Zen.gameAuto;
      default:
        throw Exception('Invalid value for Zen');
    }
  }
}

enum ShowRatings implements AccountPref<int> {
  no(0),
  yes(1),
  exceptInGame(2);

  const ShowRatings(this.value);

  @override
  final int value;

  @override
  String get toFormData => value.toString();

  String label(AppLocalizations l10n) {
    switch (this) {
      case ShowRatings.no:
        return l10n.no;
      case ShowRatings.yes:
        return l10n.yes;
      case ShowRatings.exceptInGame:
        return l10n.preferencesExceptInGame;
    }
  }

  static ShowRatings fromInt(int value) {
    switch (value) {
      case 0:
        return ShowRatings.no;
      case 1:
        return ShowRatings.yes;
      case 2:
        return ShowRatings.exceptInGame;
      default:
        throw Exception('Invalid value for ShowRatings');
    }
  }
}

enum PieceNotation implements AccountPref<int> {
  symbol(0),
  letter(1);

  const PieceNotation(this.value);

  @override
  final int value;

  @override
  String get toFormData => value.toString();

  String label(AppLocalizations l10n) {
    switch (this) {
      case PieceNotation.symbol:
        return l10n.preferencesChessPieceSymbol;
      case PieceNotation.letter:
        return l10n.preferencesPgnLetter;
    }
  }

  static PieceNotation fromInt(int value) {
    switch (value) {
      case 0:
        return PieceNotation.symbol;
      case 1:
        return PieceNotation.letter;
      default:
        throw Exception('Invalid value for PieceNotation');
    }
  }
}

enum AutoQueen implements AccountPref<int> {
  never(1),
  premove(2),
  always(3);

  const AutoQueen(this.value);

  @override
  final int value;

  @override
  String get toFormData => value.toString();

  String label(AppLocalizations l10n) {
    switch (this) {
      case AutoQueen.never:
        return l10n.never;
      case AutoQueen.premove:
        return l10n.preferencesWhenPremoving;
      case AutoQueen.always:
        return l10n.always;
    }
  }

  static AutoQueen fromInt(int value) {
    switch (value) {
      case 1:
        return AutoQueen.never;
      case 2:
        return AutoQueen.premove;
      case 3:
        return AutoQueen.always;
      default:
        throw Exception('Invalid value for AutoQueen');
    }
  }
}

enum AutoThreefold implements AccountPref<int> {
  never(1),
  time(2),
  always(3);

  const AutoThreefold(this.value);

  @override
  final int value;

  @override
  String get toFormData => value.toString();

  String label(AppLocalizations l10n) {
    switch (this) {
      case AutoThreefold.never:
        return l10n.never;
      case AutoThreefold.time:
        return l10n.preferencesWhenTimeRemainingLessThanThirtySeconds;
      case AutoThreefold.always:
        return l10n.always;
    }
  }

  static AutoThreefold fromInt(int value) {
    switch (value) {
      case 1:
        return AutoThreefold.never;
      case 2:
        return AutoThreefold.time;
      case 3:
        return AutoThreefold.always;
      default:
        throw Exception('Invalid value for AutoThreefold');
    }
  }
}

enum Takeback implements AccountPref<int> {
  never(1),
  casual(2),
  always(3);

  const Takeback(this.value);

  @override
  final int value;

  @override
  String get toFormData => value.toString();

  String label(AppLocalizations l10n) {
    switch (this) {
      case Takeback.never:
        return l10n.never;
      case Takeback.casual:
        return l10n.preferencesInCasualGamesOnly;
      case Takeback.always:
        return l10n.always;
    }
  }

  static Takeback fromInt(int value) {
    switch (value) {
      case 1:
        return Takeback.never;
      case 2:
        return Takeback.casual;
      case 3:
        return Takeback.always;
      default:
        throw Exception('Invalid value for Takeback');
    }
  }
}

enum Moretime implements AccountPref<int> {
  never(1),
  casual(2),
  always(3);

  const Moretime(this.value);

  @override
  final int value;

  @override
  String get toFormData => value.toString();

  String label(AppLocalizations l10n) {
    switch (this) {
      case Moretime.never:
        return l10n.never;
      case Moretime.casual:
        return l10n.preferencesInCasualGamesOnly;
      case Moretime.always:
        return l10n.always;
    }
  }

  static Moretime fromInt(int value) {
    switch (value) {
      case 1:
        return Moretime.never;
      case 2:
        return Moretime.casual;
      case 3:
        return Moretime.always;
      default:
        throw Exception('Invalid value for Moretime');
    }
  }
}

enum ClockTenths implements AccountPref<int> {
  never(0),
  lessThan10s(1),
  always(2);

  const ClockTenths(this.value);

  @override
  final int value;

  @override
  String get toFormData => value.toString();

  String label(AppLocalizations l10n) {
    switch (this) {
      case ClockTenths.never:
        return l10n.never;
      case ClockTenths.lessThan10s:
        return l10n.preferencesWhenTimeRemainingLessThanTenSeconds;
      case ClockTenths.always:
        return l10n.always;
    }
  }

  static ClockTenths fromInt(int value) {
    switch (value) {
      case 0:
        return ClockTenths.never;
      case 1:
        return ClockTenths.lessThan10s;
      case 2:
        return ClockTenths.always;
      default:
        throw Exception('Invalid value for ClockTenths: $value');
    }
  }
}

enum Challenge implements AccountPref<int> {
  never(1),
  rating(2),
  friends(3),
  registered(4),
  always(5);

  const Challenge(this.value);

  @override
  final int value;

  @override
  String get toFormData => value.toString();

  String label(AppLocalizations l10n) {
    switch (this) {
      case Challenge.never:
        return l10n.never;
      case Challenge.rating:
        return l10n.ifRatingIsPlusMinusX('300');
      case Challenge.friends:
        return l10n.onlyFriends;
      case Challenge.registered:
        return l10n.ifRegistered;
      case Challenge.always:
        return l10n.always;
    }
  }

  static Challenge fromInt(int value) {
    switch (value) {
      case 1:
        return Challenge.never;
      case 2:
        return Challenge.rating;
      case 3:
        return Challenge.friends;
      case 4:
        return Challenge.registered;
      case 5:
        return Challenge.always;
      default:
        throw Exception('Invalid value for Challenge');
    }
  }
}

enum Message implements AccountPref<int> {
  never(1),
  friends(2),
  always(3);

  const Message(this.value);

  @override
  final int value;

  @override
  String get toFormData => value.toString();

  String label(AppLocalizations l10n) {
    switch (this) {
      case Message.never:
        return l10n.onlyExistingConversations;
      case Message.friends:
        return l10n.onlyFriends;
      case Message.always:
        return l10n.always;
    }
  }

  static Message fromInt(int value) {
    switch (value) {
      case 1:
        return Message.never;
      case 2:
        return Message.friends;
      case 3:
        return Message.always;
      default:
        throw Exception('Invalid value for Message');
    }
  }
}

class SubmitMove implements AccountPref<int> {
  SubmitMove(Iterable<SubmitMoveChoice> choices) : choices = ISet(choices.toSet());

  final ISet<SubmitMoveChoice> choices;

  @override
  int get value => choices.fold(0, (acc, choice) => acc | choice.value);

  @override
  String get toFormData => value.toString();

  String label(AppLocalizations l10n) {
    if (choices.isEmpty) {
      return l10n.never;
    }

    return choices.map((choice) => choice.label(l10n)).join(', ');
  }

  factory SubmitMove.fromInt(int value) =>
      SubmitMove(SubmitMoveChoice.values.where((choice) => _bitPresent(value, choice.value)));
}

enum SubmitMoveChoice {
  unlimited(1),
  correspondence(2),
  classical(4),
  rapid(8),
  blitz(16);

  const SubmitMoveChoice(this.value);

  final int value;

  String label(AppLocalizations l10n) {
    switch (this) {
      case SubmitMoveChoice.unlimited:
        return l10n.unlimited;
      case SubmitMoveChoice.correspondence:
        return l10n.correspondence;
      case SubmitMoveChoice.classical:
        return l10n.classical;
      case SubmitMoveChoice.rapid:
        return l10n.rapid;
      case SubmitMoveChoice.blitz:
        return l10n.blitz;
    }
  }

  static SubmitMoveChoice fromInt(int value) {
    switch (value) {
      case 1:
        return SubmitMoveChoice.unlimited;
      case 2:
        return SubmitMoveChoice.correspondence;
      case 4:
        return SubmitMoveChoice.classical;
      case 8:
        return SubmitMoveChoice.rapid;
      case 16:
        return SubmitMoveChoice.blitz;
      default:
        throw Exception('Invalid value for SubmitMoveChoice');
    }
  }
}

bool _bitPresent(int anInt, int bit) => (anInt & bit) == bit;
