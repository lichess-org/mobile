import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/opening_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:meta/meta.dart';

/// Openings only exist for the first moves, so we don't look them up beyond this ply.
const _kMaxOpeningPly = 30;

/// Interface for a Notifier state that uses [OpeningExplorerMixin].
mixin OpeningExplorerMixinState {
  Variant get variant;
  UciPath get currentPath;

  /// The opening of the deepest ancestor of the current node (including itself).
  Opening? get currentBranchOpening;
}

/// Provides opening name lookup to an [AsyncNotifier] backing an analysis-like
/// screen (analysis, broadcast, study).
///
/// Openings are stored on the tree [Node]s. The build-time mainline fetch is
/// centralized here via [runBuild]; controllers only implement [positionTree]
/// and [refreshCurrentBranchOpening].
mixin OpeningExplorerMixin<T extends OpeningExplorerMixinState> on AsyncNotifier<T> {
  /// The tree where openings are stored.
  @protected
  Root get positionTree;

  /// Recomputes the state from the tree at the current path after an opening
  /// has been stored on a node.
  @protected
  void refreshCurrentBranchOpening();

  /// Whether openings can be fetched. Studies with an illegal starting position
  /// have no tree and should override this to return `false`.
  @protected
  bool get canFetchMainlineOpenings => true;

  @override
  WhenComplete runBuild() {
    final whenComplete = super.runBuild();
    // [future] resolves with the first non-loading state, i.e. once [positionTree]
    // is populated. Fire-and-forget: openings are a non-critical enhancement.
    future.then((_) {
      if (ref.mounted && state.hasValue) initMainlineOpenings();
    }).ignore();
    return whenComplete;
  }

  /// Fetches the opening for each mainline branch (up to [_kMaxOpeningPly]),
  /// stores them on the tree, and refreshes the current branch opening.
  @protected
  void initMainlineOpenings() {
    if (!canFetchMainlineOpenings) return;
    final openingFutures = <Future<(UciPath, FullOpening)?>>[];
    UciPath mainlinePath = UciPath.empty;
    for (final branch in positionTree.mainline) {
      mainlinePath = mainlinePath + branch.id;
      final openingFuture = _fetchMainlineOpening(branch, mainlinePath);
      if (openingFuture == null) break;
      openingFutures.add(openingFuture);
    }
    _applyFetchedOpenings(openingFutures);
  }

  /// Walks the tree from [node] down to [path], returning the node at [path]
  /// and the deepest opening found along the way.
  @protected
  (Node, Opening?) nodeOpeningAt(Node node, UciPath path, [Opening? opening]) {
    if (path.isEmpty) return (node, opening);
    final child = node.childById(path.head!);
    if (child != null) {
      return nodeOpeningAt(child, path.tail, child.opening ?? opening);
    } else {
      return (node, opening);
    }
  }

  /// The deepest opening found while walking the tree down to [path].
  @protected
  Opening? currentBranchOpeningAt(UciPath path) {
    final (_, opening) = nodeOpeningAt(positionTree, path);
    return opening;
  }

  Future<(UciPath, FullOpening)?>? _fetchMainlineOpening(Branch branch, UciPath mainlinePath) {
    if (branch.position.ply > _kMaxOpeningPly) return null;
    return fetchOpening(branch.position.fen, mainlinePath);
  }

  void _applyFetchedOpenings(List<Future<(UciPath, FullOpening)?>> openingFutures) {
    Future.wait(openingFutures).then((list) {
      var hasOpening = false;
      for (final updated in list) {
        if (updated != null) {
          hasOpening = true;
          final (path, opening) = updated;
          positionTree.updateAt(path, (node) => node.opening = opening);
        }
      }
      if (hasOpening && ref.mounted && state.hasValue) {
        scheduleMicrotask(() {
          if (!ref.mounted || !state.hasValue) return;
          refreshCurrentBranchOpening();
        });
      }
    });
  }

  /// Fetches [currentNode]'s opening if it is a shallow [Branch] without one yet,
  /// then refreshes the current branch opening. Call from the controller's `_setPath`.
  @protected
  void maybeFetchOpeningAt(Node currentNode, UciPath path) {
    if (currentNode is Branch &&
        currentNode.opening == null &&
        currentNode.position.ply <= _kMaxOpeningPly) {
      fetchOpening(currentNode.position.fen, path).then((value) {
        if (value != null) {
          positionTree.updateAt(value.$1, (node) => node.opening = value.$2);
          if (ref.mounted && state.hasValue) {
            refreshCurrentBranchOpening();
          }
        }
      });
    }
  }

  /// Fetches the opening for [fen], returning it with [path] if found and the
  /// variant allows openings.
  @protected
  Future<(UciPath, FullOpening)?> fetchOpening(String fen, UciPath path) async {
    if (!kOpeningAllowedVariants.contains(state.value?.variant ?? Variant.standard)) {
      return null;
    }
    try {
      final opening = await ref.read(openingServiceProvider).fetchFromFen(fen);
      return opening != null ? (path, opening) : null;
    } catch (_) {
      return null;
    }
  }
}
