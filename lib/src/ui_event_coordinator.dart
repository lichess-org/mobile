import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/ui_events.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';

final uiEventCoordinatorProvider = Provider<UiEventCoordinator>((Ref ref) {
  final coordinator = UiEventCoordinator(ref);
  ref.onDispose(coordinator.dispose);
  return coordinator;
}, name: 'UiEventCoordinatorProvider');

/// The view layer's half of the model/view split: listens to the [uiEventBusProvider] and performs
/// the navigation, dialogs and snackbars that the model layer asks for.
///
/// Started from `_AppState.initState` before any service, so that no event is emitted before
/// someone is listening.
class UiEventCoordinator(final Ref ref) {
  StreamSubscription<UiEvent>? _subscription;

  void start() {
    _subscription = ref.read(uiEventBusProvider).stream.listen(_handle);
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }

  void _handle(UiEvent event) {
    switch (event) {
      case ShowErrorEvent(:final message):
        final context = _currentContext;
        if (context != null) {
          showSnackBar(context, message, type: SnackBarType.error);
        }
    }
  }

  /// The context of the navigator for the tab the user is currently on, or `null` when there is no
  /// widget tree to show anything in.
  BuildContext? get _currentContext {
    final context = ref.read(currentNavigatorKeyProvider).currentContext;
    return context != null && context.mounted ? context : null;
  }
}
