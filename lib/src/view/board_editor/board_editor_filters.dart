import 'dart:convert';

import 'package:dartchess/dartchess.dart' hide Position;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/board_editor/board_editor_controller.dart';
import 'package:lichess_mobile/src/model/board_editor/position.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class BoardEditorFilters extends ConsumerWidget {
  const BoardEditorFilters({required this.initialFen, super.key});

  final String? initialFen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorController = boardEditorControllerProvider(initialFen);
    final editorState = ref.watch(editorController);

    return BottomSheetScrollableContainer(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      children: [
        Padding(
          padding: Styles.horizontalBodyPadding,
          child: Wrap(
            spacing: 8.0,
            children:
                Side.values.map((side) {
                  return ChoiceChip(
                    label: Text(
                      side == Side.white ? context.l10n.whitePlays : context.l10n.blackPlays,
                    ),
                    selected: editorState.sideToPlay == side,
                    onSelected: (selected) {
                      if (selected) {
                        ref.read(editorController.notifier).setSideToPlay(side);
                      }
                    },
                  );
                }).toList(),
          ),
        ),
        Padding(
          padding: Styles.bodySectionPadding,
          child: Text(context.l10n.castling, style: Styles.title),
        ),
        ...Side.values.map((side) {
          return Padding(
            padding: Styles.horizontalBodyPadding,
            child: Row(
              spacing: 8.0,
              children: [
                SizedBox(
                  width: 100.0,
                  child: Text(
                    side == Side.white ? context.l10n.white : context.l10n.black,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ...[CastlingSide.king, CastlingSide.queen].map((castlingSide) {
                  return ChoiceChip(
                    label: Text(castlingSide == CastlingSide.king ? 'O-O' : 'O-O-O'),
                    selected: editorState.isCastlingAllowed(side, castlingSide),
                    onSelected: (selected) {
                      ref.read(editorController.notifier).setCastling(side, castlingSide, selected);
                    },
                  );
                }),
              ],
            ),
          );
        }),
        if (editorState.enPassantOptions.isNotEmpty) ...[
          const Padding(
            padding: Styles.bodySectionPadding,
            child: Text('En passant', style: Styles.subtitle),
          ),
          Wrap(
            spacing: 8.0,
            children:
                editorState.enPassantOptions.squares.map((square) {
                  return ChoiceChip(
                    label: Text(square.name),
                    selected: editorState.enPassantSquare == square,
                    onSelected: (selected) {
                      ref.read(editorController.notifier).toggleEnPassantSquare(square);
                    },
                  );
                }).toList(),
          ),
        ],
      ],
    );
  }
}

class SearchPositionScreen extends StatelessWidget {
  const SearchPositionScreen({required this.onPositionSelected, super.key});

  final void Function(Position position) onPositionSelected;

  static Route<dynamic> buildRoute(
    BuildContext context, {
    required void Function(Position position) onPositionSelected,
  }) {
    return buildScreenRoute(
      context,
      screen: SearchPositionScreen(onPositionSelected: onPositionSelected),
      title: context.l10n.loadPosition,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabBar = TabBar(
      tabs: [Tab(text: context.l10n.openings), Tab(text: context.l10n.endgamePositions)],
    );
    final tabBarView = TabBarView(
      children: [
        _OpeningsTab(onPositionSelected: onPositionSelected),
        _EndGamesTab(onPositionSelected: onPositionSelected),
      ],
    );

    return DefaultTabController(
      length: 2,
      child: PlatformWidget(
        iosBuilder: (context) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(context.l10n.loadPosition),
              bottom: tabBar,
            ),
            child: tabBarView,
          );
        },
        androidBuilder:
            (context) => Scaffold(
              appBar: AppBar(title: Text(context.l10n.loadPosition), bottom: tabBar),
              body: tabBarView,
            ),
      ),
    );
  }
}

class _OpeningsTab extends StatefulWidget {
  const _OpeningsTab({required this.onPositionSelected});

  final void Function(Position position) onPositionSelected;

  @override
  State<_OpeningsTab> createState() => _OpeningsTabState();
}

class _OpeningsTabState extends State<_OpeningsTab> {
  late final Future<List<Position>>? _openings;

  @override
  void initState() {
    _openings = DefaultAssetBundle.of(context).loadString('assets/positions.json').then((s) {
      final List<Position> result = [];
      for (final opening in (jsonDecode(s) as List<dynamic>).cast<Map<String, dynamic>>()) {
        for (final position
            in (opening['positions'] as List<dynamic>).cast<Map<String, dynamic>>()) {
          result.add(Position.fromJson(position));
        }
      }
      return result;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _openings,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            final position = snapshot.data![index];
            return PlatformListTile(
              title: Text(position.name),
              onTap: () => widget.onPositionSelected(position),
            );
          },
        );
      },
    );
  }
}

class _EndGamesTab extends StatefulWidget {
  const _EndGamesTab({required this.onPositionSelected});

  final void Function(Position position) onPositionSelected;

  @override
  State<_EndGamesTab> createState() => _EndGamesTabState();
}

class _EndGamesTabState extends State<_EndGamesTab> {
  late final Future<List<Position>>? _endGames;

  @override
  void initState() {
    _endGames = DefaultAssetBundle.of(context).loadString('assets/endgames.json').then((s) {
      final List<Position> result = [];
      for (final position in (jsonDecode(s) as List<dynamic>).cast<Map<String, dynamic>>()) {
        result.add(Position.fromJson(position));
      }
      return result;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _endGames,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            final position = snapshot.data![index];
            return PlatformListTile(
              title: Text(position.name),
              onTap: () => widget.onPositionSelected(position),
            );
          },
        );
      },
    );
  }
}
