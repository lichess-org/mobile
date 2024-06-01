import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const kLichessHost = String.fromEnvironment(
  'LICHESS_HOST',
  defaultValue: 'localhost:9663',
);

const kLichessWSHost = String.fromEnvironment(
  'LICHESS_WS_HOST',
  defaultValue: 'localhost:9664',
);

const kLichessWSSecret = String.fromEnvironment(
  'LICHESS_WS_SECRET',
  defaultValue: 'somethingElseInProd',
);

const kLichessCDNHost = String.fromEnvironment(
  'LICHESS_CDN_HOST',
  defaultValue: 'https://lichess1.org',
);

const kLichessDevUser =
    String.fromEnvironment('LICHESS_DEV_USER', defaultValue: 'lichess');
const kLichessDevPassword = String.fromEnvironment('LICHESS_DEV_PASSWORD');

const kLichessClientId = 'lichess_mobile';

// lichess
// https://github.com/lichess-org/lila/blob/4562a83cdb263c3ebf7e148c0f666f0ff92b91c7/modules/rating/src/main/Glicko.scala#L71
const kProvisionalDeviation = 110;
const kClueLessDeviation = 230;

// UI

/// Flex golden ratio base (flex has to be an int).
const kFlexGoldenRatioBase = 100000000000;

/// Flex golden ratio (flex has to be an int).
const kFlexGoldenRatio = 161803398875;

/// Use same box shadows as material widgets with elevation 1.
final List<BoxShadow> boardShadows = defaultTargetPlatform == TargetPlatform.iOS
    ? <BoxShadow>[]
    : kElevationToShadow[1]!;

const kCardTextScaleFactor = 1.64;
const kMaxClockTextScaleFactor = 1.94;
const kEmptyWidget = SizedBox.shrink();
const kEmptyFen = '8/8/8/8/8/8/8/8 w - - 0 1';
const kInitialFen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
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

// locales
const kSupportedLocales = [
  Locale('af', ''),
  Locale('ar', ''),
  Locale('az', ''),
  Locale('be', ''),
  Locale('bg', ''),
  Locale('bn', ''),
  Locale('br', ''),
  Locale('bs', ''),
  Locale('ca', ''),
  Locale('cs', ''),
  Locale('da', ''),
  Locale('de', ''),
  Locale('de', 'CH'),
  Locale('el', ''),
  Locale('en', ''),
  Locale('en', 'GB'),
  Locale('en', 'US'),
  Locale('eo', ''),
  Locale('es', ''),
  Locale('et', ''),
  Locale('eu', ''),
  Locale('fa', ''),
  Locale('fi', ''),
  Locale('fo', ''),
  Locale('fr', ''),
  Locale('ga', ''),
  Locale('gl', ''),
  Locale('he', ''),
  Locale('hi', ''),
  Locale('hr', ''),
  Locale('hu', ''),
  Locale('hy', ''),
  Locale('id', ''),
  Locale('it', ''),
  Locale('ja', ''),
  Locale('kk', ''),
  Locale('ko', ''),
  Locale('lb', ''),
  Locale('lt', ''),
  Locale('lv', ''),
  Locale('mk', ''),
  Locale('nb', ''),
  Locale('nl', ''),
  Locale('nn', ''),
  Locale('pl', ''),
  Locale('pt', ''),
  Locale('pt', 'BR'),
  Locale('ro', ''),
  Locale('ru', ''),
  Locale('sk', ''),
  Locale('sl', ''),
  Locale('sq', ''),
  Locale('sr', ''),
  Locale('sv', ''),
  Locale('tr', ''),
  Locale('tt', ''),
  Locale('uk', ''),
  Locale('vi', ''),
  Locale('zh', ''),
  Locale('zh', 'CN'),
  Locale('zh', 'TW'),
];
