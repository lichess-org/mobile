import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
