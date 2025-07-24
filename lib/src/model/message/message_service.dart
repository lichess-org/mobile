import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/message/message_repository.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/model/user/user_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/view/message/conversation_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_service.g.dart';

@Riverpod(keepAlive: true)
MessageService messageService(Ref ref) {
  final service = MessageService(ref);
  ref.onDispose(service.dispose);
  return service;
}

class MessageService {
  MessageService(this.ref);

  final Ref ref;

  StreamSubscription<ParsedLocalNotification>? _notificationResponseSubscription;
  StreamSubscription<ReceivedFcmMessage>? _fcmSubscription;

  void start() {
    _fcmSubscription = NotificationService.fcmMessageStream.listen((data) {
      final (message: fcmMessage, fromBackground: fromBackground) = data;
      switch (fcmMessage) {
        case NewMessageFcmMessage():
          ref.invalidate(contactsProvider);
        case _:
          break;
      }
    });

    _notificationResponseSubscription = NotificationService.responseStream.listen((data) {
      final (_, notification) = data;
      switch (notification) {
        case NewMessageNotification(:final conversationId):
          _onNotificationResponse(conversationId);
        case _:
          break;
      }
    });
  }

  /// Handles a notification response that caused the app to open.
  Future<void> _onNotificationResponse(UserId conversationId) async {
    final user = await ref.withClient((client) => UserRepository(client).getUser(conversationId));

    final context = ref.read(currentNavigatorKeyProvider).currentContext;
    if (context == null || !context.mounted) return;

    final rootNavState = Navigator.of(context, rootNavigator: true);
    if (rootNavState.canPop()) {
      rootNavState.popUntil((route) => route.isFirst);
    }

    Navigator.of(
      context,
      rootNavigator: true,
    ).push(ConversationScreen.buildRoute(context, user: user.lightUser));
  }

  void dispose() {
    _fcmSubscription?.cancel();
    _notificationResponseSubscription?.cancel();
  }
}
