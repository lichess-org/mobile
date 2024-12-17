import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const kLichessHost = String.fromEnvironment('LICHESS_HOST', defaultValue: 'lichess.dev');

const kLichessWSHost = String.fromEnvironment(
  'LICHESS_WS_HOST',
  defaultValue: 'socket.lichess.dev',
);

const kLichessWSSecret = String.fromEnvironment(
  'LICHESS_WS_SECRET',
  defaultValue: 'somethingElseInProd',
);

const kLichessCDNHost = String.fromEnvironment(
  'LICHESS_CDN_HOST',
  defaultValue: 'https://lichess1.org',
);

const kLichessOpeningExplorerHost = String.fromEnvironment(
  'LICHESS_OPENING_EXPLORER_HOST',
  defaultValue: 'explorer.lichess.ovh',
);

const kLichessDevUser = String.fromEnvironment('LICHESS_DEV_USER', defaultValue: 'lichess');
const kLichessDevPassword = String.fromEnvironment('LICHESS_DEV_PASSWORD');

const kLichessClientId = 'lichess_mobile';

const kSRIStorageKey = 'socket_random_identifier';

// lichess
// https://github.com/lichess-org/lila/blob/4562a83cdb263c3ebf7e148c0f666f0ff92b91c7/modules/rating/src/main/Glicko.scala#L71
const kProvisionalDeviation = 110;
const kClueLessDeviation = 230;

// UI

const kDefaultSeedColor = Color(0xFFD64F00);

const kGoldenRatio = 1.61803398875;

/// Flex golden ratio base (flex has to be an int).
const kFlexGoldenRatioBase = 100000000000;

/// Flex golden ratio (flex has to be an int).
const kFlexGoldenRatio = 161803398875;

/// Use same box shadows as material widgets with elevation 1.
final List<BoxShadow> boardShadows =
    defaultTargetPlatform == TargetPlatform.iOS ? <BoxShadow>[] : kElevationToShadow[1]!;

const kCardTextScaleFactor = 1.64;
const kCardBorderRadius = BorderRadius.all(Radius.circular(10.0));
const kMaxClockTextScaleFactor = 1.94;
const kEmptyWidget = SizedBox.shrink();
const kEmptyFen = '8/8/8/8/8/8/8/8 w - - 0 1';
const kTabletBoardTableSidePadding = 16.0;
const kBottomBarHeight = 56.0;
const kMaterialPopupMenuMaxWidth = 500.0;

/// The threshold to detect screens with a small remaining height left board.
const kSmallRemainingHeightLeftBoardThreshold = 160;

// annotations
class _AllowedWidgetReturn {
  const _AllowedWidgetReturn();
}

/// Use to annotate a function that is allowed to return a Widget
const allowedWidgetReturn = _AllowedWidgetReturn();

/// Supported locales for the app.
///
/// This is passed to the [MaterialApp] widget.
/// The first locale in the list will be used as the default locale.
///
/// See: https://api.flutter.dev/flutter/material/MaterialApp/supportedLocales.html
const kSupportedLocales = [
  // English is the default locale.
  Locale('en', 'GB'),
  Locale('af', 'ZA'),
  Locale('ar', 'SA'),
  Locale('az', 'AZ'),
  Locale('be', 'BY'),
  Locale('bg', 'BG'),
  Locale('bn', 'BD'),
  Locale('br', 'FR'),
  Locale('bs', 'BA'),
  Locale('ca', 'ES'),
  Locale('cs', 'CZ'),
  Locale('da', 'DK'),
  Locale('de', 'DE'),
  Locale('el', 'GR'),
  Locale('en', 'US'),
  Locale('eo', 'UY'),
  Locale('es', 'ES'),
  Locale('et', 'EE'),
  Locale('eu', 'ES'),
  Locale('fa', 'IR'),
  Locale('fi', 'FI'),
  Locale('fo', 'FO'),
  Locale('fr', 'FR'),
  Locale('ga', 'IE'),
  Locale('gl', 'ES'),
  Locale('gsw', 'CH'),
  Locale('he', 'IL'),
  Locale('hi', 'IN'),
  Locale('hr', 'HR'),
  Locale('hu', 'HU'),
  Locale('hy', 'AM'),
  Locale('id', 'ID'),
  Locale('it', 'IT'),
  Locale('ja', 'JP'),
  Locale('kk', 'KZ'),
  Locale('ko', 'KR'),
  Locale('lb', 'LU'),
  Locale('lt', 'LT'),
  Locale('lv', 'LV'),
  Locale('mk', 'MK'),
  Locale('nb', 'NO'),
  Locale('nl', 'NL'),
  Locale('nn', 'NO'),
  Locale('pl', 'PL'),
  Locale('pt', 'PT'),
  Locale('pt', 'BR'),
  Locale('ro', 'RO'),
  Locale('ru', 'RU'),
  Locale('sk', 'SK'),
  Locale('sl', 'SI'),
  Locale('sq', 'AL'),
  Locale('sr', 'SP'),
  Locale('sv', 'SE'),
  Locale('tr', 'TR'),
  Locale('uk', 'UA'),
  Locale('vi', 'VN'),
  Locale('zh', 'CN'),
  Locale('zh', 'TW'),
];
