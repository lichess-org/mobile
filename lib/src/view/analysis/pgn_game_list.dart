import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_player.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';

/// A screen that lists multiple games parsed from one PGN file, allowing the user to select one for analysis.
class PgnGamesListScreen extends StatelessWidget {
  const PgnGamesListScreen({required this.games, required this.source, super.key});

  final IList<PgnGame> games;
  final String source;

  static Route<dynamic> buildRoute(BuildContext context, IList<PgnGame> games, String source) {
    return buildScreenRoute(
      context,
      screen: PgnGamesListScreen(games: games, source: source),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$source - ${games.length} ${context.l10n.games}')),
      body: SafeArea(
        child: ListView.separated(
          itemCount: games.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
          itemBuilder: (context, index) {
            final game = games[index];
            final rule = Rule.fromPgn(game.headers['Variant']);
            final white = AnalysisPlayer.fromPgnHeaders(game.headers.lock, .white);
            final black = AnalysisPlayer.fromPgnHeaders(game.headers.lock, .black);

            return ListTile(
              title: Text(
                '${_formatPlayerName(white)} vs ${_formatPlayerName(black)} ${game.headers['Result'] ?? ''}',
              ),
              subtitle: Text(_buildGameSubtitle(game), overflow: .ellipsis),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  AnalysisScreen.buildRoute(
                    context,
                    AnalysisOptions.standalone(
                      id: const StringId('standalone'),
                      orientation: .white,
                      pgn: game.makePgn(),
                      variant: rule != null ? .fromRule(rule) : .standard,
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
    final parts = <String>[];

    final event = game.headers['Event'];
    final round = game.headers['Round'];

    if (event != null && event.isNotEmpty && event != '?') {
      if (round != null && round.isNotEmpty && round != '?') {
        parts.add('$event ($round)');
      } else {
        parts.add(event);
      }
    }

    final site = game.headers['Site'];
    if (site != null && site.isNotEmpty && site != '?') {
      parts.add(site);
    }

    final date = game.headers['Date'];
    if (date != null && date.isNotEmpty && date != '?') {
      parts.add(date);
    }

    return parts.join(' • ');
  }

  String _formatPlayerName(AnalysisPlayer? player) {
    return player == null
        ? '?'
        : '${player.title != null ? '${player.title} ' : ''}${player.name}${player.rating != null ? ' (${player.rating})' : ''}';
  }
}
