import 'package:dartchess/dartchess.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/board_editor/board_editor_screen.dart';

class LoadPositionScreen extends StatelessWidget {
  const LoadPositionScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const LoadPositionScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.loadPosition)),
      body: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _controller = TextEditingController();

  String? textInput;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        textInput = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: Styles.bodySectionPadding,
              child: TextField(
                maxLines: 500,
                decoration: InputDecoration(
                  hintText:
                      '${context.l10n.pasteTheFenStringHere}\n\u2014\n${context.l10n.pasteThePgnStringHere}',
                  hintMaxLines: 3,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.upload_file),
                        onPressed: _pickPgnFile,
                        tooltip: 'Upload PGN file',
                      ),
                      IconButton(
                        icon: const Icon(Icons.paste),
                        onPressed: _getClipboardData,
                        tooltip: 'Paste from clipboard',
                      ),
                    ],
                  ),
                ),
                controller: _controller,
                readOnly: true,
                onTap: _getClipboardData,
              ),
            ),
          ),
          Padding(
            padding: Styles.bodySectionBottomPadding,
            child: Column(
              children: [
                FilledButton(
                  onPressed: parsedInput != null
                      ? () => Navigator.of(
                          context,
                          rootNavigator: true,
                        ).push(AnalysisScreen.buildRoute(context, parsedInput!.options))
                      : null,
                  child: Text(context.l10n.analysis),
                ),
                const SizedBox(height: 16.0),
                FilledButton(
                  onPressed: parsedInput != null
                      ? () => Navigator.of(
                          context,
                          rootNavigator: true,
                        ).push(BoardEditorScreen.buildRoute(context, initialFen: parsedInput!.fen))
                      : null,
                  child: Text(context.l10n.boardEditor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getClipboardData() async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      _controller.text = data.text!;
    }
  }

  Future<void> _pickPgnFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pgn'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final content = String.fromCharCodes(result.files.single.bytes!);

        // Validate that it's actually a PGN file
        try {
          PgnGame.parsePgn(content);
          _controller.text = content;
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid PGN file: $e'), backgroundColor: Colors.red),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading file: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  ({String fen, AnalysisOptions options})? get parsedInput {
    if (textInput == null || textInput!.trim().isEmpty) {
      return null;
    }

    // try to parse as FEN first
    try {
      final pos = Chess.fromSetup(Setup.parseFen(textInput!.trim()));
      return (
        fen: pos.fen,
        options: AnalysisOptions.standalone(
          id: const StringId('standalone'),
          orientation: Side.white,
          pgn: '[FEN "${pos.fen}"]',
          isComputerAnalysisAllowed: true,
          variant: Variant.standard,
        ),
      );
    } catch (_) {}

    // try to parse as PGN
    try {
      final game = PgnGame.parsePgn(textInput!);
      final initialPosition = PgnGame.startingPosition(game.headers);
      final rule = Rule.fromPgn(game.headers['Variant']);

      final mainlineMoves = game.moves.mainline();
      //if there is a first move, require it to be valid, otherwise require a FEN
      if ((mainlineMoves.isNotEmpty &&
              (initialPosition.parseSan(mainlineMoves.first.san) == null)) ||
          (mainlineMoves.isEmpty && game.headers['FEN'] == null)) {
        return null;
      }

      final lastPosition = mainlineMoves.fold(
        initialPosition,
        (pos, move) => pos.play(pos.parseSan(move.san)!),
      );

      return (
        fen: lastPosition.fen,
        options: AnalysisOptions.standalone(
          id: const StringId('standalone'),
          orientation: Side.white,
          pgn: textInput!,
          isComputerAnalysisAllowed: true,
          variant: rule != null ? Variant.fromRule(rule) : Variant.standard,
          initialMoveCursor: mainlineMoves.isEmpty ? 0 : 1,
        ),
      );
    } catch (_) {}

    return null;
  }
}
