import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/network/socket.dart';

final announceServiceProvider = Provider<AnnounceService>((ref) {
  final service = AnnounceService(ref);
  ref.onDispose(service._dispose);
  return service;
});

class AnnounceService {
  AnnounceService(this._ref);

  final Ref _ref;

  StreamSubscription<SocketEvent>? _socketSubscription;
  StreamSubscription<ParsedLocalNotification>? _responseSubscription;
  Timer? _dismissTimer;

  void start() {
    _socketSubscription = socketGlobalStream.listen(_handleSocketEvent);
    _responseSubscription = NotificationService.responseStream.listen(_handleNotificationResponse);
  }

  void _dispose() {
    _socketSubscription?.cancel();
    _responseSubscription?.cancel();
    _dismissTimer?.cancel();
  }

  void _handleNotificationResponse(ParsedLocalNotification event) {
    final (response, notification) = event;
    if (notification is AnnounceNotification &&
        response.actionId == AnnounceNotification.dismissActionId) {
      _cancelAnnounce();
    }
  }

  void _handleSocketEvent(SocketEvent event) {
    if (event.topic != 'announce') return;

    final data = event.data;
    if (data == null || data is! Map<String, dynamic> || data.isEmpty) {
      _cancelAnnounce();
      return;
    }

    final msg = data['msg'] as String?;
    if (msg == null || msg.isEmpty) {
      _cancelAnnounce();
      return;
    }

    final dateStr = data['date'] as String?;
    final date = dateStr != null ? DateTime.tryParse(dateStr) : null;

    _dismissTimer?.cancel();
    _dismissTimer = null;

    if (date != null) {
      final remaining = date.difference(DateTime.now());
      if (remaining.isNegative) {
        _cancelAnnounce();
        return;
      }
      _dismissTimer = Timer(remaining, _cancelAnnounce);
    }

    _ref.read(notificationServiceProvider).show(AnnounceNotification(msg, date: date));
  }

  void _cancelAnnounce() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _ref.read(notificationServiceProvider).cancel(AnnounceNotification.notificationId);
  }
}
