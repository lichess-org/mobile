import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/adaptive_text_field.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class AnalysisShareScreen extends StatelessWidget {
  const AnalysisShareScreen({required this.pgn, required this.options});

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.studyShareAndExport),
      ),
      body: _EditPgnTagsForm(pgn, options),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _EditPgnTagsForm(pgn, options),
    );
  }
}

const Set<String> _ratingHeaders = {
  'WhiteElo',
  'BlackElo',
  'WhiteRatingDiff',
  'BlackRatingDiff',
};

class _EditPgnTagsForm extends ConsumerStatefulWidget {
  const _EditPgnTagsForm(this.pgn, this.options);

  final String pgn;
  final AnalysisOptions options;

  @override
  _EditPgnTagsFormState createState() => _EditPgnTagsFormState();
}

class _EditPgnTagsFormState extends ConsumerState<_EditPgnTagsForm> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

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
    final ctrlProvider = analysisControllerProvider(widget.pgn, widget.options);
    final pgnHeaders = ref.watch(ctrlProvider.select((c) => c.pgnHeaders));
    final showRatingAsync = ref.watch(showRatingsPrefProvider);

    /// Moves focus to the next field or shows a picker for 'Result'.
    void focusAndSelectNextField(int index, IMap<String, String> pgnHeaders) {
      if (index + 1 < pgnHeaders.entries.length) {
        final nextEntry = pgnHeaders.entries.elementAt(index + 1);
        if (nextEntry.key == 'Result') {
          showChoicePicker(
            context,
            choices: ['1-0', '0-1', '1/2-1/2', '*'],
            selectedItem: nextEntry.value,
            labelBuilder: (choice) => Text(choice),
            onSelectedItemChanged: (choice) {
              ref
                  .read(ctrlProvider.notifier)
                  .updatePgnHeader(nextEntry.key, choice);
              _controllers[nextEntry.key]!.text = choice;
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
                  children: pgnHeaders.entries
                      .where(
                    (e) => showRatings || !_ratingHeaders.contains(e.key),
                  )
                      .mapIndexed((index, e) {
                    if (!_controllers.containsKey(e.key)) {
                      _controllers[e.key] =
                          TextEditingController(text: e.value);
                      _focusNodes[e.key] = FocusNode();
                      _focusNodes[e.key]!.addListener(() {
                        if (!_focusNodes[e.key]!.hasFocus) {
                          ref.read(ctrlProvider.notifier).updatePgnHeader(
                                e.key,
                                _controllers[e.key]!.text,
                              );
                        }
                      });
                    }

                    return Padding(
                      padding: Styles.horizontalBodyPadding
                          .add(const EdgeInsets.only(bottom: 8.0)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 110,
                            child: Text(
                              e.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: AdaptiveTextField(
                              focusNode: _focusNodes[e.key],
                              cupertinoDecoration: BoxDecoration(
                                color: CupertinoColors.tertiarySystemBackground,
                                border: Border.all(
                                  color: CupertinoColors.systemGrey4,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              controller: _controllers[e.key],
                              textInputAction: TextInputAction.next,
                              keyboardType:
                                  e.key == 'WhiteElo' || e.key == 'BlackElo'
                                      ? TextInputType.number
                                      : TextInputType.text,
                              onTap: () {
                                _controllers[e.key]!.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                      _controllers[e.key]!.text.length,
                                );
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
                                      _controllers[e.key]!.text = choice;
                                      focusAndSelectNextField(
                                        index,
                                        pgnHeaders,
                                      );
                                    },
                                  );
                                }
                              },
                              onSubmitted: (value) {
                                ref
                                    .read(ctrlProvider.notifier)
                                    .updatePgnHeader(e.key, value);
                                focusAndSelectNextField(index, pgnHeaders);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
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
                            text: ref
                                .read(
                                  analysisControllerProvider(
                                    widget.pgn,
                                    widget.options,
                                  ).notifier,
                                )
                                .makeGamePgn(),
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
}
