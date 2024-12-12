import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

final _dayFormatter = DateFormat.E().add_jm();
final _monthFormatter = DateFormat.MMMd().add_Hm();
final _dateFormatterWithYear = DateFormat.yMMMd().add_Hm();

String relativeDate(DateTime date) {
  final diff = date.difference(DateTime.now());

  return (!diff.isNegative && diff.inDays == 0)
      ? diff.inHours == 0
          ? 'in ${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''}' // TODO translate with https://github.com/lichess-org/lila/blob/65b28ea8e43e0133df6c7ed40e03c2954f247d1e/translation/source/timeago.xml#L8
          : 'in ${diff.inHours} hour${diff.inHours > 1 ? 's' : ''}' // TODO translate with https://github.com/lichess-org/lila/blob/65b28ea8e43e0133df6c7ed40e03c2954f247d1e/translation/source/timeago.xml#L12
      : diff.inDays <= 7
          ? _dayFormatter.format(date)
          : diff.inDays < 365
              ? _monthFormatter.format(date)
              : _dateFormatterWithYear.format(date);
}

/// Returns a localized locale name.
///
/// Names taken from https://github.com/lichess-org/lila/blob/master/modules/i18n/src/main/LangList.scala.
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
