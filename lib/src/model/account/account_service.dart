import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/binding.dart' show LichessBinding;
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart'
    show LocalNotification, PlaybanNotification;
import 'package:lichess_mobile/src/model/ui_events.dart';
import 'package:lichess_mobile/src/model/user/user.dart' show User;

/// A provider for [AccountService].
final accountServiceProvider = Provider<AccountService>((Ref ref) {
  final service = AccountService(ref);
  ref.onDispose(() {
    service.dispose();
  });
  return service;
}, name: 'AccountServiceProvider');

class AccountService(final Ref _ref) {
  ProviderSubscription<AsyncValue<User?>>? _accountProviderSubscription;
  StreamSubscription<(NotificationResponse, LocalNotification)>? _notificationResponseSubscription;
  Timer? _refreshTimer;

  /// Stream of bookmark changes for the current user.
  final StreamController<(GameId, bool)> _bookmarkChangesController = StreamController.broadcast();

  /// Stream of bookmark changes for the current user.
  Stream<(GameId, bool)> get bookmarkChanges => _bookmarkChangesController.stream;

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
          _ref.emitUiEvent(ShowPlaybanEvent(playban));
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

  Future<void> setGameBookmark(GameId id, {required bool bookmark}) async {
    final authUser = _ref.read(authControllerProvider);
    if (authUser == null) return;

    await _ref.read(accountRepositoryProvider).bookmark(id, bookmark: bookmark);

    _bookmarkChangesController.add((id, bookmark));
  }
}
