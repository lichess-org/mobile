import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:lichess_mobile/l10n/l10n.dart';

/// Represents the choice of a side as a player: white, black or random.
enum SideChoice {
  white,
  random,
  black;

  /// Generate a random side
  Side _randomSide() => Side.values[Random().nextInt(Side.values.length)];

  Side get generateSide => switch (this) {
    SideChoice.white => Side.white,
    SideChoice.black => Side.black,
    SideChoice.random => _randomSide(),
  };

  String label(AppLocalizations l10n) => switch (this) {
    SideChoice.white => l10n.white,
    SideChoice.random => l10n.randomColor,
    SideChoice.black => l10n.black,
  };
}
