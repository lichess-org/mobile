import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';

import 'account_repository.dart';

part 'account_preferences.g.dart';

typedef AccountPrefState = ({
  // game display
  Zen zenMode,
  BooleanPref showRatings,
  // game behavior
  BooleanPref premove,
  AutoQueen autoQueen,
  AutoThreefold autoThreefold,
  Takeback takeback,
  BooleanPref confirmResign,
  SubmitMove submitMove,
  // clock
  Moretime moretime,
});

/// A provider that tells if the user has wants to see ratings in the app.
final showRatingsPrefProvider = FutureProvider<bool>((ref) async {
  return ref.watch(
    accountPreferencesProvider
        .selectAsync((state) => state?.showRatings.value ?? true),
  );
});

final defaultAccountPreferences = (
  zenMode: Zen.no,
  showRatings: const BooleanPref(true),
  premove: const BooleanPref(true),
  autoQueen: AutoQueen.premove,
  autoThreefold: AutoThreefold.always,
  takeback: Takeback.always,
  moretime: Moretime.always,
  confirmResign: const BooleanPref(true),
  submitMove: SubmitMove({
    SubmitMoveChoice.correspondence,
  }),
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

    return _repo.getPreferences().fold(
      (value) => value,
      (e, __) {
        debugPrint(
          '[AccountPreferences] Error getting account preferences: $e',
        );
        return defaultAccountPreferences;
      },
    );
  }

  Future<void> setZen(Zen value) => _setPref('zen', value);
  Future<void> setShowRatings(BooleanPref value) => _setPref('ratings', value);

  Future<void> setPremove(BooleanPref value) => _setPref('premove', value);
  Future<void> setTakeback(Takeback value) => _setPref('takeback', value);
  Future<void> setAutoQueen(AutoQueen value) => _setPref('autoQueen', value);
  Future<void> setAutoThreefold(AutoThreefold value) =>
      _setPref('autoThreefold', value);
  Future<void> setMoretime(Moretime value) => _setPref('moretime', value);
  Future<void> setConfirmResign(BooleanPref value) =>
      _setPref('confirmResign', value);
  Future<void> setSubmitMove(SubmitMove value) => _setPref('submitMove', value);

  Future<void> _setPref<T>(String key, AccountPref<T> value) async {
    await _repo.setPreference(key, value);
    ref.invalidateSelf();
  }

  AccountRepository get _repo => ref.read(accountRepositoryProvider);
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

class SubmitMove implements AccountPref<int> {
  SubmitMove(Iterable<SubmitMoveChoice> choices)
      : choices = ISet(choices.toSet());

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

  factory SubmitMove.fromInt(int value) => SubmitMove(
        SubmitMoveChoice.values
            .where((choice) => _bitPresent(value, choice.value)),
      );
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
