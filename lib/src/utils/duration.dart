import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';

extension DurationExtensions on Duration {
  String toDaysHoursMinutes(BuildContext context) {
    final days = inDays;
    final hours = inHours.remainder(24);
    final minutes = inMinutes.remainder(60);
    
    return '${context.l10n.nbDays(days)}, ${context.l10n.nbHours(hours)} and ${context.l10n.nbMinutes(minutes)}';
  }
}
