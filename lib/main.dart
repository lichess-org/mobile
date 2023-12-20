import 'dart:convert';
import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'firebase_options.dart';
import 'src/app.dart';
import 'src/constants.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.data}');

  final gameFullId = message.data['lichess.fullId'] as String?;
  final round = message.data['lichess.round'] as String?;

  // update correspondence game
  if (gameFullId != null && round != null) {
    final dbPath = path.join(await getDatabasesPath(), 'lichess_mobile.db');
    final db = await openDb(databaseFactory, dbPath);
    final fullId = GameFullId(gameFullId);
    final game = PlayableGame.fromServerJson(
      jsonDecode(round) as Map<String, dynamic>,
    );
    final corresGame = OfflineCorrespondenceGame(
      id: game.id,
      fullId: fullId,
      rated: game.meta.rated,
      steps: game.steps,
      initialFen: game.initialFen,
      status: game.status,
      variant: game.meta.variant,
      speed: game.speed,
      perf: game.meta.perf,
      white: game.white,
      black: game.black,
      youAre: game.youAre!,
      daysPerTurn: game.meta.daysPerTurn,
      clock: game.correspondenceClock,
      winner: game.winner,
      isThreefoldRepetition: game.isThreefoldRepetition,
    );

    await db.insert(
      kCorrespondenceStorageTable,
      {
        'userId':
            corresGame.me.user?.id.toString() ?? kCorrespondenceStorageAnonId,
        'gameId': corresGame.id.toString(),
        'lastModified': DateTime.now().toIso8601String(),
        'data': jsonEncode(corresGame.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

// to see http requests and websocket connections in terminal since we're not
// always using the browser devtools
const _loggersToShowInTerminal = {
  'AuthClient',
  'LobbyAuthClient',
  'AuthSocket',
};

Future<void> main() async {
  if (kDebugMode) {
    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen((record) {
      developer.log(
        record.message,
        time: record.time,
        name: record.loggerName,
        level: record.level.value,
        error: record.error,
        stackTrace: record.stackTrace,
      );

      if (_loggersToShowInTerminal.contains(record.loggerName) &&
          record.level >= Level.INFO) {
        debugPrint('[${record.loggerName}] ${record.message}');
      }

      if (!_loggersToShowInTerminal.contains(record.loggerName) &&
          record.level >= Level.SEVERE) {
        debugPrint('[${record.loggerName}] ${record.message}');
      }
    });
  }

  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // setup Intl for later use
  await _setupIntl();

  _setupTimeago();

  // Firebase setup
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Crashlytics
  if (kReleaseMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  if (defaultTargetPlatform == TargetPlatform.android) {
    final view = widgetsBinding.platformDispatcher.views.first;
    final data = MediaQueryData.fromView(view);
    if (data.size.shortestSide < kTabletThreshold) {
      await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp],
      );
    }
  }

  runApp(
    ProviderScope(
      observers: [
        ProviderLogger(),
      ],
      child: const LoadingAppScreen(),
    ),
  );
}

Future<void> _setupIntl() async {
  // we need call this because it is not setup automatically
  final systemLocale = await findSystemLocale();
  Intl.defaultLocale = systemLocale;
}

void _setupTimeago() {
  final currentLocale = Intl.getCurrentLocale();
  final longLocale = Intl.canonicalizedLocale(currentLocale);
  final messages = _timeagoLocales[longLocale];
  if (messages != null) {
    timeago.setLocaleMessages(longLocale, messages);
    timeago.setDefaultLocale(longLocale);
  } else {
    final shortLocale = Intl.shortLocale(currentLocale);
    final messages = _timeagoLocales[shortLocale];
    if (messages != null) {
      timeago.setLocaleMessages(shortLocale, messages);
      timeago.setDefaultLocale(shortLocale);
    }
  }
}

final Map<String, timeago.LookupMessages> _timeagoLocales = {
  'am': timeago.AmMessages(),
  'ar': timeago.ArMessages(),
  'az': timeago.AzMessages(),
  'be': timeago.BeMessages(),
  'bs': timeago.BsMessages(),
  'ca': timeago.CaMessages(),
  'cs': timeago.CsMessages(),
  'da': timeago.DaMessages(),
  'de': timeago.DeMessages(),
  'dv': timeago.DvMessages(),
  'en': timeago.EnMessages(),
  'es': timeago.EsMessages(),
  'et': timeago.EtMessages(),
  'fa': timeago.FaMessages(),
  'fi': timeago.FiMessages(),
  'fr': timeago.FrMessages(),
  'gr': timeago.GrMessages(),
  'he': timeago.HeMessages(),
  'hi': timeago.HiMessages(),
  'hr': timeago.HrMessages(),
  'hu': timeago.HuMessages(),
  'id': timeago.IdMessages(),
  'it': timeago.ItMessages(),
  'ja': timeago.JaMessages(),
  'km': timeago.KmMessages(),
  'ko': timeago.KoMessages(),
  'ku': timeago.KuMessages(),
  'lv': timeago.LvMessages(),
  'mn': timeago.MnMessages(),
  'ms_MY': timeago.MsMyMessages(),
  'nb_NO': timeago.NbNoMessages(),
  'nl': timeago.NlMessages(),
  'nn_NO': timeago.NnNoMessages(),
  'pl': timeago.PlMessages(),
  'pt_BR': timeago.PtBrMessages(),
  'ro': timeago.RoMessages(),
  'ru': timeago.RuMessages(),
  'sr': timeago.SrMessages(),
  'sv': timeago.SvMessages(),
  'ta': timeago.TaMessages(),
  'th': timeago.ThMessages(),
  'tk': timeago.TkMessages(),
  'tr': timeago.TrMessages(),
  'uk': timeago.UkMessages(),
  'ur': timeago.UrMessages(),
  'vi': timeago.ViMessages(),
  'zh_CN': timeago.ZhCnMessages(),
  'zh': timeago.ZhMessages(),
};

class ProviderLogger extends ProviderObserver {
  final _logger = Logger('Provider');

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    _logger.info(
      '${provider.name ?? provider.runtimeType} initialized',
      value,
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    _logger.info('${provider.name ?? provider.runtimeType} disposed');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    _logger.severe(
      '${provider.name ?? provider.runtimeType} error',
      error,
      stackTrace,
    );
  }
}
