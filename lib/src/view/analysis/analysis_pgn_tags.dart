import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/widgets/adaptive_text_field.dart';

class AnalysisPgnTags extends ConsumerWidget {
  const AnalysisPgnTags({required this.options});

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);
    final pgnHeaders = ref.watch(ctrlProvider.select((c) => c.pgnHeaders));

    if (pgnHeaders == null) {
      return const Center(child: Text('Nothin to show'));
    }

    return ListView(
      shrinkWrap: true,
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
              DataColumn(
                label: Icon(Icons.edit, color: Colors.grey.withOpacity(0.5)),
              ),
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
                  DataCell(
                    Text(e.value),
                    onTap: () {
                      showAdaptiveDialog<void>(
                        context: context,
                        builder: (context) =>
                            _EditDialog(e.key, e.value, options: options),
                        barrierDismissible: false,
                      );
                    },
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _EditDialog extends ConsumerWidget {
  const _EditDialog(this.fieldKey, this.fieldValue, {required this.options});

  final AnalysisOptions options;
  final String fieldKey;
  final String fieldValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AdaptiveTextField(
          autofocus: true,
          controller: TextEditingController.fromValue(
            TextEditingValue(
              text: fieldValue,
              selection:
                  TextSelection(baseOffset: 0, extentOffset: fieldValue.length),
            ),
          ),
          onSubmitted: (value) {
            ref
                .read(analysisControllerProvider(options).notifier)
                .updatePgnHeader(fieldKey, value);
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoAlertDialog(
        content: content,
      );
    } else {
      return AlertDialog(
        content: content,
      );
    }
  }
}
