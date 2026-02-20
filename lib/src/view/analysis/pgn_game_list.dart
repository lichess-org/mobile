import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_player.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';

typedef _GameData = ({
  AnalysisPlayer? white,
  AnalysisPlayer? black,
  Variant variant,
  String title,
  String subtitle,
});

/// A screen that lists multiple games parsed from one PGN file, allowing the user to select one for analysis.
class PgnGamesListScreen extends StatelessWidget {
  PgnGamesListScreen({required this.games, required this.source, super.key});

  final IList<PgnGame> games;
  final String source;

  late final IList<_GameData> _gameData = List.generate(games.length, (index) {
    final game = games[index];
    final headers = game.headers.lock;
    final white = AnalysisPlayer.fromPgnHeaders(headers, .white);
    final black = AnalysisPlayer.fromPgnHeaders(headers, .black);
    final rule = Rule.fromPgn(game.headers['Variant']);
    final variant = rule != null ? Variant.fromRule(rule) : Variant.standard;
    return (
      white: white,
      black: black,
      variant: variant,
      title:
          '${_formatPlayerName(white)} vs ${_formatPlayerName(black)} ${game.headers['Result'] ?? ''}',
      subtitle: _buildGameSubtitle(game),
    );
  }, growable: false).lock;

  static Route<dynamic> buildRoute(BuildContext context, IList<PgnGame> games, String source) {
    return buildScreenRoute(
      context,
      screen: PgnGamesListScreen(games: games, source: source),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Flexible(child: Text(source, overflow: .ellipsis)),
            Text(' • ${games.length} ${context.l10n.games}'),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: games.length,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          separatorBuilder: (context, index) =>
              const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
          itemBuilder: (context, index) {
            final game = games[index];
            final gameData = _gameData[index];
            return ListTile(
              title: Text(gameData.title, maxLines: 2, overflow: .ellipsis),
              subtitle: Text(gameData.subtitle, overflow: .ellipsis, maxLines: 1),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  AnalysisScreen.buildRoute(
                    context,
                    AnalysisOptions.standalone(
                      id: const StringId('standalone'),
                      orientation: .white,
                      pgn: game.makePgn(),
                      variant: gameData.variant,
                      isComputerAnalysisAllowed: true,
                      initialMoveCursor: game.moves.mainline().isEmpty ? 0 : 1,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _buildGameSubtitle(PgnGame game) {
    final event = game.headers['Event'];
    final round = game.headers['Round'];
    final site = game.headers['Site'];
    final date = game.headers['Date'];

    return [
      if (event != null && event.isNotEmpty && event != '?')
        (round != null && round.isNotEmpty && round != '?') ? '$event ($round)' : event,
      if (site != null && site.isNotEmpty && site != '?') site,
      if (date != null && date.isNotEmpty && date != '?') date,
    ].join(' • ');
  }

  String _formatPlayerName(AnalysisPlayer? player) {
    if (player == null) return '?';
    return [
      if (player.title != null) player.title!,
      player.name,
      if (player.rating != null) '(${player.rating})',
    ].join(' ');
  }
}
