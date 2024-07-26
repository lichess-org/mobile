import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'l10n.freezed.dart';
part 'l10n.g.dart';

@freezed
class L10nState with _$L10nState {
  const factory L10nState({
    required Locale locale,
    required AppLocalizations strings,
  }) = _L10nState;
}

@Riverpod(keepAlive: true)
class L10n extends _$L10n {
  @override
  L10nState build() {
    final observer = _LocaleObserver((locales) {
      _update();
    });
    final binding = WidgetsBinding.instance;
    binding.addObserver(observer);
    ref.onDispose(() => binding.removeObserver(observer));

    return _getLocale();
  }

  void _update() {
    state = _getLocale();
  }

  L10nState _getLocale() {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    return L10nState(
      locale: locale,
      strings: lookupAppLocalizations(locale),
    );
  }
}

/// observer used to notify the caller when the locale changes
class _LocaleObserver extends WidgetsBindingObserver {
  _LocaleObserver(this._didChangeLocales);
  final void Function(List<Locale>? locales) _didChangeLocales;
  @override
  void didChangeLocales(List<Locale>? locales) {
    _didChangeLocales(locales);
  }
}

/// Takes a localization function ([l10nWithPlaceholder]) (from lib/l10n/l10n.dart) with a single placeholder
/// and returns a Text widget containing the localized string with the placeholder replaced by the given [widget].
///
/// The [textStyle] parameter can be used to style the displayed text parts of the localized string.
///
/// For example:
///
/// ```dart
/// String translationFun(String name) {
///   return 'Hello, ${name}!';
/// }
///
/// // returns a text widget containing MyFancyWidget('Magnus') in place of the placeholder
/// replaceL10nPlaceholderWithWidget(translationFun, MyFancyWidget('Magnus'));
/// ```
Text replaceL10nPlaceholderWithWidget<T extends Widget>(
  String Function(String) l10nWithPlaceholder,
  T widget, {
  TextStyle? textStyle,
}) {
  final localizedStringWithPlaceholder = l10nWithPlaceholder('%s');

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
          WidgetSpan(child: widget),
        if (parts.length > 1 && parts[1].isNotEmpty)
          TextSpan(text: parts[1], style: textStyle),
      ],
    ),
  );
}
