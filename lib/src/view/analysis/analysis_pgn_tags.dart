import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/widgets/adaptive_text_field.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/adaptive_date_picker.dart';

final _dateFormat = DateFormat('yyyy.MM.dd');

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

    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columns: const [
          DataColumn(
            label: Icon(LichessIcons.tags, color: Colors.grey, size: 20),
          ),
          DataColumn(
            label: Icon(Icons.edit, color: Colors.grey),
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
                  if (e.key == 'Result') {
                    showChoicePicker(
                      context,
                      choices: ['1-0', '0-1', '1/2-1/2', '*'],
                      selectedItem: e.value,
                      labelBuilder: (choice) => Text(choice),
                      onSelectedItemChanged: (choice) {
                        ref
                            .read(ctrlProvider.notifier)
                            .updatePgnHeader(e.key, choice);
                      },
                    );
                  } else if (e.key == 'Date') {
                    DateTime date;
                    try {
                      date = _dateFormat.parse(e.value);
                    } catch (_) {
                      date = DateTime.now();
                    }
                    showAdaptiveDatePicker(
                      context,
                      initialDate: date,
                      firstDate: date.subtract(const Duration(days: 365 * 10)),
                      lastDate: date.add(const Duration(days: 365 * 10)),
                      onDateTimeChanged: (date) {
                        if (date != null) {
                          ref.read(ctrlProvider.notifier).updatePgnHeader(
                                e.key,
                                _dateFormat.format(date),
                              );
                        }
                      },
                    );
                  } else {
                    showAdaptiveDialog<void>(
                      context: context,
                      builder: (context) =>
                          _EditDialog(e.key, e.value, options: options),
                    );
                  }
                },
              ),
            ],
          );
        }).toList(),
      ),
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
          keyboardType: fieldKey == 'WhiteElo' || fieldKey == 'BlackElo'
              ? TextInputType.number
              : TextInputType.text,
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
