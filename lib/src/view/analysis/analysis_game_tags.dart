import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';

class AnalysisGameTags extends ConsumerWidget {
  const AnalysisGameTags(this.ctrlProvider);

  final AnalysisControllerProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pgnHeaders = ref.watch(ctrlProvider.select((c) => c.pgnHeaders));

    if (pgnHeaders == null) {
      return ModalSheetScaffold(
        title: Text('Tags'),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return ModalSheetScaffold(
      title: Text('Tags'),
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Tag')),
            DataColumn(label: Text('Value')),
          ],
          rows: pgnHeaders.entries.map((e) {
            return DataRow(
              cells: [
                DataCell(Text(e.key)),
                DataCell(Text(e.value)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
