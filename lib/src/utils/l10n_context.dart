import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/l10n/l10n.dart';

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
