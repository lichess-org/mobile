import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/board_editor/board_editor_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/board_editor/board_editor_filters.dart';
import 'package:lichess_mobile/src/view/board_editor/board_editor_positions.dart';
import 'package:lichess_mobile/src/view/offline_computer/offline_computer_game_screen.dart';
import 'package:lichess_mobile/src/view/over_the_board/over_the_board_screen.dart';
import 'package:lichess_mobile/src/view/play/create_challenge_bottom_sheet.dart';
import 'package:lichess_mobile/src/view/user/search_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/variant_app_bar_title.dart';
import 'package:share_plus/share_plus.dart';

class BoardEditorScreen extends ConsumerWidget {
  const BoardEditorScreen({super.key, this.params});

  final BoardEditorControllerParams? params;

  static Route<dynamic> buildRoute(BuildContext context, BoardEditorControllerParams? params) {
    return buildScreenRoute(context, screen: BoardEditorScreen(params: params));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardEditorState = ref.watch(boardEditorControllerProvider(params));

    return Scaffold(
      appBar: AppBar(
        title: VariantAppBarTitle(
          variant: boardEditorState.variant,
          title: context.l10n.boardEditor,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'FEN',
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => _FenDialog(
                onFenLoaded: (fen) =>
                    ref.read(boardEditorControllerProvider(params).notifier).loadFen(fen),
              ),
            ),
          ),
          SemanticIconButton(
            semanticsLabel: context.l10n.mobileSharePositionAsFEN,
            onPressed: () => launchShareDialog(context, ShareParams(text: boardEditorState.fen)),
            icon: const PlatformShareIcon(),
          ),
        ],
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final aspectRatio = constraints.biggest.aspectRatio;

            final defaultBoardSize = constraints.biggest.shortestSide;
            final isTablet = isTabletOrLarger(context);
            final boardSize = defaultBoardSize;

            final direction = aspectRatio > 1 ? Axis.horizontal : Axis.vertical;

            return Flex(
              direction: direction,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _PieceMenu(
                  boardSize,
                  params: params,
                  direction: flipAxis(direction),
                  side: boardEditorState.orientation.opposite,
                  isTablet: isTablet,
                ),
                _BoardEditor(
                  boardSize,
                  params: params,
                  orientation: boardEditorState.orientation,
                  isTablet: isTablet,
                  // unlockView is safe because chessground will never modify the pieces
                  pieces: boardEditorState.pieces.unlockView,
                ),
                _PieceMenu(
                  boardSize,
                  params: params,
                  direction: flipAxis(direction),
                  side: boardEditorState.orientation,
                  isTablet: isTablet,
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _BottomBar(params),
    );
  }
}

class _BoardEditor extends ConsumerWidget {
  const _BoardEditor(
    this.boardSize, {
    required this.params,
    required this.isTablet,
    required this.orientation,
    required this.pieces,
  });

  final BoardEditorControllerParams? params;
  final double boardSize;
  final bool isTablet;
  final Side orientation;
  final Pieces pieces;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(boardEditorControllerProvider(params));
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return ChessboardEditor(
      size: boardSize,
      pieces: pieces,
      orientation: orientation,
      settings: boardPrefs.toBoardSettings().copyWith(
        borderRadius: isTablet ? Styles.boardBorderRadius : BorderRadius.zero,
        boxShadow: isTablet ? boardShadows : const <BoxShadow>[],
      ),
      pointerMode: editorState.editorPointerMode,
      onDiscardedPiece: (Square square) =>
          ref.read(boardEditorControllerProvider(params).notifier).discardPiece(square),
      onDroppedPiece: (Square? origin, Square dest, Piece piece) =>
          ref.read(boardEditorControllerProvider(params).notifier).movePiece(origin, dest, piece),
      onEditedSquare: (Square square) =>
          ref.read(boardEditorControllerProvider(params).notifier).editSquare(square),
    );
  }
}

class _PieceMenu extends ConsumerStatefulWidget {
  const _PieceMenu(
    this.boardSize, {
    required this.params,
    required this.direction,
    required this.side,
    required this.isTablet,
  });

  final BoardEditorControllerParams? params;

  final double boardSize;

  final Axis direction;

  final Side side;

  final bool isTablet;

  @override
  ConsumerState<_PieceMenu> createState() => _PieceMenuState();
}

class _PieceMenuState extends ConsumerState<_PieceMenu> {
  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final editorController = boardEditorControllerProvider(widget.params);
    final editorState = ref.watch(editorController);

    final squareSize = widget.boardSize / 8;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: widget.isTablet ? Styles.boardBorderRadius : BorderRadius.zero,
        boxShadow: widget.isTablet ? boardShadows : const <BoxShadow>[],
      ),
      child: ColoredBox(
        color: Theme.of(context).disabledColor,
        child: Flex(
          direction: widget.direction,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: squareSize,
              height: squareSize,
              child: ColoredBox(
                key: Key('drag-button-${widget.side.name}'),
                color: editorState.editorPointerMode == EditorPointerMode.drag
                    ? context.lichessColors.good
                    : Colors.transparent,
                child: GestureDetector(
                  onTap: () =>
                      ref.read(editorController.notifier).updateMode(EditorPointerMode.drag),
                  child: Icon(CupertinoIcons.hand_draw, size: 0.9 * squareSize),
                ),
              ),
            ),
            ...Role.values.map((role) {
              final piece = Piece(role: role, color: widget.side);
              final pieceWidget = PieceWidget(
                piece: piece,
                size: squareSize,
                pieceAssets: boardPrefs.pieceSet.assets,
              );

              return ColoredBox(
                key: Key('piece-button-${piece.color.name}-${piece.role.name}'),
                color:
                    ref.read(boardEditorControllerProvider(widget.params)).activePieceOnEdit ==
                        piece
                    ? ColorScheme.of(context).primary
                    : Colors.transparent,
                child: GestureDetector(
                  child: Draggable(
                    data: Piece(role: role, color: widget.side),
                    feedback: PieceDragFeedback(
                      piece: piece,
                      squareSize: squareSize,
                      pieceAssets: boardPrefs.pieceSet.assets,
                    ),
                    child: pieceWidget,
                    onDragEnd: (_) =>
                        ref.read(editorController.notifier).updateMode(EditorPointerMode.drag),
                  ),
                  onTap: () =>
                      ref.read(editorController.notifier).updateMode(EditorPointerMode.edit, piece),
                ),
              );
            }),
            SizedBox(
              key: Key('delete-button-${widget.side.name}'),
              width: squareSize,
              height: squareSize,
              child: ColoredBox(
                color: editorState.deletePiecesActive
                    ? context.lichessColors.error
                    : Colors.transparent,
                child: GestureDetector(
                  onTap: () => {
                    ref.read(editorController.notifier).updateMode(EditorPointerMode.edit, null),
                  },
                  child: Icon(CupertinoIcons.delete, size: 0.8 * squareSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar(this.params);

  final BoardEditorControllerParams? params;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorController = boardEditorControllerProvider(params);
    final editorState = ref.watch(editorController);
    final pieceCount = editorState.pieces.length;

    return BottomBar(
      children: [
        BottomBarButton(
          icon: Icons.menu,
          label: context.l10n.menu,
          onTap: () => showAdaptiveActionSheet<void>(
            context: context,
            actions: [
              if (editorState.variant != Variant.chess960 &&
                  editorState.variant != Variant.fromPosition)
                BottomSheetAction(
                  makeLabel: (context) => Text(context.l10n.startPosition),
                  onPressed: () {
                    ref
                        .read(editorController.notifier)
                        .loadFen(editorState.variant.initialPosition.fen);
                  },
                ),
              BottomSheetAction(
                makeLabel: (context) => Text(context.l10n.loadPosition),
                onPressed: () {
                  final notifier = ref.read(editorController.notifier);
                  Navigator.of(context).push(
                    BoardEditorPositionsScreen.buildRoute(
                      context,
                      onPositionSelected: (position) => {
                        notifier.loadFen(position.fen),
                        Navigator.of(context).pop(),
                      },
                    ),
                  );
                },
              ),
              if (editorState.variant == Variant.standard)
                BottomSheetAction(
                  // TODO: l10n
                  makeLabel: (context) => const Text('Challenge from position'),
                  onPressed: () {
                    final authUser = ref.read(authControllerProvider);
                    if (authUser == null) {
                      showSnackBar(
                        context,
                        context.l10n.challengeRegisterToSendChallenges,
                        type: SnackBarType.error,
                      );
                      return;
                    }
                    Navigator.of(context).push(
                      SearchScreen.buildRoute(
                        context,
                        onUserTap: (user) {
                          if (user.id == authUser.user.id) {
                            showSnackBar(
                              context,
                              'You cannot challenge yourself',
                              type: SnackBarType.error,
                            );
                          }
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            useRootNavigator: true,
                            builder: (context) {
                              return CreateChallengeBottomSheet(user, positionFen: editorState.fen);
                            },
                          );
                        },
                        // TODO: l10n
                        title: const Text('Challenge from position'),
                      ),
                    );
                  },
                ),
              BottomSheetAction(
                makeLabel: (context) => Text(context.l10n.variant),
                onPressed: () => showChoicePicker<Variant>(
                  context,
                  choices: readSupportedVariants
                      .where(
                        // TODO, for chess960 to be meaningful here, we'd need to display a dialog to load one of the starting positions
                        (variant) => variant != Variant.fromPosition && variant != Variant.chess960,
                      )
                      .toList(),
                  selectedItem: editorState.variant,
                  labelBuilder: (Variant variant) => Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(variant.icon),
                          alignment: PlaceholderAlignment.middle,
                        ),
                        const WidgetSpan(child: SizedBox(width: 8)),
                        TextSpan(text: variant.label),
                      ],
                    ),
                  ),
                  onSelectedItemChanged: (Variant variant) {
                    if (variant != editorState.variant) {
                      ref.read(editorController.notifier).setVariant(variant);
                    }
                  },
                ),
              ),
              if (editorState.pgn != null && pieceCount > 0 && pieceCount <= 32)
                BottomSheetAction(
                  makeLabel: (context) => Text(context.l10n.continueFromHere),
                  onPressed: () => _showContinueFromHereMenu(context, editorState.fen),
                ),
              BottomSheetAction(
                makeLabel: (context) => Text(context.l10n.clearBoard),
                onPressed: () {
                  ref.read(editorController.notifier).loadFen(kEmptyFen);
                },
              ),
            ],
          ),
        ),
        BottomBarButton(
          key: const Key('flip-button'),
          label: context.l10n.flipBoard,
          onTap: ref.read(boardEditorControllerProvider(params).notifier).flipBoard,
          icon: CupertinoIcons.arrow_2_squarepath,
        ),
        BottomBarButton(
          key: const Key('analysis-board-button'),
          label: context.l10n.analysis,
          onTap:
              editorState.pgn != null &&
                  // 1 condition (of many) where stockfish segfaults
                  (pieceCount > 0 && (pieceCount <= 32 || editorState.variant == Variant.horde))
              ? () {
                  Navigator.of(context).push(
                    AnalysisScreen.buildRoute(
                      context,
                      AnalysisOptions.pgn(
                        id: const StringId('board_editor_position'),
                        orientation: editorState.orientation,
                        pgn: editorState.pgn!,
                        isComputerAnalysisAllowed: true,
                        variant: editorState.variant.rule == Rule.chess
                            ? Variant.fromPosition
                            : editorState.variant,
                      ),
                    ),
                  );
                }
              : null,
          icon: Icons.biotech,
        ),
        BottomBarButton(
          label: 'Filters',
          onTap: () => showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) => BoardEditorFilters(params: params),
            showDragHandle: true,
            constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height * 0.5),
          ),
          icon: Icons.tune,
        ),
      ],
    );
  }

  Future<void> _showContinueFromHereMenu(BuildContext context, String fen) {
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.playAgainstComputer),
          onPressed: () => Navigator.of(
            context,
          ).push(OfflineComputerGameScreen.buildRoute(context, initialFen: fen)),
        ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.mobileOverTheBoard),
          onPressed: () =>
              Navigator.of(context).push(OverTheBoardScreen.buildRoute(context, initialFen: fen)),
        ),
      ],
    );
  }
}

class _FenDialog extends StatefulWidget {
  const _FenDialog({required this.onFenLoaded});

  final void Function(String fen) onFenLoaded;

  @override
  State<_FenDialog> createState() => _FenDialogState();
}

class _FenDialogState extends State<_FenDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text == null || !mounted) return;

    final text = data!.text!.trim();
    if (text.isEmpty) return;

    _controller.text = text;
    try {
      final pos = Chess.fromSetup(Setup.parseFen(text));
      widget.onFenLoaded(pos.fen);
    } catch (_) {
      showSnackBar(context, context.l10n.invalidFen, type: SnackBarType.error);
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: _controller,
        readOnly: true,
        onTap: _pasteFromClipboard,
        decoration: InputDecoration(
          hintText: context.l10n.pasteTheFenStringHere,
          suffixIcon: IconButton(
            icon: const Icon(Icons.paste),
            onPressed: _pasteFromClipboard,
            tooltip: 'Paste from clipboard',
          ),
        ),
      ),
    );
  }
}
