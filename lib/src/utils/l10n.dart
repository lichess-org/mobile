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
          WidgetSpan(child: widget),
        if (parts.length > 1 && parts[1].isNotEmpty)
          TextSpan(text: parts[1], style: textStyle),
      ],
    ),
  );
}
