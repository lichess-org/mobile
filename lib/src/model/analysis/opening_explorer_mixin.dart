import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/opening_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';

/// The maximum ply up to which openings are looked up.
///
/// Openings only exist for the first moves of a game, so there is no point in
/// querying the opening database for positions deeper than this.
const _kMaxOpeningPly = 30;

/// Interface for a Notifier state that uses [OpeningExplorerMixin].
mixin OpeningExplorerMixinState {
  /// The variant of the analysis, used to determine whether openings should be
  /// looked up (see [kOpeningAllowedVariants]).
  Variant get variant;

  /// The path to the current node in the analysis view.
  UciPath get currentPath;

  /// The opening associated with the current branch, if any.
  ///
  /// This is the opening of the deepest ancestor of the current node (including
  /// the current node itself) that has an opening.
  Opening? get currentBranchOpening;
}

/// A mixin to provide opening name lookup to an [AsyncNotifier] backing an
/// analysis-like screen (analysis, broadcast, study).
///
/// Openings are stored on the tree [Node]s themselves and the
/// [OpeningExplorerMixinState.currentBranchOpening] is recomputed whenever the
/// current path changes or a new opening is fetched.
///
/// The parent must implement:
/// - [positionTree] to provide the tree where openings are stored.
/// - [refreshCurrentBranchOpening] to recompute its state from the tree at the
///   current path (i.e. rebuild `currentNode` and update `currentBranchOpening`)
///   after an opening has been fetched.
mixin OpeningExplorerMixin<T extends OpeningExplorerMixinState> on AnyNotifier<AsyncValue<T>, T> {
  /// The tree where openings are stored.
  Root get positionTree;

  /// Recomputes the state from the tree at the current path after an opening
  /// has been stored on a node.
  ///
  /// Implementations should rebuild their `currentNode` from the tree (so a
  /// freshly fetched opening on the current node is reflected) and update
  /// `currentBranchOpening` with [currentBranchOpeningAt] for the current path.
  void refreshCurrentBranchOpening();

  /// Walks the tree from [node] down to [path], returning the node at [path]
  /// and the deepest opening found along the way.
  (Node, Opening?) nodeOpeningAt(Node node, UciPath path, [Opening? opening]) {
    if (path.isEmpty) return (node, opening);
    final child = node.childById(path.head!);
    if (child != null) {
      return nodeOpeningAt(child, path.tail, child.opening ?? opening);
    } else {
      return (node, opening);
    }
  }

  /// The opening associated with the current branch given [path], i.e. the
  /// deepest opening found while walking the tree down to [path].
  Opening? currentBranchOpeningAt(UciPath path) {
    final (_, opening) = nodeOpeningAt(positionTree, path);
    return opening;
  }

  /// Returns a future that fetches the opening for the mainline [branch] at
  /// [mainlinePath], or `null` if the position is too deep to have an opening.
  ///
  /// Should be called during the build of the notifier while iterating over the
  /// mainline. The returned futures should be collected and then awaited with
  /// [applyFetchedOpenings].
  Future<(UciPath, FullOpening)?>? fetchMainlineOpening(Branch branch, UciPath mainlinePath) {
    if (branch.position.ply > _kMaxOpeningPly) return null;
    return fetchOpening(branch.position.fen, mainlinePath);
  }

  /// Awaits the [openingFutures] collected during build, stores the fetched
  /// openings on the tree, and refreshes the current branch opening if any
  /// opening was found.
  ///
  /// This is fire-and-forget: it must not block the build, since openings are a
  /// non-critical enhancement.
  void applyFetchedOpenings(List<Future<(UciPath, FullOpening)?>> openingFutures) {
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

  /// If [currentNode] is a [Branch] without an opening yet (and shallow enough),
  /// fetches its opening asynchronously, stores it on the tree, then refreshes
  /// the current branch opening.
  ///
  /// Should be called from the controller's `_setPath` when the path changes.
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

  /// Fetches the opening for [fen] from the opening database, returning it
  /// together with [path] if found and the variant allows openings.
  Future<(UciPath, FullOpening)?> fetchOpening(String fen, UciPath path) async {
    if (!kOpeningAllowedVariants.contains(state.value?.variant ?? Variant.standard)) {
      return null;
    }
    final opening = await ref.read(openingServiceProvider).fetchFromFen(fen);
    if (opening != null) {
      return (path, opening);
    }
    return null;
  }
}
