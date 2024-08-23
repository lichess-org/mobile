import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_locale.g.dart';

@riverpod
String currentLocale(CurrentLocaleRef ref) {
  return ref.watch(generalPreferencesProvider).locale?.languageCode ??
      Intl.getCurrentLocale();
}

extension LocaleWidgetRefExtension on WidgetRef {
  /// Runs [fn] with the current locale.
  T withLocale<T>(T Function(String) fn) {
    final currentLocale = watch(currentLocaleProvider);
    return fn(currentLocale);
  }
}
