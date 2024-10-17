import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'localizations.g.dart';

typedef ActiveLocalizations = ({
  Locale locale,
  AppLocalizations strings,
});

@Riverpod(keepAlive: true)
class Localizations extends _$Localizations {
  @override
  ActiveLocalizations build() {
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

  ActiveLocalizations _getLocale() {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    return (
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
