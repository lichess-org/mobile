import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/board_editor/board_editor_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_text_field.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class LoadPositionScreen extends StatelessWidget {
  const LoadPositionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(context.l10n.loadPosition),
      ),
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
              child: AdaptiveTextField(
                maxLines: 500,
                placeholder:
                    '${context.l10n.pasteTheFenStringHere} / ${context.l10n.pasteThePgnStringHere}',
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
                FatButton(
                  semanticsLabel: context.l10n.analysis,
                  onPressed: parsedInput != null
                      ? () => pushPlatformRoute(
                            context,
                            rootNavigator: true,
                            builder: (context) => AnalysisScreen(
                              options: parsedInput!.options,
                            ),
                          )
                      : null,
                  child: Text(context.l10n.analysis),
                ),
                const SizedBox(height: 16.0),
                FatButton(
                  semanticsLabel: context.l10n.boardEditor,
                  onPressed: parsedInput != null
                      ? () => pushPlatformRoute(
                            context,
                            rootNavigator: true,
                            builder: (context) =>
                                BoardEditorScreen(initialFen: parsedInput!.fen),
                          )
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

  ({String fen, AnalysisOptions options})? get parsedInput {
    if (textInput == null || textInput!.trim().isEmpty) {
      return null;
    }

    // try to parse as FEN first
    try {
      final pos = Chess.fromSetup(Setup.parseFen(textInput!.trim()));
      return (
        fen: pos.fen,
        options: AnalysisOptions(
          standalone: (
            pgn: '[FEN "${pos.fen}"]',
            isLocalEvaluationAllowed: true,
            variant: Variant.standard,
            orientation: Side.white,
          ),
        )
      );
    } catch (_, __) {}

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
        options: AnalysisOptions(
          standalone: (
            pgn: textInput!,
            isLocalEvaluationAllowed: true,
            variant: rule != null ? Variant.fromRule(rule) : Variant.standard,
            orientation: Side.white,
          ),
          initialMoveCursor: mainlineMoves.isEmpty ? 0 : 1,
        )
      );
    } catch (_, __) {}

    return null;
  }
}
