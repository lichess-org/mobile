import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

class EngineLines extends ConsumerWidget {
  const EngineLines({
    super.key,
    required this.onTapMove,
    required this.clientEval,
    required this.isGameOver,
  });
  final void Function(NormalMove move) onTapMove;
  final ClientEval? clientEval;
  final bool isGameOver;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numEvalLines = ref.watch(analysisPreferencesProvider.select((p) => p.numEvalLines));
    final engineEval = ref.watch(engineEvaluationProvider).eval;
    final eval = engineEval ?? clientEval;

    final emptyLines = List.filled(numEvalLines, const Engineline.empty());

    final content =
        isGameOver
            ? emptyLines
            : (eval != null
                ? eval.pvs
                    .take(numEvalLines)
                    .map((pv) => Engineline(onTapMove, eval.position, pv))
                    .toList()
                : emptyLines);

    if (content.length < numEvalLines) {
      final padding = List.filled(numEvalLines - content.length, const Engineline.empty());
      content.addAll(padding);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: content,
    );
  }
}

class Engineline extends ConsumerWidget {
  const Engineline(this.onTapMove, this.fromPosition, this.pvData, {super.key});

  const Engineline.empty({super.key})
    : onTapMove = null,
      pvData = const PvData(moves: IListConst([])),
      fromPosition = Chess.initial;

  final void Function(NormalMove move)? onTapMove;
  final Position fromPosition;
  final PvData pvData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pvData.moves.isEmpty) {
      return const SizedBox(height: kEvalGaugeSize, child: SizedBox.shrink());
    }

    final pieceNotation = ref
        .watch(pieceNotationProvider)
        .maybeWhen(data: (value) => value, orElse: () => defaultAccountPreferences.pieceNotation);

    final lineBuffer = StringBuffer();
    int ply = fromPosition.ply + 1;
    pvData.sanMoves(fromPosition).forEachIndexed((i, s) {
      lineBuffer.write(
        ply.isOdd
            ? '${(ply / 2).ceil()}. $s '
            : i == 0
            ? '${(ply / 2).ceil()}... $s '
            : '$s ',
      );
      ply += 1;
    });

    final brightness = Theme.of(context).brightness;

    final evalString = pvData.evalString;
    return AdaptiveInkWell(
      onTap: () => onTapMove?.call(NormalMove.fromUci(pvData.moves[0])),
      child: SizedBox(
        height: kEvalGaugeSize,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color:
                      pvData.winningSide == Side.black
                          ? EngineGauge.backgroundColor(context, brightness)
                          : EngineGauge.valueColor(context, brightness),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                child: Text(
                  evalString,
                  style: TextStyle(
                    color: pvData.winningSide == Side.black ? Colors.white : Colors.black,
                    fontSize: kEvalGaugeFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  lineBuffer.toString(),
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    fontFamily: pieceNotation == PieceNotation.symbol ? 'ChessFont' : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
