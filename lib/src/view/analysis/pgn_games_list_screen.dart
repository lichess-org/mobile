import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_player.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';

typedef _GameData = ({
  AnalysisPlayer? white,
  AnalysisPlayer? black,
  Variant variant,
  String title,
  String subtitle,
});

/// A screen that lists multiple games parsed from one PGN file, allowing the user to select one for analysis.
class PgnGamesListScreen extends StatefulWidget {
  const PgnGamesListScreen({required this.games, super.key});

  final IList<PgnGame> games;

  static Route<dynamic> buildRoute(BuildContext context, IList<PgnGame> games) {
    return buildScreenRoute(context, screen: PgnGamesListScreen(games: games));
  }

  @override
  State<PgnGamesListScreen> createState() => _PgnGamesListScreenState();
}

class _PgnGamesListScreenState extends State<PgnGamesListScreen> {
  late final IList<_GameData> _gameData;
  String _searchQuery = '';
  late final TextEditingController _searchController;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _gameData = _parseGameData();
  }

  IList<_GameData> _parseGameData() {
    return List.generate(widget.games.length, (index) {
      final game = widget.games[index];
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
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showSearchBar = widget.games.length > 5;
    final filteredIndices = _searchQuery.isEmpty
        ? List.generate(widget.games.length, (i) => i, growable: false)
        : List.generate(
            widget.games.length,
            (i) => i,
          ).where((i) => _matchesSearchQuery(_gameData[i], _searchQuery)).toList(growable: false);

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(context.l10n.nbGames(widget.games.length)),
        bottom: showSearchBar
            ? PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: Padding(
                  padding: Styles.horizontalBodyPadding.add(const EdgeInsets.only(bottom: 8)),
                  child: PlatformSearchBar(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    onClear: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  ),
                ),
              )
            : null,
      ),
      body: ListView.separated(
        itemCount: filteredIndices.length,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
        itemBuilder: (context, index) {
          final game = widget.games[filteredIndices[index]];
          final gameData = _gameData[filteredIndices[index]];
          return ListTile(
            title: Text(gameData.title, maxLines: 2, overflow: .ellipsis),
            subtitle: Text(gameData.subtitle, overflow: .ellipsis, maxLines: 1),
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                AnalysisScreen.buildRoute(
                  context,
                  AnalysisOptions.pgn(
                    // TODO generate unique id for each game, maybe based on the PGN headers?
                    id: const StringId('pgn_import_game'),
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
    );
  }
}

bool _matchesSearchQuery(_GameData gameData, String query) {
  final lowerQuery = query.toLowerCase();
  return gameData.white?.name.toLowerCase().contains(lowerQuery) == true ||
      gameData.black?.name.toLowerCase().contains(lowerQuery) == true ||
      gameData.title.toLowerCase().contains(lowerQuery) ||
      gameData.subtitle.toLowerCase().contains(lowerQuery);
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
    if (player.title != null) player.title,
    player.name,
    if (player.rating != null) '(${player.rating})',
  ].join(' ');
}
