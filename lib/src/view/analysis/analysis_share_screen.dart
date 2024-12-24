import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/adaptive_text_field.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

final _dateFormatter = DateFormat('yyyy.MM.dd');

class AnalysisShareScreen extends StatelessWidget {
  const AnalysisShareScreen({super.key, required this.options});

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.studyShareAndExport)),
      body: _EditPgnTagsForm(options),
    );
  }
}

const Set<String> _ratingHeaders = {'WhiteElo', 'BlackElo', 'WhiteRatingDiff', 'BlackRatingDiff'};

class _EditPgnTagsForm extends ConsumerStatefulWidget {
  const _EditPgnTagsForm(this.options);

  final AnalysisOptions options;

  @override
  _EditPgnTagsFormState createState() => _EditPgnTagsFormState();
}

class _EditPgnTagsFormState extends ConsumerState<_EditPgnTagsForm> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    final ctrlProvider = analysisControllerProvider(widget.options);
    final pgnHeaders = ref.read(ctrlProvider).requireValue.pgnHeaders;

    for (final entry in pgnHeaders.entries) {
      _controllers[entry.key] = TextEditingController(text: entry.value);
      _focusNodes[entry.key] = FocusNode();
      _focusNodes[entry.key]!.addListener(() {
        if (!_focusNodes[entry.key]!.hasFocus) {
          ref.read(ctrlProvider.notifier).updatePgnHeader(entry.key, _controllers[entry.key]!.text);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrlProvider = analysisControllerProvider(widget.options);
    final pgnHeaders = ref.watch(ctrlProvider.select((c) => c.requireValue.pgnHeaders));
    final showRatingAsync = ref.watch(showRatingsPrefProvider);

    void focusAndSelectNextField(int index, IMap<String, String> pgnHeaders) {
      if (index + 1 < pgnHeaders.entries.length) {
        final nextEntry = pgnHeaders.entries.elementAt(index + 1);
        if (nextEntry.key == 'Date') {
          _showDatePicker(
            nextEntry,
            context: context,
            onEntryChanged: () {
              focusAndSelectNextField(index + 1, pgnHeaders);
            },
          );
        } else if (nextEntry.key == 'Result') {
          _showResultChoicePicker(
            nextEntry,
            context: context,
            onEntryChanged: () {
              focusAndSelectNextField(index + 1, pgnHeaders);
            },
          );
        } else {
          _focusNodes[nextEntry.key]!.requestFocus();
          _controllers[nextEntry.key]!.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controllers[nextEntry.key]!.text.length,
          );
        }
      }
    }

    return showRatingAsync.maybeWhen(
      data: (showRatings) {
        return SafeArea(
          child: Padding(
            padding: Styles.verticalBodyPadding,
            child: ListView(
              children: [
                Column(
                  children:
                      pgnHeaders.entries
                          .where((e) => showRatings || !_ratingHeaders.contains(e.key))
                          .mapIndexed((index, e) {
                            return _EditablePgnField(
                              entry: e,
                              controller: _controllers[e.key]!,
                              focusNode: _focusNodes[e.key]!,
                              onTap: () {
                                _controllers[e.key]!.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: _controllers[e.key]!.text.length,
                                );
                                if (e.key == 'Result') {
                                  _showResultChoicePicker(
                                    e,
                                    context: context,
                                    onEntryChanged: () {
                                      focusAndSelectNextField(index, pgnHeaders);
                                    },
                                  );
                                } else if (e.key == 'Date') {
                                  _showDatePicker(
                                    e,
                                    context: context,
                                    onEntryChanged: () {
                                      focusAndSelectNextField(index, pgnHeaders);
                                    },
                                  );
                                }
                              },
                              onSubmitted: (value) {
                                ref.read(ctrlProvider.notifier).updatePgnHeader(e.key, value);
                                focusAndSelectNextField(index, pgnHeaders);
                              },
                            );
                          })
                          .toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Builder(
                    builder: (context) {
                      return FatButton(
                        semanticsLabel: 'Share PGN',
                        onPressed: () {
                          launchShareDialog(
                            context,
                            text:
                                ref
                                    .read(analysisControllerProvider(widget.options).notifier)
                                    .makeExportPgn(),
                          );
                        },
                        child: Text(context.l10n.mobileShareGamePGN),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Future<void> _showDatePicker(
    MapEntry<String, String> entry, {
    required BuildContext context,
    required void Function() onEntryChanged,
  }) {
    final ctrlProvider = analysisControllerProvider(widget.options);
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return showCupertinoModalPopup<void>(
        context: context,
        builder:
            (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime:
                      entry.value.isNotEmpty ? _dateFormatter.parse(entry.value) : DateTime.now(),
                  onDateTimeChanged: (DateTime newDateTime) {
                    final newDate = _dateFormatter.format(newDateTime);
                    ref.read(ctrlProvider.notifier).updatePgnHeader(entry.key, newDate);
                    _controllers[entry.key]!.text = newDate;
                  },
                ),
              ),
            ),
      ).then((_) {
        onEntryChanged();
      });
    } else {
      return showDatePicker(
            context: context,
            initialDate:
                entry.value.isNotEmpty ? _dateFormatter.parse(entry.value) : DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          )
          .then((date) {
            if (date != null) {
              final formatted = _dateFormatter.format(date);
              ref.read(ctrlProvider.notifier).updatePgnHeader(entry.key, formatted);
              _controllers[entry.key]!.text = formatted;
            }
          })
          .then((_) {
            onEntryChanged();
          });
    }
  }

  Future<void> _showResultChoicePicker(
    MapEntry<String, String> entry, {
    required BuildContext context,
    required void Function() onEntryChanged,
  }) {
    return showChoicePicker(
      context,
      choices: ['1-0', '0-1', '1/2-1/2', '*'],
      selectedItem: entry.value,
      labelBuilder: (choice) => Text(choice),
      onSelectedItemChanged: (choice) {
        ref
            .read(analysisControllerProvider(widget.options).notifier)
            .updatePgnHeader(entry.key, choice);
        _controllers[entry.key]!.text = choice;
      },
    ).then((_) {
      onEntryChanged();
    });
  }
}

class _EditablePgnField extends StatelessWidget {
  const _EditablePgnField({
    required this.entry,
    required this.controller,
    required this.focusNode,
    required this.onTap,
    required this.onSubmitted,
  });

  final MapEntry<String, String> entry;
  final TextEditingController controller;
  final FocusNode focusNode;
  final GestureTapCallback onTap;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.horizontalBodyPadding.add(const EdgeInsets.only(bottom: 8.0)),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              entry.key,
              style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AdaptiveTextField(
              focusNode: focusNode,
              cupertinoDecoration: BoxDecoration(
                color: CupertinoColors.tertiarySystemBackground,
                border: Border.all(color: CupertinoColors.systemGrey4, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              controller: controller,
              textInputAction: TextInputAction.next,
              keyboardType:
                  entry.key == 'WhiteElo' || entry.key == 'BlackElo'
                      ? TextInputType.number
                      : TextInputType.text,
              onTap: onTap,
              onSubmitted: onSubmitted,
            ),
          ),
        ],
      ),
    );
  }
}
