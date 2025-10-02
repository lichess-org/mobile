import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

class EngineThreatModeIndicator extends ConsumerWidget {
  const EngineThreatModeIndicator({required this.engineInThreatMode, required this.onPressed});

  final bool engineInThreatMode;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SemanticIconButton(
      icon: const Icon(LichessIcons.target),
      color: engineInThreatMode ? LichessColors.red : null,
      semanticsLabel: context.l10n.showThreat,
      onPressed: onPressed,
    );
  }
}
