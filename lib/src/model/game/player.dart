import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@Freezed(fromJson: true, toJson: true)
class Player with _$Player {
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
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  bool get isAI => aiLevel != null;

  /// Returns the name of the player, including title if available
  String fullName(BuildContext context) {
    final displayName = this.displayName(context);
    return user?.title != null ? '${user!.title} $displayName' : displayName;
  }

  /// Returns the name of the player, without title
  String displayName(BuildContext context) =>
      user?.name ??
      name ??
      (aiLevel != null
          ? context.l10n.aiNameLevelAiLevel('Stockfish', aiLevel.toString())
          : context.l10n.anonymous);

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
class PlayerAnalysis with _$PlayerAnalysis {
  const factory PlayerAnalysis({
    required int inaccuracies,
    required int mistakes,
    required int blunders,
    int? acpl,
    int? accuracy,
  }) = _PlayerAnalysis;

  factory PlayerAnalysis.fromJson(Map<String, dynamic> json) => _$PlayerAnalysisFromJson(json);
}
