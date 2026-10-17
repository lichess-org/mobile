import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A request from the model layer for something only the view can do.
///
/// Kept deliberately narrow: snackbars only. Anything heavier (navigation,
/// dialogs, confirmations) belongs in the view layer call site, not on this
/// bus.
sealed class const UiEvent();

/// Shows an error [message] in a snackbar.
class const ShowErrorEvent(final String message) extends UiEvent;

/// The channel on which [UiEvent]s travel from the model layer to the view layer.
final uiEventBusProvider = Provider<UiEventBus>((Ref ref) {
  final bus = UiEventBus();
  ref.onDispose(bus.close);
  return bus;
}, name: 'UiEventBusProvider');

class UiEventBus() {
  final StreamController<UiEvent> _controller = StreamController.broadcast();

  Stream<UiEvent> get stream => _controller.stream;

  void emit(UiEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  void close() {
    _controller.close();
  }
}
