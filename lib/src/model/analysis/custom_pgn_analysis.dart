import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/node.dart';

part 'custom_pgn_analysis.freezed.dart';

/// Represents a parsed PGN game with its move tree
@freezed
sealed class ParsedPgnGame with _$ParsedPgnGame {
  const factory ParsedPgnGame({
    required String fileName,
    required Root moveTree,
    required String rawPgn,
  }) = _ParsedPgnGame;
}

/// State for custom PGN analysis
@freezed
sealed class CustomPgnAnalysisState with _$CustomPgnAnalysisState {
  const factory CustomPgnAnalysisState({
    @Default(IListConst([])) IList<ParsedPgnGame> parsedGames,
    @Default(IListConst([])) IList<String> failedFiles,
    @Default(false) bool isEngineDisabled,
  }) = _CustomPgnAnalysisState;
}

/// Represents a matched move suggestion from PGN files
@freezed
sealed class MoveSuggestion with _$MoveSuggestion {
  const factory MoveSuggestion({
    required Move move,
    required String san,
    required String fromGame,
  }) = _MoveSuggestion;
}

/// Provider for custom PGN analysis state
final customPgnAnalysisProvider =
    NotifierProvider<CustomPgnAnalysisNotifier, CustomPgnAnalysisState>(
      CustomPgnAnalysisNotifier.new,
      name: 'CustomPgnAnalysisProvider',
    );

class CustomPgnAnalysisNotifier extends Notifier<CustomPgnAnalysisState> {
  @override
  CustomPgnAnalysisState build() {
    return const CustomPgnAnalysisState();
  }

  /// Load PGN files and parse them
  Future<void> loadPgnFiles(List<String> fileNames, List<String> pgnContents) async {
    final List<ParsedPgnGame> validGames = [];
    final List<String> failed = [];

    for (int i = 0; i < fileNames.length; i++) {
      try {
        final pgnGame = PgnGame.parsePgn(pgnContents[i]);
        final moveTree = Root.fromPgnGame(pgnGame);

        // Validate that the game has at least one move
        if (moveTree.children.isEmpty) {
          failed.add(fileNames[i]);
          continue;
        }

        validGames.add(
          ParsedPgnGame(fileName: fileNames[i], moveTree: moveTree, rawPgn: pgnContents[i]),
        );
      } catch (e) {
        failed.add(fileNames[i]);
      }
    }

    state = state.copyWith(
      parsedGames: validGames.toIList(),
      failedFiles: failed.toIList(),
      isEngineDisabled: validGames.isNotEmpty,
    );
  }

  /// Find move suggestions for a given position and return them as shapes (arrows)
  ISet<Shape> getMoveSuggestionsAsShapes(
    Position currentPosition,
    List<Move> moveHistory,
    Color arrowColor,
  ) {
    final suggestions = <Move>[];

    for (final game in state.parsedGames) {
      // Try to match the current move sequence
      final matchedMove = _findMatchInGame(game, currentPosition, moveHistory);
      if (matchedMove != null && !suggestions.contains(matchedMove)) {
        suggestions.add(matchedMove);
      }
    }

    // Convert moves to arrow shapes
    return suggestions
        .map((move) {
          if (move is NormalMove) {
            return Arrow(color: arrowColor, orig: move.from, dest: move.to);
          }
          return null;
        })
        .whereType<Shape>()
        .toISet();
  }

  /// Find move suggestions for a given position (for display purposes)
  List<MoveSuggestion> findMoveSuggestions(Position currentPosition, List<Move> moveHistory) {
    final suggestions = <MoveSuggestion>[];

    for (final game in state.parsedGames) {
      // Try to match the current move sequence
      final matchedMove = _findMatchInGame(game, currentPosition, moveHistory);
      if (matchedMove != null) {
        final san = currentPosition.makeSan(matchedMove).$2;
        suggestions.add(MoveSuggestion(move: matchedMove, san: san, fromGame: game.fileName));
      }
    }

    return suggestions;
  }

  /// Find a matching move in a specific game
  Move? _findMatchInGame(ParsedPgnGame game, Position currentPosition, List<Move> moveHistory) {
    if (moveHistory.isEmpty) {
      // At the start position, suggest the first move of the game
      final firstMove = game.moveTree.children.firstOrNull;
      return firstMove?.sanMove.move;
    }

    // Traverse the game tree following the move history
    Node currentNode = game.moveTree;
    for (final move in moveHistory) {
      final nextNode = currentNode.children.firstWhereOrNull((child) => child.sanMove.move == move);

      if (nextNode == null) {
        // This game doesn't match the current move sequence
        return null;
      }

      currentNode = nextNode;
    }

    // Found a match! Now get the next move if it exists
    final nextMove = currentNode.children.firstOrNull;
    return nextMove?.sanMove.move;
  }

  /// Clear all loaded PGN files
  void clear() {
    state = const CustomPgnAnalysisState();
  }
}
