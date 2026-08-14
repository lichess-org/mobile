import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:url_launcher/url_launcher.dart';

/// A provider for [RecapService].
final recapServiceProvider = Provider<RecapService>((Ref ref) {
  final service = RecapService(ref);
  ref.onDispose(service.dispose);
  return service;
}, name: 'recapServiceProvider');

class RecapService {
  RecapService(this.ref);

  final Ref ref;

  StreamSubscription<ParsedLocalNotification>? _notificationResponseSubscription;

  void start() {
    _notificationResponseSubscription = NotificationService.responseStream.listen((data) {
      final (_, notification) = data;
      switch (notification) {
        case RecapNotification():
          launchUrl(lichessUri('recap'));
        case _:
          break;
      }
    });
  }

  void dispose() {
    _notificationResponseSubscription?.cancel();
  }
}
