import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';

part 'account_pref_types.freezed.dart';
part 'account_pref_types.g.dart';

@Freezed(fromJson: true, toJson: true)
sealed class AccountPrefState with _$AccountPrefState implements Serializable {
  const AccountPrefState._();

  const factory AccountPrefState({
    // game display
    @JsonKey(unknownEnumValue: Zen.no) required Zen zenMode,
    @JsonKey(unknownEnumValue: PieceNotation.symbol) required PieceNotation pieceNotation,
    @JsonKey(unknownEnumValue: ShowRatings.yes) required ShowRatings showRatings,
    // game behavior
    @JsonKey(fromJson: _booleanPrefFromJson, toJson: _booleanPrefToJson)
    required BooleanPref premove,
    @JsonKey(unknownEnumValue: AutoQueen.premove) required AutoQueen autoQueen,
    @JsonKey(unknownEnumValue: AutoThreefold.always) required AutoThreefold autoThreefold,
    @JsonKey(unknownEnumValue: Takeback.always) required Takeback takeback,
    @JsonKey(fromJson: _booleanPrefFromJson, toJson: _booleanPrefToJson)
    required BooleanPref confirmResign,
    @JsonKey(fromJson: _submitMoveFromJson, toJson: _submitMoveToJson)
    required SubmitMove submitMove,
    // clock
    @JsonKey(unknownEnumValue: Moretime.always) required Moretime moretime,
    @JsonKey(unknownEnumValue: ClockTenths.lessThan10s) required ClockTenths clockTenths,
    @JsonKey(fromJson: _booleanPrefFromJson, toJson: _booleanPrefToJson)
    required BooleanPref clockSound,
    // privacy
    @JsonKey(fromJson: _booleanPrefFromJson, toJson: _booleanPrefToJson)
    required BooleanPref follow,
    @JsonKey(unknownEnumValue: Challenge.registered) required Challenge challenge,
    @JsonKey(unknownEnumValue: Message.always) required Message message,
  }) = _AccountPrefState;

  factory AccountPrefState.fromJson(Map<String, dynamic> json) {
    try {
      return _$AccountPrefStateFromJson(json);
    } catch (_) {
      return defaultAccountPreferences;
    }
  }
}

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

BooleanPref _booleanPrefFromJson(dynamic json) {
  if (json is bool) {
    return BooleanPref(json);
  } else if (json is int) {
    return BooleanPref(json != 0);
  }
  return const BooleanPref(false);
}

bool _booleanPrefToJson(BooleanPref pref) => pref.value;

SubmitMove _submitMoveFromJson(dynamic json) {
  if (json is int) {
    return SubmitMove.fromInt(json);
  }
  return SubmitMove([]);
}

int _submitMoveToJson(SubmitMove pref) => pref.value;

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
  @JsonValue(0)
  no(0),
  @JsonValue(1)
  yes(1),
  @JsonValue(2)
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
  @JsonValue(0)
  no(0),
  @JsonValue(1)
  yes(1),
  @JsonValue(2)
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
  @JsonValue(0)
  symbol(0),
  @JsonValue(1)
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
  @JsonValue(1)
  never(1),
  @JsonValue(2)
  premove(2),
  @JsonValue(3)
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
  @JsonValue(1)
  never(1),
  @JsonValue(2)
  time(2),
  @JsonValue(3)
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
  @JsonValue(1)
  never(1),
  @JsonValue(2)
  casual(2),
  @JsonValue(3)
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
  @JsonValue(1)
  never(1),
  @JsonValue(2)
  casual(2),
  @JsonValue(3)
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
  @JsonValue(0)
  never(0),
  @JsonValue(1)
  lessThan10s(1),
  @JsonValue(2)
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
  @JsonValue(1)
  never(1),
  @JsonValue(2)
  rating(2),
  @JsonValue(3)
  friends(3),
  @JsonValue(4)
  registered(4),
  @JsonValue(5)
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
  @JsonValue(1)
  never(1),
  @JsonValue(2)
  friends(2),
  @JsonValue(3)
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
  @JsonValue(1)
  unlimited(1),
  @JsonValue(2)
  correspondence(2),
  @JsonValue(4)
  classical(4),
  @JsonValue(8)
  rapid(8),
  @JsonValue(16)
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
