import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lichess_mobile/firebase_options.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';

/// The glue between some platform-specific plugins and the app.
///
/// Only one instance of this class will be created during the app's lifetime.
/// See [AppLichessBinding] for the concrete implementation.
///
/// Modeled after the Flutter framework's [WidgetsBinding] class.
///
/// The preferred way to mock or fake a plugin or external API is to create a
/// provider with riverpod because it gives more flexibility and control over
/// the behavior of the fake.
/// However, if the plugin is used in a way that doesn't allow for easy mocking
///with riverpod, a binding can be used to provide a fake implementation.
abstract class LichessBinding {
  LichessBinding() : assert(_instance == null) {
    initInstance();
  }

  /// The single instance of [LichessBinding].
  static LichessBinding get instance => checkInstance(_instance);
  static LichessBinding? _instance;

  @protected
  @mustCallSuper
  void initInstance() {
    _instance = this;
  }

  static T checkInstance<T extends LichessBinding>(T? instance) {
    assert(() {
      if (instance == null) {
        throw FlutterError.fromParts([
          ErrorSummary('Lichess binding has not yet been initialized.'),
          ErrorHint(
            'In the app, this is done by the `AppLichessBinding.ensureInitialized()` call '
            'in the `void main()` method.',
          ),
          ErrorHint(
            'In a test, one can call `TestLichessBinding.ensureInitialized()` as the '
            "first line in the test's `main()` method to initialize the binding.",
          ),
        ]);
      }
      return true;
    }());
    return instance!;
  }

  /// Initialize notifications.
  ///
  /// This wraps [Firebase.initializeApp] and [FlutterLocalNotificationsPlugin.initialize].
  ///
  /// This should be called only once before the app starts.
  Future<void> initializeNotifications(Locale locale);

  /// Wraps [FirebaseMessaging.instance].
  FirebaseMessaging get firebaseMessaging;

  /// Wraps [FirebaseMessaging.onMessage].
  Stream<RemoteMessage> get firebaseMessagingOnMessage;

  /// Wraps [FirebaseMessaging.onMessageOpenedApp].
  Stream<RemoteMessage> get firebaseMessagingOnMessageOpenedApp;

  /// Wraps [FirebaseMessaging.onBackgroundMessage].
  void firebaseMessagingOnBackgroundMessage(BackgroundMessageHandler handler);
}

/// A concrete implementation of [LichessBinding] for the app.
class AppLichessBinding extends LichessBinding {
  AppLichessBinding();

  /// Returns an instance of the binding that implements [LichessBinding].
  ///
  /// If no binding has yet been initialized, the [AppLichessBinding] class is
  /// used to create and initialize one.
  factory AppLichessBinding.ensureInitialized() {
    if (LichessBinding._instance == null) {
      AppLichessBinding();
    }
    return LichessBinding.instance as AppLichessBinding;
  }

  @override
  Future<void> initializeNotifications(Locale locale) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final l10n = await AppLocalizations.delegate.load(locale);
    await FlutterLocalNotificationsPlugin().initialize(
      InitializationSettings(
        android: const AndroidInitializationSettings('logo_black'),
        iOS: DarwinInitializationSettings(
          requestBadgePermission: false,
          notificationCategories: <DarwinNotificationCategory>[
            ChallengeNotification.darwinPlayableVariantCategory(l10n),
            ChallengeNotification.darwinUnplayableVariantCategory(l10n),
          ],
        ),
      ),
      onDidReceiveNotificationResponse:
          NotificationService.onDidReceiveNotificationResponse,
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  @override
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  @override
  void firebaseMessagingOnBackgroundMessage(BackgroundMessageHandler handler) {
    FirebaseMessaging.onBackgroundMessage(handler);
  }

  @override
  Stream<RemoteMessage> get firebaseMessagingOnMessage =>
      FirebaseMessaging.onMessage;

  @override
  Stream<RemoteMessage> get firebaseMessagingOnMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;
}
