import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/l10n/l10n_en.dart';
import 'package:lichess_mobile/src/model/notifications/local_notification_service.dart';

class InfoNotificationDetails {
  InfoNotificationDetails(this._locale) {
    InfoNotificationDetails.instance = this;
  }

  // the default instance is set to english but this is overridden in LocalNotificationService.init()
  static InfoNotificationDetails instance =
      InfoNotificationDetails(AppLocalizationsEn());

  // ignore: unused_field
  final AppLocalizations _locale;

  NotificationDetails get notificationDetails => const NotificationDetails(
        android: AndroidNotificationDetails(
          'general',
          'General',
          importance: Importance.high,
          priority: Priority.high,
        ),
      );
}

class InfoNotification {
  InfoNotification();

  LocalNotification build(String title, {String? body}) {
    return LocalNotification(
      title: title,
      body: body,
      notificationDetails: InfoNotificationDetails.instance.notificationDetails,
    );
  }
}
