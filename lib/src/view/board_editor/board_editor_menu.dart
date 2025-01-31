import 'dart:convert';

import 'package:dartchess/dartchess.dart' hide Position;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/board_editor/board_editor_controller.dart';
import 'package:lichess_mobile/src/model/board_editor/position.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class BoardEditorMenu extends ConsumerWidget {
  const BoardEditorMenu({required this.initialFen, super.key});

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
            alignment: WrapAlignment.spaceEvenly,
            children: [
              SecondaryButton(
                semanticsLabel: context.l10n.loadPosition,
                child: Text(context.l10n.loadPosition),
                onPressed: () {
                  final notifier = ref.read(editorController.notifier);
                  pushReplacementPlatformRoute(
                    context,
                    title: context.l10n.preferencesHowDoYouMovePieces,
                    rootNavigator: true,
                    builder:
                        (context) => SearchPositionScreen(
                          onPositionSelected:
                              (position) => {
                                notifier.loadFen(position.fen),
                                Navigator.of(context, rootNavigator: true).pop(),
                              },
                        ),
                  );
                },
              ),
              SecondaryButton(
                semanticsLabel: context.l10n.clearBoard,
                child: Text(context.l10n.clearBoard),
                onPressed: () {
                  ref.read(editorController.notifier).loadFen(kEmptyFen);
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          ),
        ),
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text(context.l10n.loadPosition),
          bottom: TabBar(
            tabs: [Tab(text: context.l10n.openings), Tab(text: context.l10n.endgamePositions)],
          ),
        ),
        body: TabBarView(
          children: [
            _OpeningsTab(onPositionSelected: onPositionSelected),
            _EndGamesTab(onPositionSelected: onPositionSelected),
          ],
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
  // TODO Provider
  late final Future<List<Position>>? _openings;

  @override
  void initState() {
    _openings = DefaultAssetBundle.of(context).loadString('assets/positions.json').then((s) {
      final List<Position> result = [];
      for (final opening in jsonDecode(s) as List) {
        // ignore: avoid_dynamic_calls
        for (final position in opening['positions'] as List) {
          result.add(Position.fromJson(position as Map<String, dynamic>));
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
  // TODO Provider
  late final Future<List<Position>>? _endGames;

  @override
  void initState() {
    _endGames = DefaultAssetBundle.of(context).loadString('assets/endgames.json').then((s) {
      final List<Position> result = [];
      for (final position in jsonDecode(s) as List) {
        result.add(Position.fromJson(position as Map<String, dynamic>));
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
