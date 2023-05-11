import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

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
