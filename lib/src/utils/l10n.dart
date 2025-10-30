import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/l10n/l10n.dart';

/// Returns a localized string with a single placeholder replaced by a widget.
///
/// The [textStyle] parameter can be used to style the displayed text parts of the localized string.
///
/// For example:
/// ```dart
/// String translationFun(String name) {
///   return 'Hello, ${name}!';
/// }
/// // returns a text widget containing MyFancyWidget('Magnus') in place of the placeholder
/// l10nWithWidget(translationFun, MyFancyWidget('Magnus'));
/// ```
Text l10nWithWidget<T extends Widget>(
  String Function(String) l10nFunction,
  T widget, {
  TextStyle? textStyle,
}) {
  final localizedStringWithPlaceholder = l10nFunction('%s');

  final parts = localizedStringWithPlaceholder.split('%s');

  // Localized string did not actually contain the placeholder
  if (parts[0] == localizedStringWithPlaceholder) {
    return Text(localizedStringWithPlaceholder);
  }

  return Text.rich(
    TextSpan(
      children: <InlineSpan>[
        if (parts[0].isNotEmpty) TextSpan(text: parts[0], style: textStyle),
        if (parts[0] != localizedStringWithPlaceholder)
          WidgetSpan(
            child: widget,
            alignment: PlaceholderAlignment.middle,
            style: textStyle,
          ),
        if (parts.length > 1 && parts[1].isNotEmpty)
          TextSpan(text: parts[1], style: textStyle),
      ],
    ),
  );
}

final _dateFormatterWithYear = DateFormat.yMMMMd();
final _dateFormatterWithYearShort = DateFormat.yMMMd();

/// Formats a date as a relative date string from now.
String relativeDate(
  AppLocalizations l10n,
  DateTime date, {
  bool shortDate = true,
}) {
  final now = DateTime.now();
  final diff = date.difference(now);

  final yearFormatter = shortDate
      ? _dateFormatterWithYearShort
      : _dateFormatterWithYear;

  if (diff.isNegative) {
    return diff.inDays == 0
        ? diff.inHours == 0
              ? diff.inMinutes == 0
                    ? l10n.timeagoRightNow
                    : l10n.timeagoNbMinutesAgo(diff.inMinutes.abs())
              : l10n.timeagoNbHoursAgo(diff.inHours.abs())
        : diff.inDays == 1
        ? l10n.yesterday
        : diff.inDays.abs() <= 7
        ? l10n.timeagoNbDaysAgo(diff.inDays.abs())
        : diff.inDays.abs() <= 30
        ? l10n.timeagoNbWeeksAgo((diff.inDays.abs() / 7).round())
        : diff.inDays.abs() <= 365
        ? l10n.timeagoNbMonthsAgo((diff.inDays.abs() / 30).round())
        : yearFormatter.format(date);
  }
  return diff.inDays == 0
      ? diff.inHours == 0
            ? diff.inMinutes == 0
                  ? l10n.timeagoInNbSeconds(diff.inSeconds)
                  : l10n.timeagoInNbMinutes(diff.inMinutes)
            : l10n.timeagoInNbHours(diff.inHours)
      : diff.inDays.abs() <= 7
      ? l10n.timeagoInNbDays(diff.inDays)
      : diff.inDays.abs() <= 30
      ? l10n.timeagoInNbWeeks((diff.inDays.abs() / 7).round())
      : diff.inDays.abs() <= 365
      ? l10n.timeagoInNbMonths((diff.inDays.abs() / 30).round())
      : yearFormatter.format(date);
}

/// Returns a localized locale name.
///
/// Names taken from https://github.com/lichess-org/lila/blob/master/modules/i18n/src/main/LangList.scala.
///
/// Not all of these are actually supported in the app currently, but this way we won't have to check the lila code again when we add more languages.
String localeToLocalizedName(Locale locale) => switch (locale) {
  Locale(languageCode: 'af') => 'Afrikaans',
  Locale(languageCode: 'an') => 'Aragonés',
  Locale(languageCode: 'ar') => 'العربية',
  Locale(languageCode: 'as') => 'অসমীয়া',
  Locale(languageCode: 'av') => 'авар мацӀ',
  Locale(languageCode: 'az') => 'Azərbaycanca',
  Locale(languageCode: 'be') => 'Беларуская',
  Locale(languageCode: 'bg') => 'български език',
  Locale(languageCode: 'bn') => 'বাংলা',
  Locale(languageCode: 'br') => 'Brezhoneg',
  Locale(languageCode: 'bs') => 'Bosanski',
  Locale(languageCode: 'ca') => 'Català, valencià',
  Locale(languageCode: 'ckb') => 'کوردی سۆرانی',
  Locale(languageCode: 'co') => 'Corsu',
  Locale(languageCode: 'cs') => 'Čeština',
  Locale(languageCode: 'cv') => 'чӑваш чӗлхи',
  Locale(languageCode: 'cy') => 'Cymraeg',
  Locale(languageCode: 'da') => 'Dansk',
  Locale(languageCode: 'de') => 'Deutsch',
  Locale(languageCode: 'el') => 'Ελληνικά',
  Locale(languageCode: 'en', countryCode: 'US') => 'English (US)',
  Locale(languageCode: 'en') => 'English',
  Locale(languageCode: 'eo') => 'Esperanto',
  Locale(languageCode: 'es') => 'Español',
  Locale(languageCode: 'et') => 'Eesti keel',
  Locale(languageCode: 'eu') => 'Euskara',
  Locale(languageCode: 'fa') => 'فارسی',
  Locale(languageCode: 'fi') => 'Suomen kieli',
  Locale(languageCode: 'fo') => 'Føroyskt',
  Locale(languageCode: 'fr') => 'Français',
  Locale(languageCode: 'frp') => 'Arpitan',
  Locale(languageCode: 'fy') => 'Frysk',
  Locale(languageCode: 'ga') => 'Gaeilge',
  Locale(languageCode: 'gd') => 'Gàidhlig',
  Locale(languageCode: 'gl') => 'Galego',
  Locale(languageCode: 'gsw') => 'Schwizerdütsch',
  Locale(languageCode: 'gu') => 'ગુજરાતી',
  Locale(languageCode: 'he') => 'עִבְרִית',
  Locale(languageCode: 'hi') => 'हिन्दी, हिंदी',
  Locale(languageCode: 'hr') => 'Hrvatski',
  Locale(languageCode: 'hu') => 'Magyar',
  Locale(languageCode: 'hy') => 'Հայերեն',
  Locale(languageCode: 'ia') => 'Interlingua',
  Locale(languageCode: 'id') => 'Bahasa Indonesia',
  Locale(languageCode: 'io') => 'Ido',
  Locale(languageCode: 'is') => 'Íslenska',
  Locale(languageCode: 'it') => 'Italiano',
  Locale(languageCode: 'ja') => '日本語',
  Locale(languageCode: 'jbo') => 'Lojban',
  Locale(languageCode: 'jv') => 'Basa Jawa',
  Locale(languageCode: 'ka') => 'ქართული',
  Locale(languageCode: 'kab') => 'Taqvaylit',
  Locale(languageCode: 'kk') => 'қазақша',
  Locale(languageCode: 'kmr') => 'Kurdî (Kurmancî)',
  Locale(languageCode: 'kn') => 'ಕನ್ನಡ',
  Locale(languageCode: 'ko') => '한국어',
  Locale(languageCode: 'ky') => 'кыргызча',
  Locale(languageCode: 'la') => 'Lingua Latina',
  Locale(languageCode: 'lb') => 'Lëtzebuergesch',
  Locale(languageCode: 'lt') => 'Lietuvių kalba',
  Locale(languageCode: 'lv') => 'Latviešu valoda',
  Locale(languageCode: 'mg') => 'Fiteny malagasy',
  Locale(languageCode: 'mk') => 'македонски јази',
  Locale(languageCode: 'ml') => 'മലയാളം',
  Locale(languageCode: 'mn') => 'монгол',
  Locale(languageCode: 'mr') => 'मराठी',
  Locale(languageCode: 'nb') => 'Norsk bokmål',
  Locale(languageCode: 'ne') => 'नेपाली',
  Locale(languageCode: 'nl') => 'Nederlands',
  Locale(languageCode: 'nn') => 'Norsk nynorsk',
  Locale(languageCode: 'pi') => 'पालि',
  Locale(languageCode: 'pl') => 'Polski',
  Locale(languageCode: 'ps') => 'پښتو',
  Locale(languageCode: 'pt', countryCode: 'BR') => 'Português (BR)',
  Locale(languageCode: 'pt') => 'Português',
  Locale(languageCode: 'ro') => 'Română',
  Locale(languageCode: 'ru') => 'русский язык',
  Locale(languageCode: 'ry') => 'Русинська бисїда',
  Locale(languageCode: 'sa') => 'संस्कृत',
  Locale(languageCode: 'sk') => 'Slovenčina',
  Locale(languageCode: 'sl') => 'Slovenščina',
  Locale(languageCode: 'so') => 'Af Soomaali',
  Locale(languageCode: 'sq') => 'Shqip',
  Locale(languageCode: 'sr') => 'Српски језик',
  Locale(languageCode: 'sv') => 'Svenska',
  Locale(languageCode: 'sw') => 'Kiswahili',
  Locale(languageCode: 'ta') => 'தமிழ்',
  Locale(languageCode: 'tg') => 'тоҷикӣ',
  Locale(languageCode: 'th') => 'ไทย',
  Locale(languageCode: 'tk') => 'Türkmençe',
  Locale(languageCode: 'tl') => 'Tagalog',
  Locale(languageCode: 'tp') => 'Toki pona',
  Locale(languageCode: 'tr') => 'Türkçe',
  Locale(languageCode: 'uk') => 'українська',
  Locale(languageCode: 'ur') => 'اُردُو',
  Locale(languageCode: 'uz') => 'oʻzbekcha',
  Locale(languageCode: 'vi') => 'Tiếng Việt',
  Locale(languageCode: 'yo') => 'Yorùbá',
  Locale(languageCode: 'zh', countryCode: 'TW') => '繁體中文',
  Locale(languageCode: 'zh') => '中文',
  Locale(languageCode: 'zu') => 'isiZulu',
  _ => locale.toString(),
};
