import 'package:flutter/material.dart' show Navigator, Text, showAdaptiveDialog;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart' show PlaybanNotification;
import 'package:lichess_mobile/src/model/user/user.dart' show TemporaryBan, User;
import 'package:lichess_mobile/src/navigation.dart' show currentNavigatorKeyProvider;
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/play/playban.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_service.g.dart';

@Riverpod(keepAlive: true)
AccountService accountService(Ref ref) {
  final service = AccountService(ref);
  ref.onDispose(() {
    service.dispose();
  });
  return service;
}

class AccountService {
  AccountService(this._ref);

  ProviderSubscription<AsyncValue<User?>>? _subscription;
  DateTime? _lastPlaybanNotificationDate;
  final Ref _ref;

  void start() {
    _subscription = _ref.listen(accountProvider, (_, account) {
      final playban = account.valueOrNull?.playban;

      // TODO save date in prefs

      if (playban != null && _lastPlaybanNotificationDate != playban.date) {
        _lastPlaybanNotificationDate = playban.date;
        _ref.read(notificationServiceProvider).show(PlaybanNotification(playban));
      } else if (playban == null && _lastPlaybanNotificationDate != null) {
        _ref
            .read(notificationServiceProvider)
            .cancel(_lastPlaybanNotificationDate!.toIso8601String().hashCode);
        _lastPlaybanNotificationDate = null;
      }
    });
  }

  void dispose() {
    _subscription?.close();
  }

  Future<void> onPlaybanNotificationResponse(TemporaryBan playban) async {
    final context = _ref.read(currentNavigatorKeyProvider).currentContext;
    if (context == null || !context.mounted) return;

    return showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return PlatformAlertDialog(
          content: PlaybanMessage(playban: playban, centerText: true),
          actions: [
            PlatformDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> setGameBookmark(GameId id, {required bool bookmark}) async {
    final session = _ref.read(authSessionProvider);
    if (session == null) return;

    await _ref.withClient((client) => AccountRepository(client).bookmark(id, bookmark: bookmark));

    _ref.invalidate(accountProvider);
  }
}
