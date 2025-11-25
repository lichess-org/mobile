import 'dart:async';

import 'package:flutter/material.dart' show AlertDialog, Navigator, Text, showAdaptiveDialog;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/binding.dart' show LichessBinding;
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart'
    show LocalNotification, PlaybanNotification;
import 'package:lichess_mobile/src/model/user/user.dart' show TemporaryBan, User;
import 'package:lichess_mobile/src/tab_scaffold.dart' show currentNavigatorKeyProvider;
import 'package:lichess_mobile/src/view/play/playban.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';

/// A provider for [AccountService].
final accountServiceProvider = Provider<AccountService>((Ref ref) {
  final service = AccountService(ref);
  ref.onDispose(() {
    service.dispose();
  });
  return service;
}, name: 'AccountServiceProvider');

class AccountService {
  AccountService(this._ref);

  ProviderSubscription<AsyncValue<User?>>? _accountProviderSubscription;
  StreamSubscription<(NotificationResponse, LocalNotification)>? _notificationResponseSubscription;
  Timer? _refreshTimer;

  /// Stream of bookmark changes for the current user.
  final StreamController<(GameId, bool)> _bookmarkChangesController = StreamController.broadcast();

  /// Stream of bookmark changes for the current user.
  Stream<(GameId, bool)> get bookmarkChanges => _bookmarkChangesController.stream;

  final Ref _ref;

  static const _storageKey = 'account.playban_notification_date';

  void start() {
    final prefs = LichessBinding.instance.sharedPreferences;

    _accountProviderSubscription = _ref.listen(accountProvider, (_, account) {
      final playban = account.value?.playban;
      final storedDate = prefs.getString(_storageKey);
      final lastPlaybanNotificationDate = storedDate != null ? DateTime.parse(storedDate) : null;

      if (playban != null && lastPlaybanNotificationDate != playban.date) {
        _savePlaybanNotificationDate(playban.date);
        _ref.read(notificationServiceProvider).show(PlaybanNotification(playban));
        _refreshTimer?.cancel();
        _refreshTimer = Timer(playban.duration, () {
          _ref.invalidate(accountProvider);
        });
      } else if (playban == null && lastPlaybanNotificationDate != null) {
        _refreshTimer?.cancel();
        _ref
            .read(notificationServiceProvider)
            .cancel(lastPlaybanNotificationDate.toIso8601String().hashCode);
        _clearPlaybanNotificationDate();
      }
    });

    _notificationResponseSubscription = NotificationService.responseStream.listen((data) {
      final (_, notification) = data;
      switch (notification) {
        case PlaybanNotification(:final playban):
          showPlaybanDialog(playban);
        case _:
          break;
      }
    });
  }

  void _savePlaybanNotificationDate(DateTime date) {
    LichessBinding.instance.sharedPreferences.setString(_storageKey, date.toIso8601String());
  }

  void _clearPlaybanNotificationDate() {
    LichessBinding.instance.sharedPreferences.remove(_storageKey);
  }

  void dispose() {
    _refreshTimer?.cancel();
    _accountProviderSubscription?.close();
    _notificationResponseSubscription?.cancel();
    _bookmarkChangesController.close();
  }

  Future<void> showPlaybanDialog(TemporaryBan playban) async {
    final context = _ref.read(currentNavigatorKeyProvider).currentContext;
    if (context == null || !context.mounted) return;

    return showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog.adaptive(
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
    final authUser = _ref.read(authControllerProvider);
    if (authUser == null) return;

    await _ref.read(accountRepositoryProvider).bookmark(id, bookmark: bookmark);

    _bookmarkChangesController.add((id, bookmark));
  }
}
