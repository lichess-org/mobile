import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart' as home_widget;
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/localizations.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';

const kQuickPairingHomeWidgetKind = 'QuickPairingHomeWidget';
const kQuickPairingHomeWidgetAndroidName = 'QuickPairingHomeWidgetReceiver';
const kQuickPairingHomeWidgetQualifiedAndroidName =
    'org.lichess.mobileV2.homewidget.QuickPairingHomeWidgetReceiver';
const kQuickPairingHomeWidgetAppGroupId = 'group.org.lichess.mobileV2.homewidget';
const kQuickPairingHomeWidgetLaunchUri =
    'org.lichess.mobile://home-widget/start-last-pairing?homeWidget=1';

const kQuickPairingHomeWidgetTitleKey = 'widget_title';
const kQuickPairingHomeWidgetPrimaryTextKey = 'widget_primary_text';
const kQuickPairingHomeWidgetSecondaryTextKey = 'widget_secondary_text';
const kQuickPairingHomeWidgetLaunchUriKey = 'widget_launch_uri';

const _kQuickPairingFallbackTimeIncrement = TimeIncrement(300, 0);

typedef QuickPairingHomeWidgetText = ({String title, String primaryText, String secondaryText});

final homeWidgetClientProvider = Provider<HomeWidgetClient>((ref) {
  return const HomeWidgetPluginClient();
});

final homeWidgetServiceProvider = Provider<HomeWidgetService>((ref) {
  final service = HomeWidgetService(ref, ref.read(homeWidgetClientProvider));

  ref.listen<RecentGameSeekPrefs>(recentGameSeekProvider, (previous, next) {
    if (previous?.seeks == next.seeks) return;
    unawaited(service.syncWidgetData());
  });
  ref.listen<AuthUser?>(authControllerProvider, (previous, next) {
    if (previous == next) return;
    unawaited(service.syncWidgetData());
  });
  ref.listen<ActiveLocalizations>(localizationsProvider, (previous, next) {
    if (previous?.locale == next.locale) return;
    unawaited(service.syncWidgetData());
  });
  ref.onDispose(() {
    unawaited(service.dispose());
  });

  return service;
});

bool isQuickPairingHomeWidgetUri(Uri? uri) {
  if (uri == null) return false;

  return uri.scheme == 'org.lichess.mobile' &&
      uri.host == 'home-widget' &&
      uri.pathSegments.length == 1 &&
      uri.pathSegments.first == 'start-last-pairing' &&
      uri.queryParameters.containsKey('homeWidget');
}

GameSeek resolveQuickPairingHomeWidgetSeek({
  required RecentGameSeekPrefs recentGameSeekPrefs,
  required AuthUser? authUser,
}) {
  final seek = recentGameSeekPrefs.seeks.isNotEmpty
      ? recentGameSeekPrefs.seeks.first
      : GameSeek.fastPairing(_kQuickPairingFallbackTimeIncrement, authUser);

  if (authUser == null && seek.rated) {
    return seek.copyWith(rated: false);
  }

  return seek;
}

QuickPairingHomeWidgetText formatQuickPairingHomeWidgetText(AppLocalizations l10n, GameSeek seek) {
  final timeControl = seek.timeIncrement?.display ?? _kQuickPairingFallbackTimeIncrement.display;
  final secondaryParts = <String>[
    if (seek.rated) l10n.rated else l10n.casual,
    if (seek.variant != null && seek.variant != Variant.standard)
      Perf.fromVariantAndSpeed(
        seek.variant!,
        seek.timeIncrement != null ? Speed.fromTimeIncrement(seek.timeIncrement!) : Speed.blitz,
      ).shortTitle,
  ];

  return (
    title: l10n.quickPairing,
    primaryText: timeControl,
    secondaryText: secondaryParts.join(' • '),
  );
}

abstract interface class HomeWidgetClient {
  Stream<Uri?> get widgetClicked;

  Future<Uri?> initiallyLaunchedFromHomeWidget();

  Future<bool?> saveWidgetData(String id, Object? data);

  Future<bool?> updateWidget({
    String? name,
    String? androidName,
    String? iOSName,
    String? qualifiedAndroidName,
  });
}

class HomeWidgetPluginClient implements HomeWidgetClient {
  const HomeWidgetPluginClient();

  @override
  Stream<Uri?> get widgetClicked => home_widget.HomeWidget.widgetClicked;

  @override
  Future<Uri?> initiallyLaunchedFromHomeWidget() {
    return home_widget.HomeWidget.initiallyLaunchedFromHomeWidget();
  }

  @override
  Future<bool?> saveWidgetData(String id, Object? data) {
    return home_widget.HomeWidget.saveWidgetData(id, data);
  }

  @override
  Future<bool?> updateWidget({
    String? name,
    String? androidName,
    String? iOSName,
    String? qualifiedAndroidName,
  }) {
    return home_widget.HomeWidget.updateWidget(
      name: name,
      androidName: androidName,
      iOSName: iOSName,
      qualifiedAndroidName: qualifiedAndroidName,
    );
  }
}

class HomeWidgetService {
  HomeWidgetService(this.ref, this._client);

  final Ref ref;
  final HomeWidgetClient _client;

  StreamSubscription<Uri?>? _widgetClickSubscription;
  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    _widgetClickSubscription = _client.widgetClicked.listen(_handleWidgetLaunchUri);

    await syncWidgetData();

    _handleWidgetLaunchUri(await _client.initiallyLaunchedFromHomeWidget());
  }

  Future<void> syncWidgetData() async {
    final payload = _buildWidgetPayload();

    await _client.saveWidgetData(kQuickPairingHomeWidgetTitleKey, payload.title);
    await _client.saveWidgetData(kQuickPairingHomeWidgetPrimaryTextKey, payload.primaryText);
    await _client.saveWidgetData(kQuickPairingHomeWidgetSecondaryTextKey, payload.secondaryText);
    await _client.saveWidgetData(
      kQuickPairingHomeWidgetLaunchUriKey,
      kQuickPairingHomeWidgetLaunchUri,
    );

    await _client.updateWidget(
      name: kQuickPairingHomeWidgetKind,
      androidName: kQuickPairingHomeWidgetAndroidName,
      iOSName: kQuickPairingHomeWidgetKind,
      qualifiedAndroidName: kQuickPairingHomeWidgetQualifiedAndroidName,
    );
  }

  Future<void> dispose() async {
    await _widgetClickSubscription?.cancel();
  }

  QuickPairingHomeWidgetText _buildWidgetPayload() {
    final authUser = ref.read(authControllerProvider);
    final recentGameSeekPrefs = ref.read(recentGameSeekProvider);
    final seek = resolveQuickPairingHomeWidgetSeek(
      recentGameSeekPrefs: recentGameSeekPrefs,
      authUser: authUser,
    );

    return formatQuickPairingHomeWidgetText(ref.read(localizationsProvider).strings, seek);
  }

  void _handleWidgetLaunchUri(Uri? uri) {
    if (!isQuickPairingHomeWidgetUri(uri)) return;
    _pushQuickPairingRoute();
  }

  void _pushQuickPairingRoute([int attempt = 0]) {
    final context = ref.read(currentNavigatorKeyProvider).currentContext;

    if (context == null || !context.mounted) {
      if (attempt >= 10) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pushQuickPairingRoute(attempt + 1);
      });
      return;
    }

    final authUser = ref.read(authControllerProvider);
    final seek = resolveQuickPairingHomeWidgetSeek(
      recentGameSeekPrefs: ref.read(recentGameSeekProvider),
      authUser: authUser,
    );

    Navigator.of(
      context,
      rootNavigator: true,
    ).push(GameScreen.buildRoute(context, source: LobbySource(seek)));
  }
}
