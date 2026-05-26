import 'dart:convert';

import 'package:deep_pick/deep_pick.dart';
import 'package:http/http.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/game/player.dart';

/// The study/broadcast pgn endpoints send this summary of server analysis via the 'x-lichess-analysis' header if the query contains 'analysisHeader=1'.
typedef AnalysisSummary = ({Division? division, PlayerAnalysis white, PlayerAnalysis black});

AnalysisSummary? readAnalysisSummaryFromHeader(Response response) {
  final analysisHeader = response.headers['x-lichess-analysis'];
  if (analysisHeader != null) {
    final json = jsonDecode(analysisHeader) as Map<String, dynamic>;
    return _analysisSummaryFromPick(json);
  }
  return null;
}

AnalysisSummary _analysisSummaryFromPick(Map<String, dynamic> json) {
  final summary = pick(json, 'summary').required();
  return (
    division: pick(json, 'division').letOrNull(_divisionFromPick),
    white: _playerAnalysisSummaryFromPick(summary('white').required()),
    black: _playerAnalysisSummaryFromPick(summary('black').required()),
  );
}

PlayerAnalysis _playerAnalysisSummaryFromPick(RequiredPick pick) {
  return PlayerAnalysis(
    inaccuracies: pick('inaccuracy').asIntOrThrow(),
    mistakes: pick('mistake').asIntOrThrow(),
    blunders: pick('blunder').asIntOrThrow(),
    acpl: pick('acpl').asIntOrThrow(),
    accuracy: pick('accuracy').asIntOrThrow(),
  );
}

Division _divisionFromPick(RequiredPick pick) {
  return Division(middlegame: pick('middle').asIntOrNull(), endgame: pick('end').asIntOrNull());
}
