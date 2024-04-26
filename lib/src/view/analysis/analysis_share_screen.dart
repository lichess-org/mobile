import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/share.dart';
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

class _EditPgnTagsForm extends ConsumerWidget {
  const _EditPgnTagsForm(this.pgn, this.options);

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(pgn, options);
    final pgnHeaders = ref.watch(ctrlProvider.select((c) => c.pgnHeaders));

    return SafeArea(
      child: Padding(
        padding: Styles.verticalBodyPadding,
        child: ListView(
          children: [
            Column(
              children: pgnHeaders.entries.mapIndexed((index, e) {
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
                          cupertinoDecoration: BoxDecoration(
                            color: CupertinoColors.tertiarySystemBackground,
                            border: Border.all(
                              color: CupertinoColors.systemGrey4,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: e.value,
                              selection: TextSelection(
                                baseOffset: 0,
                                extentOffset: e.value.length,
                              ),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType:
                              e.key == 'WhiteElo' || e.key == 'BlackElo'
                                  ? TextInputType.number
                                  : TextInputType.text,
                          onSubmitted: (value) {
                            ref
                                .read(ctrlProvider.notifier)
                                .updatePgnHeader(e.key, value);
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
                                pgn,
                                options,
                              ).notifier,
                            )
                            .makeGamePgn(),
                      );
                    },
                    child: const Text('Share PGN'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
