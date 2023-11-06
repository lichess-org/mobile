import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/adaptive_text_field.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';

class AnalysisPositionChoiceScreen extends StatelessWidget {
  const AnalysisPositionChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.analysis),
      ),
      body: const _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.analysis),
      ),
      child: const _Body(),
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
                    '${context.l10n.pasteTheFenStringHere}\n\n${context.l10n.pasteThePgnStringHere}\n\nLeave empty for initial position',
                controller: _controller,
                readOnly: true,
                onTap: _getClipboardData,
              ),
            ),
          ),
          Padding(
            padding: Styles.bodySectionBottomPadding,
            child: FatButton(
              semanticsLabel: context.l10n.analysis,
              onPressed: parsedInput != null
                  ? () => pushPlatformRoute(
                        context,
                        rootNavigator: true,
                        builder: (context) => AnalysisScreen(
                          options: parsedInput!,
                        ),
                      )
                  : null,
              child: Text(context.l10n.studyStart),
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

  AnalysisOptions? get parsedInput {
    if (textInput == null || textInput!.trim().isEmpty) {
      return const AnalysisOptions(
        isLocalEvaluationAllowed: true,
        variant: Variant.standard,
        orientation: Side.white,
        pgn: '',
        id: ValueId('standalone_analysis'),
      );
    }

    // try to parse as FEN first
    try {
      final pos = Chess.fromSetup(Setup.parseFen(textInput!.trim()));
      return AnalysisOptions(
        isLocalEvaluationAllowed: true,
        variant: Variant.standard,
        orientation: Side.white,
        pgn: '[FEN "${pos.fen}"]',
        id: const ValueId('standalone_analysis'),
      );
    } catch (_, __) {}

    // try to parse as PGN
    try {
      final game = PgnGame.parsePgn(textInput!);
      final initialPosition = PgnGame.startingPosition(game.headers);
      final rules = Rules.fromPgn(game.headers['Variant']);

      // require at least 1 valid move
      if (game.moves.mainline().isEmpty) return null;
      final move = initialPosition.parseSan(game.moves.mainline().first.san);
      if (move == null) return null;

      return AnalysisOptions(
        isLocalEvaluationAllowed: true,
        variant: rules != null ? Variant.fromRules(rules) : Variant.standard,
        pgn: textInput!,
        initialMoveCursor: 1,
        orientation: Side.white,
        id: const ValueId('standalone_analysis'),
      );
    } catch (_, __) {}

    return null;
  }
}
