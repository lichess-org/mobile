import 'dart:io';
import 'dart:ui' show ImageFilter;

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart' show Side, kInitialFEN;
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/board_theme.dart' as wrapper;
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:path_provider/path_provider.dart';

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

const colorChoices = BoardBackgroundTheme.values;

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    void onChanged(BoardBackgroundTheme? value) =>
        ref.read(boardPreferencesProvider.notifier).setBackgroundTheme(value);

    final brightness = Theme.of(context).brightness;

    const itemsByRow = 4;

    final viewport = MediaQuery.sizeOf(context);
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    return ListView(
      children: [
        ListSection(
          children: [
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: const Text('Pick an image'),
              trailing:
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? const CupertinoListTileChevron()
                      : null,
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: viewport.width * devicePixelRatio * 2,
                  maxHeight: viewport.height * devicePixelRatio * 2,
                  imageQuality: 80,
                );

                if (context.mounted && image != null) {
                  Navigator.of(context, rootNavigator: true)
                      .push(
                        MaterialPageRoute<BoardBackgroundImage?>(
                          builder:
                              (_) => ConfirmImageBackgroundScreen(
                                boardPrefs: boardPrefs,
                                image: image,
                              ),
                          fullscreenDialog: true,
                        ),
                      )
                      .then((value) {
                        if (context.mounted && value != null) {
                          ref.read(boardPreferencesProvider.notifier).setBackgroundImage(value);
                          Navigator.pop(context);
                        }
                      });
                }
              },
            ),
          ],
        ),

        GridView.builder(
          primary: false,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: itemsByRow,
            crossAxisSpacing: 6.0,
            mainAxisSpacing: 6.0,
            childAspectRatio: 0.5,
          ),
          itemBuilder: (context, index) {
            final t = colorChoices[index];
            final fsd = t.getFlexScheme(boardPrefs.boardTheme);

            final theme =
                brightness == Brightness.light
                    ? FlexThemeData.light(
                      colors: fsd.light,
                      surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
                      blendLevel: 16,
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
                                (_) => ConfirmColorBackgroundScreen(
                                  boardPrefs: boardPrefs,
                                  initialIndex: index,
                                ),
                            fullscreenDialog: true,
                          ),
                        )
                        .then((value) {
                          if (context.mounted) {
                            if (value != null) {
                              onChanged(colorChoices[value.toInt()]);
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
          itemCount: colorChoices.length,
        ),
      ],
    );
  }
}

class ConfirmColorBackgroundScreen extends StatefulWidget {
  const ConfirmColorBackgroundScreen({
    required this.initialIndex,
    required this.boardPrefs,
    super.key,
  });

  final int initialIndex;
  final BoardPrefs boardPrefs;

  @override
  State<ConfirmColorBackgroundScreen> createState() => _ConfirmBackgroundScreenState();
}

class _ConfirmBackgroundScreenState extends State<ConfirmColorBackgroundScreen> {
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
              final backgroundTheme = colorChoices[index];
              return wrapper.BoardBackgroundThemeWidget(
                backgroundTheme: backgroundTheme,
                child: const Scaffold(body: SizedBox.expand()),
              );
            },
            itemCount: colorChoices.length,
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
      persistentFooterButtons: [
        AdaptiveTextButton(
          child: Text(context.l10n.cancel),
          onPressed: () => Navigator.pop(context, null),
        ),
        AdaptiveTextButton(
          child: Text(context.l10n.accept),
          onPressed: () => Navigator.pop(context, _controller.page),
        ),
      ],
    );
  }
}

class ConfirmImageBackgroundScreen extends StatefulWidget {
  const ConfirmImageBackgroundScreen({required this.image, required this.boardPrefs, super.key});

  final XFile image;
  final BoardPrefs boardPrefs;

  @override
  State<ConfirmImageBackgroundScreen> createState() => _ConfirmImageBackgroundScreenState();
}

class _ConfirmImageBackgroundScreenState extends State<ConfirmImageBackgroundScreen> {
  bool blur = false;

  final _controller = TransformationController();
  Matrix4 _transformationMatrix = Matrix4.identity();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      _transformationMatrix = _controller.value;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              InteractiveViewer(
                transformationController: _controller,
                constrained: false,
                minScale: 1,
                maxScale: 2,
                child: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.file(File(widget.image.path)).image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    enabled: blur,
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: IgnorePointer(
                    child: Chessboard.fixed(
                      size: MediaQuery.sizeOf(context).width,
                      fen: kInitialFEN,
                      orientation: Side.white,
                      settings: widget.boardPrefs.toBoardSettings(),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.paddingOf(context).bottom + 16.0,
                left: 0,
                right: 0,
                child: Center(
                  child: PlatformCard(
                    child: AdaptiveInkWell(
                      onTap: () {
                        setState(() {
                          blur = !blur;
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Text('Blur image', textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      persistentFooterButtons: [
        AdaptiveTextButton(
          child: Text(context.l10n.cancel),
          onPressed: () => Navigator.pop(context, null),
        ),
        AdaptiveTextButton(
          child: Text(context.l10n.accept),
          onPressed: () async {
            final directory = await getApplicationDocumentsDirectory();
            final targetPath = '${directory.path}/custom-board-background.jpg';
            final darkScheme = await ColorScheme.fromImageProvider(
              provider: FileImage(File(widget.image.path)),
              brightness: Brightness.dark,
            );
            await FileImage(File(targetPath)).evict();
            await File(widget.image.path).copy(targetPath);
            if (context.mounted) {
              return Navigator.pop<BoardBackgroundImage>(context, (
                path: targetPath,
                transform: _transformationMatrix,
                isBlurred: blur,
                darkColors: darkScheme,
              ));
            }
          },
        ),
      ],
    );
  }
}
