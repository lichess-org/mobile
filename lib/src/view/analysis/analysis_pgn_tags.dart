import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/adaptive_date_picker.dart';
import 'package:lichess_mobile/src/widgets/adaptive_text_field.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

final _dateFormat = DateFormat('yyyy.MM.dd');

class AnalysisPgnTags extends ConsumerWidget {
  const AnalysisPgnTags({required this.pgn, required this.options});

  final String pgn;
  final AnalysisOptions options;

  void _openNextDialog(
      IMap<String, String> pgnHeaders, int index, BuildContext context) {
    if (index < pgnHeaders.entries.length - 1 && context.mounted) {
      final entry = pgnHeaders.entries.elementAt(index + 1);
      showAdaptiveDialog<void>(
        context: context,
        builder: (context) => _EditDialog(
          entry.key,
          entry.value,
          pgn: pgn,
          options: options,
          onNext: () => _openNextDialog(pgnHeaders, index + 1, context),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(pgn, options);
    final pgnHeaders = ref.watch(ctrlProvider.select((c) => c.pgnHeaders));

    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columns: const [
          DataColumn(
            label: Icon(LichessIcons.tag, color: Colors.grey, size: 20),
          ),
          DataColumn(
            label: Icon(Icons.edit, color: Colors.grey),
          ),
        ],
        rows: pgnHeaders.entries.mapIndexed((index, e) {
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
                      ref.read(ctrlProvider.notifier).updatePgnHeader(
                            e.key,
                            _dateFormat.format(date),
                          );
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
                      builder: (context) => _EditDialog(
                        e.key,
                        e.value,
                        pgn: pgn,
                        options: options,
                        onNext: () =>
                            _openNextDialog(pgnHeaders, index, context),
                      ),
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

class _EditDialog extends ConsumerStatefulWidget {
  const _EditDialog(
    this.fieldKey,
    this.fieldValue, {
    required this.pgn,
    required this.options,
    required this.onNext,
  });

  final String pgn;
  final AnalysisOptions options;
  final String fieldKey;
  final String fieldValue;
  final VoidCallback onNext;

  @override
  ConsumerState<_EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends ConsumerState<_EditDialog> {
  bool isValidInput = true;
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController.fromValue(
      TextEditingValue(
        text: widget.fieldValue,
        selection: TextSelection(
          baseOffset: 0,
          extentOffset: widget.fieldValue.length,
        ),
      ),
    );
  }

  void submitValue() {
    if (widget.fieldKey == 'Date') {
      try {
        _dateFormat.parse(controller.value.text);
      } catch (_) {
        setState(() {
          isValidInput = false;
        });
        return;
      }
    }
    ref
        .read(
          analysisControllerProvider(widget.pgn, widget.options).notifier,
        )
        .updatePgnHeader(widget.fieldKey, controller.value.text);
    Navigator.of(context).pop();
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.fieldKey == 'Date')
          const Align(
            alignment: Alignment.topLeft,
            child: Text('Format: yyyy.MM.dd'),
          ),
        AdaptiveTextField(
          materialDecoration:
              InputDecoration(errorText: !isValidInput ? 'Invalid Date' : null),
          autofocus: true,
          keyboardType:
              widget.fieldKey == 'WhiteElo' || widget.fieldKey == 'BlackElo'
                  ? TextInputType.number
                  : TextInputType.text,
          controller: controller,
          onSubmitted: (value) {
            submitValue();
            Navigator.of(context).pop();
          },
        ),
        AdaptiveTextButton(
          onPressed: () {
            submitValue();
          },
          child: Text(context.l10n.next),
        ),
      ],
    );

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoAlertDialog(
        title: Text(widget.fieldKey),
        content: content,
      );
    } else {
      return AlertDialog(
        title: Text(widget.fieldKey),
        content: content,
      );
    }
  }
}
