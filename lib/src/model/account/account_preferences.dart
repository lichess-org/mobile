import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';

part 'account_preferences.freezed.dart';
part 'account_preferences.g.dart';

@Freezed(fromJson: true, toJson: true)
sealed class AccountPrefState with _$AccountPrefState implements Serializable {
  const AccountPrefState._();

  const factory AccountPrefState({
    // game display
    @JsonKey(name: 'zen', fromJson: _zenFromJson, toJson: _zenToJson) required Zen zenMode,
    @JsonKey(fromJson: _pieceNotationFromJson, toJson: _pieceNotationToJson)
    required PieceNotation pieceNotation,
    @JsonKey(name: 'ratings', fromJson: _showRatingsFromJson, toJson: _showRatingsToJson)
    required ShowRatings showRatings,
    // game behavior
    @JsonKey(fromJson: _premoveFromJson, toJson: _booleanPrefToJson) required BooleanPref premove,
    @JsonKey(fromJson: _autoQueenFromJson, toJson: _autoQueenToJson) required AutoQueen autoQueen,
    @JsonKey(fromJson: _autoThreefoldFromJson, toJson: _autoThreefoldToJson)
    required AutoThreefold autoThreefold,
    @JsonKey(fromJson: _takebackFromJson, toJson: _takebackToJson) required Takeback takeback,
    @JsonKey(fromJson: _confirmResignFromJson, toJson: _booleanPrefToJson)
    required BooleanPref confirmResign,
    @JsonKey(fromJson: _submitMoveFromJson, toJson: _submitMoveToJson)
    required SubmitMove submitMove,
    // clock
    @JsonKey(fromJson: _moretimeFromJson, toJson: _moretimeToJson) required Moretime moretime,
    @JsonKey(fromJson: _clockTenthsFromJson, toJson: _clockTenthsToJson)
    required ClockTenths clockTenths,
    @JsonKey(fromJson: _clockSoundFromJson, toJson: _booleanPrefToJson)
    required BooleanPref clockSound,
    // privacy
    @JsonKey(fromJson: _followFromJson, toJson: _booleanPrefToJson) required BooleanPref follow,
    @JsonKey(fromJson: _challengeFromJson, toJson: _challengeToJson) required Challenge challenge,
    @JsonKey(fromJson: _messageFromJson, toJson: _messageToJson) required Message message,
  }) = _AccountPrefState;

  factory AccountPrefState.fromJson(Map<String, dynamic> json) {
    try {
      return _$AccountPrefStateFromJson(json);
    } catch (_) {
      return defaultAccountPreferences;
    }
  }
}

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

final defaultAccountPreferences = AccountPrefState(
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
final accountPreferencesProvider = AsyncNotifierProvider<AccountPreferences, AccountPrefState>(
  AccountPreferences.new,
  name: 'AccountPreferencesProvider',
);

/// Get the account preferences for the current user.
///
/// The result is cached for the lifetime of the app, until refreshed.
/// If the server returns an error, default values are returned.
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

Zen _zenFromJson(Object? value) =>
    Zen.fromInt(_intValue(value, defaultAccountPreferences.zenMode.value));

int _zenToJson(Zen value) => value.value;

PieceNotation _pieceNotationFromJson(Object? value) =>
    PieceNotation.fromInt(_intValue(value, defaultAccountPreferences.pieceNotation.value));

int _pieceNotationToJson(PieceNotation value) => value.value;

ShowRatings _showRatingsFromJson(Object? value) =>
    ShowRatings.fromInt(_intValue(value, defaultAccountPreferences.showRatings.value));

int _showRatingsToJson(ShowRatings value) => value.value;

BooleanPref _premoveFromJson(Object? value) =>
    BooleanPref(_boolValue(value, defaultAccountPreferences.premove.value));

AutoQueen _autoQueenFromJson(Object? value) =>
    AutoQueen.fromInt(_intValue(value, defaultAccountPreferences.autoQueen.value));

int _autoQueenToJson(AutoQueen value) => value.value;

AutoThreefold _autoThreefoldFromJson(Object? value) =>
    AutoThreefold.fromInt(_intValue(value, defaultAccountPreferences.autoThreefold.value));

int _autoThreefoldToJson(AutoThreefold value) => value.value;

Takeback _takebackFromJson(Object? value) =>
    Takeback.fromInt(_intValue(value, defaultAccountPreferences.takeback.value));

int _takebackToJson(Takeback value) => value.value;

BooleanPref _confirmResignFromJson(Object? value) =>
    BooleanPref(_boolValue(value, defaultAccountPreferences.confirmResign.value));

SubmitMove _submitMoveFromJson(Object? value) =>
    SubmitMove.fromInt(_intValue(value, defaultAccountPreferences.submitMove.value));

int _submitMoveToJson(SubmitMove value) => value.value;

Moretime _moretimeFromJson(Object? value) =>
    Moretime.fromInt(_intValue(value, defaultAccountPreferences.moretime.value));

int _moretimeToJson(Moretime value) => value.value;

ClockTenths _clockTenthsFromJson(Object? value) =>
    ClockTenths.fromInt(_intValue(value, defaultAccountPreferences.clockTenths.value));

int _clockTenthsToJson(ClockTenths value) => value.value;

BooleanPref _clockSoundFromJson(Object? value) =>
    BooleanPref(_boolValue(value, defaultAccountPreferences.clockSound.value));

BooleanPref _followFromJson(Object? value) =>
    BooleanPref(_boolValue(value, defaultAccountPreferences.follow.value));

Challenge _challengeFromJson(Object? value) =>
    Challenge.fromInt(_intValue(value, defaultAccountPreferences.challenge.value));

int _challengeToJson(Challenge value) => value.value;

Message _messageFromJson(Object? value) =>
    Message.fromInt(_intValue(value, defaultAccountPreferences.message.value));

int _messageToJson(Message value) => value.value;

bool _booleanPrefToJson(BooleanPref value) => value.value;

int _intValue(Object? value, int fallback) {
  return value is num ? value.toInt() : fallback;
}

bool _boolValue(Object? value, bool fallback) {
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
