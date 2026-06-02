import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/view/more/import_pgn_screen.dart';
import 'package:logging/logging.dart';

final _logger = Logger('SharedPgn');

const _methods = MethodChannel('mobile.lichess.org/share');
const _events = EventChannel('mobile.lichess.org/share/events');

final sharedPgnServiceProvider = Provider<SharedPgnService>((ref) {
  final service = SharedPgnService(ref);
  ref.onDispose(() => service.dispose());
  return service;
});

/// Handles PGN content shared into the app from other apps or opened from a
/// `.pgn` file, routing it to the import screen.
///
/// The native side (Android [MainActivity], iOS [AppDelegate] + Share Extension)
/// reads the shared file content and delivers it as a plain [String], either as
/// the initial value the app was cold-started with or through an event stream
/// while the app is already running.
class SharedPgnService {
  SharedPgnService(this.ref);

  final Ref ref;

  StreamSubscription<dynamic>? _subscription;

  Future<void> start() async {
    // Handle the PGN the app was cold-started with (if any) after the first
    // frame so the navigator is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final pgn = await _methods.invokeMethod<String>('getInitialPgn');
        if (pgn != null) _handlePgn(pgn);
      } catch (e, st) {
        _logger.severe('Error handling initial shared PGN: $e\n$st');
      }
    });

    // PGN shared while the app is already running.
    _subscription = _events.receiveBroadcastStream().listen((event) {
      if (event is String) _handlePgn(event);
    }, onError: (Object e, StackTrace st) => _logger.severe('Error in shared PGN stream: $e\n$st'));
  }

  void _handlePgn(String pgnText) {
    final context = ref.read(currentNavigatorKeyProvider).currentContext;
    if (context == null || !context.mounted) return;
    ImportPgnScreen.handlePgnText(context, pgnText);
  }

  void dispose() {
    _subscription?.cancel();
  }
}
