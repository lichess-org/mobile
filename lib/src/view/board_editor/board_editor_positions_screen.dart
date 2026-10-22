import 'dart:convert';

import 'package:dartchess/dartchess.dart' hide Position;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/board_editor/board_editor_controller.dart';
import 'package:lichess_mobile/src/model/board_editor/position.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_tab_bar.dart';
import 'package:material_ui/material_ui.dart';

class const BoardEditorPositionsScreen({
  required final void Function(String fen) onPositionSelected,
  final BoardEditorControllerParams? params,
  super.key,
}) extends ConsumerWidget {
  static Route<dynamic> buildRoute(
    BoardEditorControllerParams? params, {
    required void Function(String fen) onPositionSelected,
  }) {
    return buildScreenRoute(
      screen: BoardEditorPositionsScreen(onPositionSelected: onPositionSelected),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabBarView = TabBarView(
      children: [
        _OpeningsTab(onPositionSelected: onPositionSelected),
        _EndGamesTab(onPositionSelected: onPositionSelected),
      ],
    );

    return DefaultTabController(
      length: 2,
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'FEN',
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => _FenDialog(onFenLoaded: (fen) => onPositionSelected(fen)),
              ),
            ),
          ],
          title: Text(context.l10n.loadPosition),
          bottom: PlatformTabBar(tabs: [context.l10n.openings, context.l10n.endgamePositions]),
        ),
        body: tabBarView,
      ),
    );
  }
}

class const _FenDialog({required final void Function(String fen) onFenLoaded})
    extends StatefulWidget {
  @override
  State<_FenDialog> createState() => _FenDialogState();
}

class _FenDialogState() extends State<_FenDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text == null || !mounted) return;

    final text = data!.text!.trim();
    if (text.isEmpty) return;

    _controller.text = text;
    try {
      widget.onFenLoaded(_fenToLoad(Setup.parseFen(text)));
    } on FenException {
      showSnackBar(context, context.l10n.invalidFen, type: SnackBarType.error);
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  /// The FEN to load into the editor for [setup].
  ///
  /// The position [setup] describes may be illegal: a missing king, the side
  /// not to move in check, ... It is loaded all the same, as if the pieces had
  /// been dragged onto the board, so that the user can fix it there.
  static String _fenToLoad(Setup setup) {
    try {
      // Going through a Position drops what cannot be true of the board, such
      // as an en passant square that no pawn could have created.
      return Chess.fromSetup(setup).fen;
    } on PositionSetupException {
      return setup.fen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: _controller,
        readOnly: true,
        onTap: _pasteFromClipboard,
        decoration: InputDecoration(
          hintText: context.l10n.pasteTheFenStringHere,
          suffixIcon: IconButton(
            icon: const Icon(Icons.paste),
            onPressed: _pasteFromClipboard,
            tooltip: 'Paste from clipboard',
          ),
        ),
      ),
    );
  }
}

class const _OpeningsTab({required final void Function(String fen) onPositionSelected})
    extends StatefulWidget {
  @override
  State<_OpeningsTab> createState() => _OpeningsTabState();
}

class _OpeningsTabState() extends State<_OpeningsTab> {
  late final Future<List<Position>>? _openings;

  @override
  void initState() {
    _openings = rootBundle.loadString('assets/positions.json').then((s) {
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
            return ListTile(
              title: Text(position.name),
              onTap: () => widget.onPositionSelected(position.fen),
            );
          },
        );
      },
    );
  }
}

class const _EndGamesTab({required final void Function(String fen) onPositionSelected})
    extends StatefulWidget {
  @override
  State<_EndGamesTab> createState() => _EndGamesTabState();
}

class _EndGamesTabState() extends State<_EndGamesTab> {
  late final Future<List<Position>>? _endGames;

  @override
  void initState() {
    _endGames = rootBundle.loadString('assets/endgames.json').then((s) {
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
            return ListTile(
              title: Text(position.name),
              onTap: () => widget.onPositionSelected(position.fen),
            );
          },
        );
      },
    );
  }
}
