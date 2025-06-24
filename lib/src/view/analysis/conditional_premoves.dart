import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

class ConditionalPremoves extends ConsumerWidget {
  const ConditionalPremoves(this.options);

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);
    final analysisState = ref.watch(ctrlProvider).requireValue;

    final lines = analysisState.forecast!.lines;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 9,
              child: ListView.separated(
                itemCount: lines.length,
                itemBuilder: (_, i) => _SavedVariation(
                  options,
                  startingNode: analysisState.liveMoveNode!,
                  path: lines[i],
                  onTap: () {
                    ref
                        .read(analysisControllerProvider(options).notifier)
                        .userJump(UciPath.join(analysisState.pathToLiveMove!, lines[i]));
                  },
                ),
                separatorBuilder: (_, _) => const Divider(),
              ),
            ),
            const Divider(),
            Flexible(flex: 2, child: _AddVariationButton(options)),
            if (analysisState.pendingMove != null &&
                analysisState.linesForPendingMove?.isNotEmpty == true) ...[
              const Divider(),
              _PlayAndSaveButton(options),
            ],
          ],
        ),
      ),
    );
  }
}

class _AddVariationButton extends ConsumerWidget {
  const _AddVariationButton(this.options);

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(analysisControllerProvider(options)).requireValue;

    final icon = analysisState.currentPremoveCandidate != null ? Icons.save : Icons.info;

    return GestureDetector(
      onTap: ref.read(analysisControllerProvider(options).notifier).addCurrentPathAsPremove,
      child: Row(
        children: [
          Padding(padding: const EdgeInsets.all(8.0), child: Icon(icon)),
          Expanded(
            child: analysisState.currentPremoveCandidate != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style: TextStyle(
                          color: ColorScheme.of(context).onSurface.withValues(alpha: 0.7),
                        ),
                        context.l10n.addCurrentVariation,
                      ),
                      _Variation(
                        startingNode: analysisState.liveMoveNode!,
                        path: analysisState.currentPremoveCandidate!,
                        maxLines: 1,
                      ),
                    ],
                  )
                : Center(child: Text(context.l10n.playVariationToCreateConditionalPremoves)),
          ),
        ],
      ),
    );
  }
}

class _PlayAndSaveButton extends ConsumerWidget {
  const _PlayAndSaveButton(this.options);

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(analysisControllerProvider(options)).requireValue;

    final followUpLines = analysisState.linesForPendingMove!.count((path) => path.size > 1);

    return FilledButton.icon(
      icon: const Icon(CupertinoIcons.play_arrow),
      label: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            style: const TextStyle(fontWeight: FontWeight.bold),
            context.l10n.playX(analysisState.pendingMove!.san),
          ),
          if (followUpLines > 0)
            Text(context.l10n.andSaveNbPremoveLines(followUpLines))
          else
            Text(context.l10n.noConditionalPremoves),
        ],
      ),
      onPressed: ref
          .read(analysisControllerProvider(options).notifier)
          .playPendingMoveAndSaveForecast,
    );
  }
}

class _SavedVariation extends ConsumerWidget {
  const _SavedVariation(this.options, {required this.startingNode, required this.path, this.onTap});

  final AnalysisOptions options;

  final ViewNode startingNode;

  final UciPath path;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: _Variation(startingNode: startingNode, path: path, maxLines: 2),
            ),
            IconButton(
              onPressed: () {
                ref.read(analysisControllerProvider(options).notifier).removePremovePath(path);
              },
              icon: const Icon(CupertinoIcons.delete, size: 20),
              tooltip: context.l10n.delete,
            ),
          ],
        ),
      ),
    );
  }
}

class _Variation extends ConsumerWidget {
  const _Variation({required this.startingNode, required this.path, required this.maxLines});

  final ViewNode startingNode;

  final UciPath path;

  final int maxLines;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceNotation = ref
        .watch(pieceNotationProvider)
        .maybeWhen(data: (value) => value, orElse: () => defaultAccountPreferences.pieceNotation);

    return Text(
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 14,
        fontFamily: pieceNotation == PieceNotation.symbol ? 'ChessFont' : null,
      ),
      overflow: TextOverflow.ellipsis,
      startingNode
          .branchesOn(path)
          .mapIndexed((i, branch) {
            final indexText = i == 0 && branch.position.turn == Side.white
                ? '${branch.position.fullmoves - 1}.. '
                : branch.position.turn == Side.black
                ? '${branch.position.fullmoves}. '
                : '';
            return '$indexText${branch.sanMove.san}';
          })
          .join(' '),
    );
  }
}
