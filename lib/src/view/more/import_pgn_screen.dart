import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/analysis/pgn_game_list.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';

class ImportPgnScreen extends StatelessWidget {
  const ImportPgnScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const ImportPgnScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.importPgn)),
      body: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: Styles.bodySectionPadding,
              child: TextField(
                maxLines: 500,
                decoration: InputDecoration(
                  hintText: context.l10n.pasteThePgnStringHere,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.paste),
                    onPressed: _getClipboardData,
                    tooltip: 'Paste from clipboard',
                  ),
                ),
                readOnly: true,
                onTap: _getClipboardData,
              ),
            ),
          ),
          Padding(
            padding: Styles.bodySectionBottomPadding,
            child: FilledButton(onPressed: _pickPgnFile, child: Text(context.l10n.orUploadPgnFile)),
          ),
        ],
      ),
    );
  }

  void _handlePgnText(String text) {
    try {
      final games = PgnGame.parseMultiGamePgn(text);

      if (games.isEmpty) {
        showSnackBar(context, context.l10n.invalidPgn, type: SnackBarType.error);
        return;
      }

      if (games.length == 1) {
        final game = games.first;
        final rule = Rule.fromPgn(game.headers['Variant']);

        Navigator.of(context, rootNavigator: true).push(
          AnalysisScreen.buildRoute(
            context,
            AnalysisOptions.standalone(
              id: const StringId('standalone'),
              orientation: Side.white,
              pgn: text,
              isComputerAnalysisAllowed: true,
              initialMoveCursor: game.moves.mainline().isEmpty ? 0 : 1,
              variant: rule != null ? Variant.fromRule(rule) : Variant.standard,
            ),
          ),
        );
      } else {
        Navigator.of(
          context,
          rootNavigator: true,
        ).push(PgnGamesListScreen.buildRoute(context, games.lock));
      }
    } catch (_) {
      showSnackBar(context, context.l10n.invalidPgn, type: SnackBarType.error);
    }
  }

  Future<void> _getClipboardData() async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text == null) return;
    if (!mounted) return;

    final text = data!.text!.trim();
    if (text.isEmpty) return;

    _handlePgnText(text);
  }

  Future<void> _pickPgnFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pgn'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final content = utf8.decode(result.files.single.bytes!);
        if (mounted) {
          _handlePgnText(content);
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error loading file: $e', type: SnackBarType.error);
      }
    }
  }
}
