import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart' show Side, kInitialFEN;
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/board_theme.dart' as wrapper;
import 'package:lichess_mobile/src/widgets/platform.dart';

class BoardBackgroundThemeScreen extends StatelessWidget {
  const BoardBackgroundThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _androidBuilder, iosBuilder: _iosBuilder);
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(context.l10n.background)), body: _Body());
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(navigationBar: const CupertinoNavigationBar(), child: _Body());
  }
}

const choices = BoardBackgroundTheme.values;

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    void onChanged(BoardBackgroundTheme? value) =>
        ref.read(boardPreferencesProvider.notifier).setBackgroundTheme(value);

    final brightness = Theme.of(context).brightness;

    const itemsByRow = 4;

    return GridView.builder(
      padding: MediaQuery.paddingOf(context) + Styles.bodyPadding,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemsByRow,
        crossAxisSpacing: 6.0,
        mainAxisSpacing: 6.0,
        childAspectRatio: 0.5,
      ),
      itemBuilder: (context, index) {
        final t = choices[index];
        final fsd = t.getFlexScheme(boardPrefs.boardTheme);

        final theme =
            brightness == Brightness.light
                ? FlexThemeData.light(
                  colors: fsd.light,
                  surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
                  blendLevel: 20,
                )
                : FlexThemeData.dark(
                  colors: fsd.dark,
                  surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
                  blendLevel: 20,
                );

        final autoColor =
            brightness == Brightness.light
                ? darken(theme.scaffoldBackgroundColor, 0.2)
                : lighten(theme.scaffoldBackgroundColor, 0.2);

        return Tooltip(
          message: 'Background based on chessboard colors.',
          triggerMode: t == BoardBackgroundTheme.board ? null : TooltipTriggerMode.manual,
          child: GestureDetector(
            onTap:
                () => Navigator.of(context, rootNavigator: true)
                    .push(
                      MaterialPageRoute<double?>(
                        builder:
                            (_) => ConfirmBackgroundScreen(
                              boardPrefs: boardPrefs,
                              initialIndex: index,
                            ),
                        fullscreenDialog: true,
                      ),
                    )
                    .then((value) {
                      if (context.mounted) {
                        if (value != null) {
                          onChanged(choices[value.toInt()]);
                          Navigator.pop(context);
                        }
                      }
                    }),
            child: SizedBox.expand(
              child: ColoredBox(
                color: theme.scaffoldBackgroundColor,
                child:
                    t == BoardBackgroundTheme.board
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LichessIcons.chess_board, color: autoColor),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                'auto',
                                style: theme.textTheme.labelSmall?.copyWith(color: autoColor),
                              ),
                            ),
                          ],
                        )
                        : null,
              ),
            ),
          ),
        );
      },
      itemCount: choices.length,
    );
  }
}

class ConfirmBackgroundScreen extends StatefulWidget {
  const ConfirmBackgroundScreen({required this.initialIndex, required this.boardPrefs, super.key});

  final int initialIndex;
  final BoardPrefs boardPrefs;

  @override
  State<ConfirmBackgroundScreen> createState() => _ConfirmBackgroundScreenState();
}

class _ConfirmBackgroundScreenState extends State<ConfirmBackgroundScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: widget.initialIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemBuilder: (context, index) {
              final backgroundTheme = choices[index];
              return wrapper.BoardTheme(
                backgroundTheme: backgroundTheme,
                child: const Scaffold(body: SizedBox.expand()),
              );
            },
            itemCount: choices.length,
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Chessboard.fixed(
                size: MediaQuery.sizeOf(context).width,
                fen: kInitialFEN,
                orientation: Side.white,
                settings: widget.boardPrefs.toBoardSettings(),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.paddingOf(context).bottom + 16.0,
            left: 0,
            right: 0,
            child: const Text('Swipe to display other backgrounds', textAlign: TextAlign.center),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              child: Text(context.l10n.accept),
              onPressed: () => Navigator.pop(context, _controller.page),
            ),
            TextButton(
              child: Text(context.l10n.cancel),
              onPressed: () => Navigator.pop(context, null),
            ),
          ],
        ),
      ),
    );
  }
}
