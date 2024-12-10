import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'game_share_service.g.dart';

@Riverpod(keepAlive: true)
GameShareService gameShareService(Ref ref) {
  return GameShareService(ref);
}

class GameShareService {
  GameShareService(this._ref);

  final Ref _ref;

  /// Fetches the raw PGN of a game and launches the share dialog.
  Future<String> rawPgn(GameId id) async {
    final resp = await _ref.withClient(
      (client) => client
          .get(
            Uri(
              path: '/game/export/$id',
              queryParameters: {'evals': '0', 'clocks': '0'},
            ),
          )
          .timeout(const Duration(seconds: 1)),
    );
    if (resp.statusCode != 200) {
      throw Exception('Failed to get PGN');
    }
    return utf8.decode(resp.bodyBytes);
  }

  /// Fetches the annotated PGN of a game and launches the share dialog.
  Future<String> annotatedPgn(GameId id) async {
    final resp = await _ref.withClient(
      (client) => client
          .get(
            Uri(
              path: '/game/export/$id',
              queryParameters: {'literate': '1'},
            ),
          )
          .timeout(const Duration(seconds: 1)),
    );
    if (resp.statusCode != 200) {
      throw Exception('Failed to get PGN');
    }
    return utf8.decode(resp.bodyBytes);
  }

  /// Fetches the GIF screenshot of a position and launches the share dialog.
  Future<XFile> screenshotPosition(
    Side orientation,
    String fen,
    Move? lastMove,
  ) async {
    final boardTheme = _ref.read(boardPreferencesProvider).boardTheme;
    final pieceTheme = _ref.read(boardPreferencesProvider).pieceSet;
    final resp = await _ref
        .read(defaultClientProvider)
        .get(
          Uri.parse(
            '$kLichessCDNHost/export/fen.gif?fen=${Uri.encodeComponent(fen)}&color=${orientation.name}${lastMove != null ? '&lastMove=${lastMove.uci}' : ''}&theme=${boardTheme.name}&piece=${pieceTheme.name}',
          ),
        )
        .timeout(const Duration(seconds: 1));
    if (resp.statusCode != 200) {
      throw Exception('Failed to get GIF');
    }
    return XFile.fromData(resp.bodyBytes, mimeType: 'image/gif');
  }

  /// Fetches the GIF animation of a game.
  Future<XFile> gameGif(GameId id, Side orientation) async {
    final boardPreferences = _ref.read(boardPreferencesProvider);
    final boardTheme = boardPreferences.boardTheme == BoardTheme.system
        ? BoardTheme.brown
        : boardPreferences.boardTheme;
    final pieceTheme = boardPreferences.pieceSet;
    final resp = await _ref
        .read(defaultClientProvider)
        .get(
          Uri.parse(
            '$kLichessCDNHost/game/export/gif/${orientation.name}/$id.gif?theme=${boardTheme.gifApiName}&piece=${pieceTheme.name}',
          ),
        )
        .timeout(const Duration(seconds: 1));
    if (resp.statusCode != 200) {
      throw Exception('Failed to get GIF');
    }
    return XFile.fromData(resp.bodyBytes, mimeType: 'image/gif');
  }
}
