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

/// Taken from https://github.com/lichess-org/lila/blob/master/modules/i18n/src/main/LangList.scala
///
/// Not all of these are actually supported in the app currently, but this way we won't have to check the lila code again when we add more languages.
String localeToLocalizedName(Locale locale) => switch (locale) {
      Locale(languageCode: 'en', countryCode: 'GB') => 'English',
      Locale(languageCode: 'af', countryCode: 'ZA') => 'Afrikaans',
      Locale(languageCode: 'an', countryCode: 'ES') => 'Aragonés',
      Locale(languageCode: 'ar', countryCode: 'SA') => 'العربية',
      Locale(languageCode: 'as', countryCode: 'IN') => 'অসমীয়া',
      Locale(languageCode: 'av', countryCode: 'DA') => 'авар мацӀ',
      Locale(languageCode: 'az', countryCode: 'AZ') => 'Azərbaycanca',
      Locale(languageCode: 'be', countryCode: 'BY') => 'Беларуская',
      Locale(languageCode: 'bg', countryCode: 'BG') => 'български език',
      Locale(languageCode: 'bn', countryCode: 'BD') => 'বাংলা',
      Locale(languageCode: 'br', countryCode: 'FR') => 'Brezhoneg',
      Locale(languageCode: 'bs', countryCode: 'BA') => 'Bosanski',
      Locale(languageCode: 'ca', countryCode: 'ES') => 'Català, valencià',
      Locale(languageCode: 'ckb', countryCode: 'IR') => 'کوردی سۆرانی',
      Locale(languageCode: 'co', countryCode: 'FR') => 'Corsu',
      Locale(languageCode: 'cs', countryCode: 'CZ') => 'Čeština',
      Locale(languageCode: 'cv', countryCode: 'CU') => 'чӑваш чӗлхи',
      Locale(languageCode: 'cy', countryCode: 'GB') => 'Cymraeg',
      Locale(languageCode: 'da', countryCode: 'DK') => 'Dansk',
      Locale(languageCode: 'de', countryCode: 'DE') => 'Deutsch',
      Locale(languageCode: 'el', countryCode: 'GR') => 'Ελληνικά',
      Locale(languageCode: 'en', countryCode: 'US') => 'English (US)',
      Locale(languageCode: 'eo', countryCode: 'UY') => 'Esperanto',
      Locale(languageCode: 'es', countryCode: 'ES') => 'Español',
      Locale(languageCode: 'et', countryCode: 'EE') => 'Eesti keel',
      Locale(languageCode: 'eu', countryCode: 'ES') => 'Euskara',
      Locale(languageCode: 'fa', countryCode: 'IR') => 'فارسی',
      Locale(languageCode: 'fi', countryCode: 'FI') => 'Suomen kieli',
      Locale(languageCode: 'fo', countryCode: 'FO') => 'Føroyskt',
      Locale(languageCode: 'fr', countryCode: 'FR') => 'Français',
      Locale(languageCode: 'frp', countryCode: 'IT') => 'Arpitan',
      Locale(languageCode: 'fy', countryCode: 'NL') => 'Frysk',
      Locale(languageCode: 'ga', countryCode: 'IE') => 'Gaeilge',
      Locale(languageCode: 'gd', countryCode: 'GB') => 'Gàidhlig',
      Locale(languageCode: 'gl', countryCode: 'ES') => 'Galego',
      Locale(languageCode: 'gsw', countryCode: 'CH') => 'Schwizerdütsch',
      Locale(languageCode: 'gu', countryCode: 'IN') => 'ગુજરાતી',
      Locale(languageCode: 'he', countryCode: 'IL') => 'עִבְרִית',
      Locale(languageCode: 'hi', countryCode: 'IN') => 'हिन्दी, हिंदी',
      Locale(languageCode: 'hr', countryCode: 'HR') => 'Hrvatski',
      Locale(languageCode: 'hu', countryCode: 'HU') => 'Magyar',
      Locale(languageCode: 'hy', countryCode: 'AM') => 'Հայերեն',
      Locale(languageCode: 'ia', countryCode: 'IA') => 'Interlingua',
      Locale(languageCode: 'id', countryCode: 'ID') => 'Bahasa Indonesia',
      Locale(languageCode: 'io', countryCode: 'EN') => 'Ido',
      Locale(languageCode: 'is', countryCode: 'IS') => 'Íslenska',
      Locale(languageCode: 'it', countryCode: 'IT') => 'Italiano',
      Locale(languageCode: 'ja', countryCode: 'JP') => '日本語',
      Locale(languageCode: 'jbo', countryCode: 'EN') => 'Lojban',
      Locale(languageCode: 'jv', countryCode: 'ID') => 'Basa Jawa',
      Locale(languageCode: 'ka', countryCode: 'GE') => 'ქართული',
      Locale(languageCode: 'kab', countryCode: 'DZ') => 'Taqvaylit',
      Locale(languageCode: 'kk', countryCode: 'KZ') => 'қазақша',
      Locale(languageCode: 'kmr', countryCode: 'TR') => 'Kurdî (Kurmancî)',
      Locale(languageCode: 'kn', countryCode: 'IN') => 'ಕನ್ನಡ',
      Locale(languageCode: 'ko', countryCode: 'KR') => '한국어',
      Locale(languageCode: 'ky', countryCode: 'KG') => 'кыргызча',
      Locale(languageCode: 'la', countryCode: 'LA') => 'Lingua Latina',
      Locale(languageCode: 'lb', countryCode: 'LU') => 'Lëtzebuergesch',
      Locale(languageCode: 'lt', countryCode: 'LT') => 'Lietuvių kalba',
      Locale(languageCode: 'lv', countryCode: 'LV') => 'Latviešu valoda',
      Locale(languageCode: 'mg', countryCode: 'MG') => 'Fiteny malagasy',
      Locale(languageCode: 'mk', countryCode: 'MK') => 'македонски јази',
      Locale(languageCode: 'ml', countryCode: 'IN') => 'മലയാളം',
      Locale(languageCode: 'mn', countryCode: 'MN') => 'монгол',
      Locale(languageCode: 'mr', countryCode: 'IN') => 'मराठी',
      Locale(languageCode: 'nb', countryCode: 'NO') => 'Norsk bokmål',
      Locale(languageCode: 'ne', countryCode: 'NP') => 'नेपाली',
      Locale(languageCode: 'nl', countryCode: 'NL') => 'Nederlands',
      Locale(languageCode: 'nn', countryCode: 'NO') => 'Norsk nynorsk',
      Locale(languageCode: 'pi', countryCode: 'IN') => 'पालि',
      Locale(languageCode: 'pl', countryCode: 'PL') => 'Polski',
      Locale(languageCode: 'ps', countryCode: 'AF') => 'پښتو',
      Locale(languageCode: 'pt', countryCode: 'PT') => 'Português',
      Locale(languageCode: 'pt', countryCode: 'BR') => 'Português (BR)',
      Locale(languageCode: 'ro', countryCode: 'RO') => 'Română',
      Locale(languageCode: 'ru', countryCode: 'RU') => 'русский язык',
      Locale(languageCode: 'ry', countryCode: 'UA') => 'Русинська бисїда',
      Locale(languageCode: 'sa', countryCode: 'IN') => 'संस्कृत',
      Locale(languageCode: 'sk', countryCode: 'SK') => 'Slovenčina',
      Locale(languageCode: 'sl', countryCode: 'SI') => 'Slovenščina',
      Locale(languageCode: 'so', countryCode: 'SO') => 'Af Soomaali',
      Locale(languageCode: 'sq', countryCode: 'AL') => 'Shqip',
      Locale(languageCode: 'sr', countryCode: 'SP') => 'Српски језик',
      Locale(languageCode: 'sv', countryCode: 'SE') => 'Svenska',
      Locale(languageCode: 'sw', countryCode: 'KE') => 'Kiswahili',
      Locale(languageCode: 'ta', countryCode: 'IN') => 'தமிழ்',
      Locale(languageCode: 'tg', countryCode: 'TJ') => 'тоҷикӣ',
      Locale(languageCode: 'th', countryCode: 'TH') => 'ไทย',
      Locale(languageCode: 'tk', countryCode: 'TM') => 'Türkmençe',
      Locale(languageCode: 'tl', countryCode: 'PH') => 'Tagalog',
      Locale(languageCode: 'tp', countryCode: 'TP') => 'Toki pona',
      Locale(languageCode: 'tr', countryCode: 'TR') => 'Türkçe',
      Locale(languageCode: 'uk', countryCode: 'UA') => 'українська',
      Locale(languageCode: 'ur', countryCode: 'PK') => 'اُردُو',
      Locale(languageCode: 'uz', countryCode: 'UZ') => 'oʻzbekcha',
      Locale(languageCode: 'vi', countryCode: 'VN') => 'Tiếng Việt',
      Locale(languageCode: 'yo', countryCode: 'NG') => 'Yorùbá',
      Locale(languageCode: 'zh', countryCode: 'CN') => '中文',
      Locale(languageCode: 'zh', countryCode: 'TW') => '繁體中文',
      Locale(languageCode: 'zu', countryCode: 'ZA') => 'isiZulu',
      _ => locale.toString(),
    };
