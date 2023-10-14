import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';

class AnalysisPgnTags extends ConsumerWidget {
  const AnalysisPgnTags(this.ctrlProvider);

  final AnalysisControllerProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pgnHeaders = ref.watch(ctrlProvider.select((c) => c.pgnHeaders));

    if (pgnHeaders == null) {
      return const Center(child: Text('Nothin to show'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SafeArea(
          child: DataTable(
            columns: [
              DataColumn(
                label: Text(
                  context.l10n.studyPgnTags,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              const DataColumn(label: Text('')),
            ],
            rows: pgnHeaders.entries.map((e) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      e.key,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataCell(Text(e.value)),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
