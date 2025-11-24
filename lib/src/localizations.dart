import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';

typedef ActiveLocalizations = ({Locale locale, AppLocalizations strings});

/// A provider for [Localizations].
final localizationsProvider = NotifierProvider<Localizations, ActiveLocalizations>(
  Localizations.new,
  name: 'LocalizationsProvider',
);

class Localizations extends Notifier<ActiveLocalizations> {
  @override
  ActiveLocalizations build() {
    final generalPrefs = ref.watch(generalPreferencesProvider);
    final observer = _LocaleObserver((locales) {
      _update();
    });
    final binding = WidgetsBinding.instance;
    binding.addObserver(observer);
    ref.onDispose(() => binding.removeObserver(observer));

    return _getLocale(generalPrefs);
  }

  void _update() {
    final generalPrefs = ref.read(generalPreferencesProvider);
    state = _getLocale(generalPrefs);
  }

  ActiveLocalizations _getLocale(GeneralPrefs prefs) {
    if (prefs.locale != null) {
      return (locale: prefs.locale!, strings: lookupAppLocalizations(prefs.locale!));
    }
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    return (locale: locale, strings: lookupAppLocalizations(locale));
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
