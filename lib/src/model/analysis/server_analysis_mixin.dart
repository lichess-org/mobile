import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/game/game_socket_events.dart';

/// Interface for Notifiers's State that uses [ServerAnalysisMixin].
mixin ServerAnalysisMixinState {
  /// If null, server analysis can not be requested currently, e.g. because the analyzed game is still ongoing.
  ServerAnalysisSource? get serverAnalysisSource;
}

/// A mixin to provide server analysis functionality to an [AsyncNotifier].
///
/// The parent must implement the following:
/// - [positionTree] to provide the tree where the evaluations are stored.
/// - [onServerAnalysisEvent] to react to new analysis events from ongoing server analysis and update internal state.
mixin ServerAnalysisMixin<T extends ServerAnalysisMixinState> on AnyNotifier<AsyncValue<T>, T> {
  late ServerAnalysisService _serverAnalysisService;

  Root get positionTree;

  ValueListenable<ServerAnalysisSource?> get currentServerAnalysis =>
      _serverAnalysisService.currentAnalysis;

  @override
  void runBuild() {
    _serverAnalysisService = ref.watch(serverAnalysisServiceProvider);

    // Avoid registering the listener multiple times when the notifier is rebuilt.
    _serverAnalysisService.lastAnalysisEvent.removeListener(_onServerAnalysisEvent);
    _serverAnalysisService.lastAnalysisEvent.addListener(_onServerAnalysisEvent);

    ref.onDispose(() {
      _serverAnalysisService.lastAnalysisEvent.removeListener(_onServerAnalysisEvent);
    });

    super.runBuild();
  }

  Future<void> requestServerAnalysis([Side? side]) async {
    final serverAnalysisSource = state.requireValue.serverAnalysisSource;
    if (serverAnalysisSource != null) {
      await ref.read(serverAnalysisServiceProvider).requestAnalysis(serverAnalysisSource, side);
    } else {
      return Future.error('Cannot request server analysis');
    }
  }

  Future<void> onServerAnalysisEvent(ServerEvalEvent event);

  Future<void> _onServerAnalysisEvent() async {
    if (ref.read(serverAnalysisServiceProvider).lastAnalysisEvent.value case (
      final source,
      final event,
    ) when source == state.value?.serverAnalysisSource) {
      ServerAnalysisService.mergeOngoingAnalysis(positionTree, event.tree);
      await onServerAnalysisEvent(event);
    }
  }

  @protected
  IList<ExternalEval>? makeAcplChartData() {
    if (!positionTree.mainline.any((node) => node.lichessAnalysisComments != null)) {
      return null;
    }
    final list = positionTree.mainline
        .map(
          (node) => (
            node.position.isCheckmate,
            node.position.turn,
            node.lichessAnalysisComments?.firstWhereOrNull((c) => c.eval != null)?.eval,
          ),
        )
        .map((el) {
          final (isCheckmate, side, eval) = el;
          return eval != null
              ? ExternalEval(
                  cp: eval.pawns != null ? cpFromPawns(eval.pawns!) : null,
                  mate: eval.mate,
                  depth: eval.depth,
                )
              : ExternalEval(
                  cp: null,
                  // hack to display checkmate as the max eval
                  mate: isCheckmate
                      ? side == Side.white
                            ? -1
                            : 1
                      : null,
                );
        })
        .toList(growable: false);
    return list.isEmpty ? null : IList(list);
  }
}
