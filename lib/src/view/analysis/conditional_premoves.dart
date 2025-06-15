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

    final currentCandidate = analysisState.currentPremoveCandidate;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 6,
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView(
                  children: [
                    ...lines.map(
                      (line) => _SavedVariation(
                        options,
                        startingNode: analysisState.liveMoveNode!,
                        path: line,
                        onTap: () {
                          ref
                              .read(analysisControllerProvider(options).notifier)
                              .userJump(UciPath.join(analysisState.pathToLiveMove!, line));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Flexible(
              flex: 1,
              child: _AddVariationButton(options),
              //child: Center(
              //  child: currentCandidate != null
              //      ? FilledButton.icon(
              //          icon: const Icon(Icons.save),
              //          onPressed: ref
              //              .read(analysisControllerProvider(options).notifier)
              //              .addCurrentPathAsPremove,
              //          // TODO also render variatiojn as text
              //          label: Column(
              //            children: [
              //              Text(context.l10n.addCurrentVariation),
              //              _Variation(
              //                startingNode: analysisState.liveMoveNode!,
              //                path: analysisState.currentPath,
              //              ),
              //            ],
              //          ),
              //        )
              //      : Text(context.l10n.playVariationToCreateConditionalPremoves),
              //),
            ),
          ],
          //_PlayMoveButton(options),
          //],
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

    return Row(
      children: [
        Padding(padding: const EdgeInsets.all(8.0), child: Icon(icon)),
        Expanded(
          child: analysisState.currentPremoveCandidate != null
              ? GestureDetector(
                  onTap: ref
                      .read(analysisControllerProvider(options).notifier)
                      .addCurrentPathAsPremove,
                  child: Column(
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
                  ),
                )
              : Text(context.l10n.playVariationToCreateConditionalPremoves),
        ),
      ],
    );
  }
}

class _PlayMoveButton extends ConsumerWidget {
  const _PlayMoveButton(this.options);

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(analysisControllerProvider(options)).requireValue;

    if (!analysisState.forecast!.onMyTurn) {
      return const SizedBox.shrink();
    }

    return const SizedBox.shrink();
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

    return Text.rich(
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 14,
        fontFamily: pieceNotation == PieceNotation.symbol ? 'ChessFont' : null,
      ),
      overflow: TextOverflow.ellipsis,
      TextSpan(
        children: startingNode
            .branchesOn(path)
            .mapIndexed(
              (i, branch) => WidgetSpan(
                child: _Move(branch: branch, startsLine: i == 0),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _Move extends StatelessWidget {
  const _Move({required this.branch, required this.startsLine});

  final ViewBranch branch;

  final bool startsLine;

  @override
  Widget build(BuildContext context) {
    final indexText = startsLine && branch.position.turn == Side.white
        ? '${branch.position.fullmoves - 1}.. '
        : branch.position.turn == Side.black
        ? '${branch.position.fullmoves}. '
        : '';
    return Text('$indexText${branch.sanMove.san} ');
  }
}
