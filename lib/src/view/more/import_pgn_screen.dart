import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/analysis/pgn_games_list_screen.dart';
import 'package:lichess_mobile/src/view/study/add_pgn_to_study_screen.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

/// A provider for picking PGN files. Can be overridden in tests.
final pickPgnFileProvider = Provider<Future<PlatformFile?> Function()>((ref) {
  return () => FilePicker.pickFile(type: .custom, allowedExtensions: ['pgn']);
});

class const ImportPgnScreen({super.key}) extends StatelessWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const ImportPgnScreen());
  }

  static void handlePgnText(BuildContext context, String text, {required bool isLoggedIn}) {
    try {
      final games = PgnGame.parseMultiGameLazy(text);

      if (games.isEmpty) {
        showSnackBar(context, context.l10n.invalidPgn, type: .error);
        return;
      }

      if (!isLoggedIn) {
        _openInAnalysisBoard(context, games.lock);
        return;
      }

      showDialog<String>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Select import mode'), // TODO l10n
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (!context.mounted) return;
                  _openInAnalysisBoard(context, games.lock);
                },
                child: const ListTile(
                  leading: Icon(Icons.biotech),
                  // TODO l10n
                  title: Text('Local Analysis'),
                  subtitle: Text('Analyse the imported game in a temporary analysis board.'),
                ),
              ),
              SimpleDialogOption(
                child: ListTile(
                  leading: const Icon(Symbols.school_rounded),
                  title: Text(context.l10n.mobileAddToStudy),
                  // TODO l10n
                  subtitle: const Text(
                    'Analyse the imported game in a study. It will be saved and you can run a server analysis.',
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (!context.mounted) return;
                  Navigator.of(context).push(AddPgnToStudyScreen.buildRoute(pgn: text));
                },
              ),
            ],
          );
        },
      );
      return;
    } catch (_) {
      showSnackBar(context, context.l10n.invalidPgn, type: .error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.importPgn)),
      body: const _Body(),
    );
  }

  static void _openInAnalysisBoard(BuildContext context, IList<PgnLazyGame> games) {
    if (games.length == 1) {
      final game = games.first;
      final rule = Rule.fromPgn(game.headers['Variant']);

      Navigator.of(context, rootNavigator: true).push(
        AnalysisScreen.buildRoute(
          AnalysisOptions.pgn(
            id: const StringId('pgn_import_single_game'),
            orientation: .white,
            pgn: game.rawPgn,
            isComputerAnalysisAllowed: true,
            initialMoveCursor: 1,
            variant: rule != null ? Variant.fromRule(rule) : .standard,
          ),
        ),
      );
    } else {
      Navigator.of(context, rootNavigator: true).push(PgnGamesListScreen.buildRoute(games));
    }
  }
}

class const _Body() extends ConsumerStatefulWidget {
  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState() extends ConsumerState<_Body> {
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
            child: FilledButton(
              onPressed: _pickPgnFile,
              child: Text(context.l10n.mobileOrImportPgnFile),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getClipboardData() async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text == null) return;
    if (!mounted) return;

    final text = data!.text!.trim();
    if (text.isEmpty) return;

    ImportPgnScreen.handlePgnText(context, text, isLoggedIn: ref.read(isLoggedInProvider));
  }

  Future<void> _pickPgnFile() async {
    try {
      final file = await ref.read(pickPgnFileProvider)();

      if (file != null) {
        final content = await const Utf8Decoder(allowMalformed: true)
            .bind(file.readAsByteStream())
            .join();
        if (mounted) {
          ImportPgnScreen.handlePgnText(context, content, isLoggedIn: ref.read(isLoggedInProvider));
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error loading file: $e', type: SnackBarType.error);
      }
    }
  }
}
