import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/l10n/l10n_en.dart';
import 'package:lichess_mobile/src/model/notifications/local_notification_service.dart';

class InfoNotificationDetails {
  InfoNotificationDetails(this._l10n) {
    InfoNotificationDetails.instance = this;
  }

  // the default instance is set to english but this is overridden in LocalNotificationService.init()
  static InfoNotificationDetails instance =
      InfoNotificationDetails(AppLocalizationsEn());

  // ignore: unused_field
  final AppLocalizations _l10n;

  NotificationDetails get notificationDetails => const NotificationDetails(
        android: AndroidNotificationDetails(
          'general',
          'General',
          importance: Importance.high,
          priority: Priority.high,
        ),
      );
}

class InfoNotification extends LocalNotification {
  InfoNotification(String title, {super.body})
      : super(title, InfoNotificationDetails.instance.notificationDetails);

  @override
  int get id => hashCode;
}
