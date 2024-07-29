import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

class OpeningExplorerSettings extends ConsumerWidget {
  const OpeningExplorerSettings(this.pgn, this.options);

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      initialChildSize: .7,
      expand: false,
      snap: true,
      snapSizes: const [.7],
      builder: (context, scrollController) => ListView(
        controller: scrollController,
        children: [
          PlatformListTile(
            title:
                Text(context.l10n.settingsSettings, style: Styles.sectionTitle),
            subtitle: const SizedBox.shrink(),
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
