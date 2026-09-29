import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/learn/learn_progress.dart';
import 'package:material_ui/material_ui.dart';

/// Builds a subtree from the resolved [LearnProgress].
typedef LearnProgressBuilder = Widget Function(BuildContext context, LearnProgress progress);

/// Resolves the learn progress for a subtree, without tearing it down on every reload.
///
/// [builder] is called with the progress, and stays mounted across a reload: the progress
/// provider rebuilds on every account change, and a background request that finds an expired
/// session invalidates the auth state too, so a rebuild is routine rather than exceptional.
/// Unmounting on it is costly on the stage screen, where it disposes the stage controller and
/// throws away the level in progress, and jarring on the stage list, where the whole list
/// flashes to a spinner.
///
/// The error is not latched behind "has loaded once". Doing so makes it unreachable for the rest
/// of the screen's life, so a failed reload would leave the subtree running on empty progress and
/// invite the user to replay levels they already finished.
// A declaring parameter cannot hold a function type, so the field is declared explicitly.
class const LearnProgressGate({
  // ignore: use_declaring_parameters
  required this.builder,
  super.key,
}) extends ConsumerStatefulWidget {
  final LearnProgressBuilder builder;

  @override
  ConsumerState<LearnProgressGate> createState() => _LearnProgressGateState();
}

class _LearnProgressGateState() extends ConsumerState<LearnProgressGate> {
  /// The last progress that loaded, used while a reload is in flight.
  ///
  /// `AsyncValue.value` is null while loading, so without this the subtree would be rebuilt from
  /// nothing. Riverpod keeps the previous value on a failed rebuild, so this also covers an error
  /// after a successful load.
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
