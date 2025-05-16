import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart' show AppLocalizations;

import 'package:lichess_mobile/src/model/user/user.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@Freezed(fromJson: true, toJson: true)
sealed class Player with _$Player {
  const Player._();

  const factory Player({
    LightUser? user,
    String? name,
    int? aiLevel,
    int? rating,
    int? ratingDiff,

    /// if true, the rating is not definitive yet
    bool? provisional,

    /// Whether the player is connected to the game websocket
    bool? onGame,

    /// Is true if the player is disconnected from the game long enough that the
    /// opponent can claim a win
    bool? isGone,
    bool? offeringDraw,
    bool? offeringRematch,
    bool? proposingTakeback,

    /// Post game player analysis summary
    PlayerAnalysis? analysis,

    /// If in a tournament, whether the player has berserked or not. Null otherwise.
    bool? berserk,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  bool get isAI => aiLevel != null;

  /// Returns the name of the player, including title if available
  String fullName(AppLocalizations l10n) {
    final displayName = this.displayName(l10n);
    return user?.title != null ? '${user!.title} $displayName' : displayName;
  }

  /// Returns the name of the player, without title
  String displayName(AppLocalizations l10n) =>
      user?.name ??
      name ??
      (aiLevel != null ? l10n.aiNameLevelAiLevel('Stockfish', aiLevel.toString()) : l10n.anonymous);

  Player setOnGame(bool onGame) {
    final isOnGame = onGame || isAI;
    return copyWith(onGame: isOnGame, isGone: isOnGame ? false : isGone);
  }

  Player setGone(bool isGone) {
    final goneButNoAI = isGone && !isAI;
    return copyWith(isGone: goneButNoAI, onGame: goneButNoAI ? false : onGame);
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class PlayerAnalysis with _$PlayerAnalysis {
  const factory PlayerAnalysis({
    required int inaccuracies,
    required int mistakes,
    required int blunders,
    int? acpl,
    int? accuracy,
  }) = _PlayerAnalysis;

  factory PlayerAnalysis.fromJson(Map<String, dynamic> json) => _$PlayerAnalysisFromJson(json);
}
