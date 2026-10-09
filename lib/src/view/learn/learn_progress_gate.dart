import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/learn/learn_progress.dart';
import 'package:material_ui/material_ui.dart';

typedef LearnProgressBuilder = Widget Function(BuildContext context, LearnProgress progress);

/// Resolves the learn progress for a subtree, without tearing it down on every reload.
///
/// The provider rebuilds on every account change, and a background request finding an expired
/// session invalidates the auth state too, so a rebuild is routine. Unmounting on it disposes the
/// stage controller and throws away the level in progress on the stage screen, and flashes the
/// list to a spinner on the stage list.
///
/// The error is not latched behind "has loaded once": that makes it unreachable for the rest of
/// the screen's life, leaving the subtree on empty progress and inviting a replay of finished
/// levels.
class const LearnProgressGate({required final LearnProgressBuilder builder, super.key})
    extends ConsumerStatefulWidget {
  @override
  ConsumerState<LearnProgressGate> createState() => _LearnProgressGateState();
}

class _LearnProgressGateState() extends ConsumerState<LearnProgressGate> {
  /// The last progress that loaded, used while a reload is in flight.
  ///
  /// `AsyncValue.value` is null while loading, so without this the subtree would be rebuilt from
  /// nothing. Riverpod keeps the previous value on a failed rebuild, so this covers an error after
  /// a successful load too.
  LearnProgress? lastLoaded;

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(learnProgressProvider);
    final value = progress.value;
    if (value != null) lastLoaded = value;
    final loaded = lastLoaded;
    if (loaded == null) {
      if (progress.hasError) {
        return Center(child: Text('Could not load progress: ${progress.error}'));
      }
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    return widget.builder(context, loaded);
  }
}
