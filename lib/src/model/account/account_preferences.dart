import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_preferences.g.dart';

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
  BooleanPref clockSound,
  // privacy
  BooleanPref follow,
  Challenge challenge,
  Message message,
});

/// A provider that tells if the user wants to see ratings in the app.
@Riverpod(keepAlive: true)
Future<ShowRatings> showRatingsPref(Ref ref) async {
  return ref.watch(
    accountPreferencesProvider.selectAsync((state) => state?.showRatings ?? ShowRatings.yes),
  );
}

@Riverpod(keepAlive: true)
Future<bool> clockSound(Ref ref) async {
  return ref.watch(
    accountPreferencesProvider.selectAsync((state) => state?.clockSound.value ?? true),
  );
}

@Riverpod(keepAlive: true)
Future<PieceNotation> pieceNotation(Ref ref) async {
  return ref.watch(
    accountPreferencesProvider.selectAsync(
      (state) => state?.pieceNotation ?? defaultAccountPreferences.pieceNotation,
    ),
  );
}

final defaultAccountPreferences = (
  zenMode: Zen.no,
  pieceNotation: PieceNotation.symbol,
  showRatings: ShowRatings.yes,
  premove: const BooleanPref(true),
  autoQueen: AutoQueen.premove,
  autoThreefold: AutoThreefold.always,
  takeback: Takeback.always,
  moretime: Moretime.always,
  clockSound: const BooleanPref(true),
  confirmResign: const BooleanPref(true),
  submitMove: SubmitMove({SubmitMoveChoice.correspondence}),
  follow: const BooleanPref(true),
  challenge: Challenge.registered,
  message: Message.always,
);

/// Get the account preferences for the current user.
///
/// The result is cached for the lifetime of the app, until refreshed.
/// If the server returns an error, default values are returned.
@Riverpod(keepAlive: true)
class AccountPreferences extends _$AccountPreferences {
  @override
  Future<AccountPrefState?> build() async {
    final session = ref.watch(authSessionProvider);

    if (session == null) {
      return null;
    }

    try {
      return ref.withClient((client) => AccountRepository(client).getPreferences());
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
  Future<void> setClockSound(BooleanPref value) => _setPref('clockSound', value);
  Future<void> setConfirmResign(BooleanPref value) => _setPref('confirmResign', value);
  Future<void> setSubmitMove(SubmitMove value) => _setPref('submitMove', value);
  Future<void> setFollow(BooleanPref value) => _setPref('follow', value);
  Future<void> setChallenge(Challenge value) => _setPref('challenge', value);
  Future<void> setMessage(Message value) => _setPref('message', value);

  Future<void> _setPref<T>(String key, AccountPref<T> value) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await ref.withClient((client) => AccountRepository(client).setPreference(key, value));
    ref.invalidateSelf();
  }
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

  String label(BuildContext context) {
    switch (this) {
      case Zen.no:
        return context.l10n.no;
      case Zen.yes:
        return context.l10n.yes;
      case Zen.gameAuto:
        return context.l10n.preferencesInGameOnly;
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

  String label(BuildContext context) {
    switch (this) {
      case ShowRatings.no:
        return context.l10n.no;
      case ShowRatings.yes:
        return context.l10n.yes;
      case ShowRatings.exceptInGame:
        return context.l10n.preferencesExceptInGame;
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

  String label(BuildContext context) {
    switch (this) {
      case PieceNotation.symbol:
        return context.l10n.preferencesChessPieceSymbol;
      case PieceNotation.letter:
        return context.l10n.preferencesPgnLetter;
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

  String label(BuildContext context) {
    switch (this) {
      case AutoQueen.never:
        return context.l10n.never;
      case AutoQueen.premove:
        return context.l10n.preferencesWhenPremoving;
      case AutoQueen.always:
        return context.l10n.always;
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

  String label(BuildContext context) {
    switch (this) {
      case AutoThreefold.never:
        return context.l10n.never;
      case AutoThreefold.time:
        return context.l10n.preferencesWhenTimeRemainingLessThanThirtySeconds;
      case AutoThreefold.always:
        return context.l10n.always;
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

  String label(BuildContext context) {
    switch (this) {
      case Takeback.never:
        return context.l10n.never;
      case Takeback.casual:
        return context.l10n.preferencesInCasualGamesOnly;
      case Takeback.always:
        return context.l10n.always;
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

  String label(BuildContext context) {
    switch (this) {
      case Moretime.never:
        return context.l10n.never;
      case Moretime.casual:
        return context.l10n.preferencesInCasualGamesOnly;
      case Moretime.always:
        return context.l10n.always;
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

  String label(BuildContext context) {
    switch (this) {
      case Challenge.never:
        return context.l10n.never;
      case Challenge.rating:
        return context.l10n.ifRatingIsPlusMinusX('300');
      case Challenge.friends:
        return context.l10n.onlyFriends;
      case Challenge.registered:
        return context.l10n.ifRegistered;
      case Challenge.always:
        return context.l10n.always;
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

  String label(BuildContext context) {
    switch (this) {
      case Message.never:
        return context.l10n.onlyExistingConversations;
      case Message.friends:
        return context.l10n.onlyFriends;
      case Message.always:
        return context.l10n.always;
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

  String label(BuildContext context) {
    if (choices.isEmpty) {
      return context.l10n.never;
    }

    return choices.map((choice) => choice.label(context)).join(', ');
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

  String label(BuildContext context) {
    switch (this) {
      case SubmitMoveChoice.unlimited:
        return context.l10n.unlimited;
      case SubmitMoveChoice.correspondence:
        return context.l10n.correspondence;
      case SubmitMoveChoice.classical:
        return context.l10n.classical;
      case SubmitMoveChoice.rapid:
        return context.l10n.rapid;
      case SubmitMoveChoice.blitz:
        return 'Blitz';
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
