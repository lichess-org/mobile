import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_repository.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/more/import_pgn_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:material_ui/material_ui.dart';

sealed class CreateStudyChapterParams {}

class CreateChapterOfExistingStudy extends CreateStudyChapterParams {
  CreateChapterOfExistingStudy(this.studyId);
  final StudyId studyId;
}

enum _ChapterSource { empty, fen, pgn }

class CreateStudyChapterBottomSheet extends ConsumerStatefulWidget {
  const CreateStudyChapterBottomSheet({
    required this.params,
    required this.chapterNumber,
    this.onChaptersCreated,
  });

  final CreateStudyChapterParams params;
  final int chapterNumber;
  final void Function(StudyId, IList<StudyChapterId>)? onChaptersCreated;

  @override
  ConsumerState<CreateStudyChapterBottomSheet> createState() =>
      _CreateStudyChapterBottomSheetState();
}

class _CreateStudyChapterBottomSheetState extends ConsumerState<CreateStudyChapterBottomSheet> {
  String chapterName = '';

  final _nameController = TextEditingController();
  final _textController = TextEditingController();

  _ChapterSource _source = _ChapterSource.empty;
  Side orientation = Side.white;
  Variant variant = Variant.standard;
  String? errorText;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        chapterName = context.l10n.studyChapterX(widget.chapterNumber.toString());
        _nameController.text = chapterName;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    setState(() {
      errorText = null;
      _textController.text = value;
      if (value.trim().isEmpty) {
        return;
      }
      switch (_source) {
        case _ChapterSource.empty:
          break;
        case _ChapterSource.fen:
          try {
            Position.setupPosition(variant.rule, Setup.parseFen(value.trim()));
          } catch (_) {
            errorText = context.l10n.invalidFen;
          }
        case _ChapterSource.pgn:
          try {
            final games = PgnGame.parseMultiGameLazy(value);
            errorText = games.isEmpty ? context.l10n.invalidPgn : null;
          } catch (_) {
            errorText = context.l10n.invalidPgn;
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetScrollableContainer(
      padding: Styles.verticalBodyPadding,
      children: [
        Card.filled(
          margin: Styles.bodySectionPadding,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.0,
              children: [
                ListTile(
                  title: Text(context.l10n.name),
                  subtitle: TextField(
                    controller: _nameController,
                    onChanged: (value) => setState(() => chapterName = value),
                  ),
                ),
                // [expandedInsets] makes the button fill the available width, so its size does not
                // depend on which segment is selected: the selected segment carries an extra check
                // icon, which would otherwise make the whole button resize on every switch.
                SegmentedButton<_ChapterSource>(
                  expandedInsets: const EdgeInsets.symmetric(horizontal: 20.0),
                  segments: [
                    ButtonSegment(
                      value: _ChapterSource.empty,
                      label: Text(context.l10n.studyEmpty),
                    ),
                    const ButtonSegment(value: _ChapterSource.fen, label: Text('FEN')),
                    const ButtonSegment(value: _ChapterSource.pgn, label: Text('PGN')),
                  ],
                  selected: {_source},
                  onSelectionChanged: (selection) {
                    setState(() {
                      _source = selection.first;
                      errorText = null;
                      switch (_source) {
                        case _ChapterSource.empty:
                          break;
                        case _ChapterSource.fen || _ChapterSource.pgn:
                          _onTextChanged('');
                      }
                    });
                  },
                ),
                if (_source == _ChapterSource.fen)
                  SmallBoardPreview(
                    orientation: orientation,
                    fen: errorText == null ? _textController.text : kEmptyFEN,
                    description: TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        errorText: errorText,
                        labelText: context.l10n.pasteTheFenStringHere,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.paste),
                          onPressed: _getClipboardData,
                          tooltip: 'Paste from clipboard', // TODO l10n
                        ),
                      ),
                      controller: _textController,
                      readOnly: true,
                      onTap: () => _getClipboardData(),
                    ),
                  ),
                if (_source == _ChapterSource.pgn)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 8.0,
                      children: [
                        SizedBox(
                          height: 150,
                          child: TextField(
                            expands: true,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: context.l10n.pasteThePgnStringHere,
                              errorText: errorText,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.paste),
                                onPressed: _getClipboardData,
                                tooltip: 'Paste from clipboard', // TODO l10n
                              ),
                            ),
                            readOnly: true,
                            onTap: _getClipboardData,
                            controller: _textController,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _pickPgnFile,
                          icon: const Icon(Icons.upload_file),
                          label: Text(context.l10n.mobileOrImportPgnFile),
                        ),
                      ],
                    ),
                  ),
                if (_source != _ChapterSource.pgn)
                  ListTile(
                    title: Text(context.l10n.variant),
                    trailing: TextButton(
                      onPressed: () {
                        showChoicePicker(
                          context,
                          choices: Variant.values,
                          selectedItem: variant,
                          labelBuilder: (Variant variant) => Text(variant.label(context.l10n)),
                          onSelectedItemChanged: (Variant variant) =>
                              setState(() => this.variant = variant),
                        );
                      },
                      child: Text(variant.label(context.l10n)),
                    ),
                  ),
                ListTile(
                  title: Text(context.l10n.studyOrientation),
                  trailing: TextButton(
                    onPressed: () {
                      showChoicePicker(
                        context,
                        choices: Side.values,
                        selectedItem: orientation,
                        labelBuilder: (Side side) => Text(_sideL10n(context, side)),
                        onSelectedItemChanged: (Side side) => setState(() => orientation = side),
                      );
                    },
                    child: Text(_sideL10n(context, orientation)),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: FilledButton(
            onPressed: _canSubmit()
                ? () async {
                    final pgn = switch (_source) {
                      _ChapterSource.empty => PgnGame.parsePgn(
                        '',
                        initHeaders: () => {'Variant': variant.pgnName},
                      ).makePgn(),
                      _ChapterSource.fen => PgnGame.parsePgn(
                        '',
                        initHeaders: () => {
                          'FEN': _textController.text.trim(),
                          'Variant': variant.pgnName,
                        },
                      ).makePgn(),
                      _ChapterSource.pgn => _textController.text.trim(),
                    };
                    await _createChapter(pgn);
                  }
                : null,
            child: Text(context.l10n.studyCreateChapter, style: Styles.bold),
          ),
        ),
      ],
    );
  }

  Future<void> _createChapter(String pgn) async {
    final chapterPayload = CreateStudyChapterPayload(
      pgn: pgn,
      name: chapterName,
      orientation: orientation,
      variant: _source == _ChapterSource.pgn ? null : variant,
    );
    final (studyId, chapterIds) = switch (widget.params) {
      CreateChapterOfExistingStudy(:final studyId) => (
        studyId,
        await ref.read(studyRepositoryProvider).createChapter(studyId, chapterPayload),
      ),
    };

    if (!mounted) return;
    Navigator.of(context).pop();

    widget.onChaptersCreated?.call(studyId, chapterIds);
  }

  bool _canSubmit() {
    if (chapterName.trim().isEmpty) return false;

    switch (_source) {
      case _ChapterSource.empty:
        return true;
      case _ChapterSource.fen || _ChapterSource.pgn:
        return errorText == null && _textController.text.trim().isNotEmpty;
    }
  }

  Future<void> _getClipboardData() async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text == null) return;
    if (!mounted) return;

    final text = data!.text!.trim();
    if (text.isEmpty) return;

    _onTextChanged(text);
  }

  Future<void> _pickPgnFile() async {
    try {
      final file = await ref.read(pickPgnFileProvider)();

      if (file != null) {
        final content = await const Utf8Decoder(
          allowMalformed: true,
        ).bind(file.readAsByteStream()).join();
        if (mounted) {
          _onTextChanged(content);
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error loading file: $e', type: SnackBarType.error);
      }
    }
  }
}

String _sideL10n(BuildContext context, Side side) => switch (side) {
  Side.white => context.l10n.white,
  Side.black => context.l10n.black,
};
