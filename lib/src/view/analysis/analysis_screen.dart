import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen_body.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_settings.dart';
import 'package:lichess_mobile/src/view/analysis/engine_depth.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({
    required this.options,
    required this.pgnOrId,
    this.enableDrawingShapes = true,
  });

  /// The analysis options.
  final AnalysisOptions options;

  /// The PGN or game ID to load.
  final String pgnOrId;

  final bool enableDrawingShapes;

  @override
  Widget build(BuildContext context) {
    return pgnOrId.length == 8 && GameId(pgnOrId).isValid
        ? _LoadGame(
            GameId(pgnOrId),
            options,
            enableDrawingShapes: enableDrawingShapes,
          )
        : _LoadedAnalysisScreen(
            options: options,
            pgn: pgnOrId,
            enableDrawingShapes: enableDrawingShapes,
          );
  }
}

class _LoadGame extends ConsumerWidget {
  const _LoadGame(
    this.gameId,
    this.options, {
    required this.enableDrawingShapes,
  });

  final AnalysisOptions options;
  final GameId gameId;

  final bool enableDrawingShapes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameAsync = ref.watch(archivedGameProvider(id: gameId));

    return gameAsync.when(
      data: (game) {
        final serverAnalysis =
            game.white.analysis != null && game.black.analysis != null
                ? (white: game.white.analysis!, black: game.black.analysis!)
                : null;
        return _LoadedAnalysisScreen(
          options: options.copyWith(
            id: game.id,
            opening: game.meta.opening,
            division: game.meta.division,
            serverAnalysis: serverAnalysis,
          ),
          pgn: game.makePgn(),
          enableDrawingShapes: enableDrawingShapes,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, _) {
        return Center(
          child: Text('Cannot load game analysis: $error'),
        );
      },
    );
  }
}

class _LoadedAnalysisScreen extends ConsumerWidget {
  const _LoadedAnalysisScreen({
    required this.options,
    required this.pgn,
    required this.enableDrawingShapes,
  });

  final AnalysisOptions options;
  final String pgn;

  final bool enableDrawingShapes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
      ref: ref,
    );
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(pgn, options);

    return PlatformScaffold(
      resizeToAvoidBottomInset: false,
      appBar: PlatformAppBar(
        title: _Title(options: options),
        actions: [
          EngineDepth(ctrlProvider),
          AppBarIconButton(
            onPressed: () => showAdaptiveBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              isDismissible: true,
              builder: (_) => AnalysisSettings(pgn, options),
            ),
            semanticsLabel: context.l10n.settingsSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: AnalysisScreenBody(
        pgn: pgn,
        options: options,
        enableDrawingShapes: enableDrawingShapes,
      ),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(pgn, options);

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        padding: Styles.cupertinoAppBarTrailingWidgetPadding,
        middle: _Title(options: options),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            EngineDepth(ctrlProvider),
            AppBarIconButton(
              onPressed: () => showAdaptiveBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                showDragHandle: true,
                isDismissible: true,
                builder: (_) => AnalysisSettings(pgn, options),
              ),
              semanticsLabel: context.l10n.settingsSettings,
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
      child: AnalysisScreenBody(
        pgn: pgn,
        options: options,
        enableDrawingShapes: enableDrawingShapes,
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.options});
  final AnalysisOptions options;

  static const excludedIcons = [Variant.standard, Variant.fromPosition];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!excludedIcons.contains(options.variant)) ...[
          Icon(options.variant.icon),
          const SizedBox(width: 5.0),
        ],
        Text(context.l10n.analysis),
      ],
    );
  }
}
