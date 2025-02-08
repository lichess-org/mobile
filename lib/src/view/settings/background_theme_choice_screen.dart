import 'dart:io';
import 'dart:math' show max;
import 'dart:ui' as ui;

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart' show Side, kInitialFEN;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/theme.dart';
import 'package:lichess_mobile/src/utils/image.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/background.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:material_color_utilities/score/score.dart';
import 'package:path/path.dart';

class BackgroundChoiceScreen extends StatelessWidget {
  const BackgroundChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FullScreenBackground(
      child: PlatformWidget(androidBuilder: _androidBuilder, iosBuilder: _iosBuilder),
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(context.l10n.background)), body: _Body());
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(navigationBar: const CupertinoNavigationBar(), child: _Body());
  }
}

const colorChoices = BackgroundTheme.values;
const itemsByRow = 3;

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appDocumentsDirectory =
        ref.read(preloadedDataProvider).requireValue.appDocumentsDirectory;
    final boardPrefs = ref.watch(boardPreferencesProvider);

    final viewport = MediaQuery.sizeOf(context);
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    return ListView(
      children: [
        if (appDocumentsDirectory != null) ...[
          ListSection(
            children: [
              PlatformListTile(
                leading: const Icon(Icons.image_outlined),
                title: const Text('Pick an image'),
                trailing:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? const CupertinoListTileChevron()
                        : null,
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final maxDimension = max(viewport.width, viewport.height) * devicePixelRatio;
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: maxDimension,
                    maxHeight: maxDimension,
                    imageQuality: 80,
                  );

                  if (image != null) {
                    final decodedImage = await decodeImageFromList(await image.readAsBytes());
                    final imageProvider = FileImage(File(image.path));
                    final quantizerResult = await extractColorsFromImageProvider(imageProvider);
                    final Map<int, int> colorToCount = quantizerResult.colorToCount.map(
                      (int key, int value) => MapEntry<int, int>(getArgbFromAbgr(key), value),
                    );
                    // Score colors for color scheme suitability.
                    final List<int> scoredResults = Score.score(colorToCount, desired: 1);
                    final ui.Color baseColor = Color(scoredResults.first);
                    final meanLuminance =
                        colorToCount.entries.fold<double>(
                          0,
                          (double previousValue, MapEntry<int, int> entry) =>
                              previousValue + Color(entry.key).computeLuminance() * entry.value,
                        ) /
                        colorToCount.values.fold<int>(
                          0,
                          (int previousValue, int element) => previousValue + element,
                        );

                    if (context.mounted) {
                      Navigator.of(context, rootNavigator: true)
                          .push(
                            MaterialPageRoute<BackgroundImage?>(
                              builder:
                                  (_) => ConfirmImageBackgroundScreen(
                                    boardPrefs: boardPrefs,
                                    image: image,
                                    baseColor: baseColor,
                                    meanLuminance: meanLuminance,
                                    viewport: viewport,
                                    imageSize: Size(
                                      decodedImage.width.toDouble(),
                                      decodedImage.height.toDouble(),
                                    ),
                                    appDocumentsDirectory: appDocumentsDirectory,
                                  ),
                              fullscreenDialog: true,
                            ),
                          )
                          .then((value) {
                            if (context.mounted && value != null) {
                              ref
                                  .read(generalPreferencesProvider.notifier)
                                  .setBackground(backgroundImage: value);
                              Navigator.pop(context);
                            }
                          });
                    }
                  }
                },
              ),
            ],
          ),
          const Padding(
            padding: Styles.horizontalBodyPadding,
            child: Text('Custom background works only in dark mode. A dark image is recommended.'),
          ),
        ],
        ListSection(
          header: const SettingsSectionTitle('Presets'),
          backgroundColor: ColorScheme.of(context).surfaceContainerLowest,
          children: [
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

                return GestureDetector(
                  onTap:
                      () => Navigator.of(context, rootNavigator: true)
                          .push(
                            MaterialPageRoute<bool?>(
                              builder:
                                  (_) => ConfirmColorBackgroundScreen(
                                    boardPrefs: boardPrefs,
                                    color: t.color,
                                  ),
                              fullscreenDialog: true,
                            ),
                          )
                          .then((value) {
                            if (context.mounted) {
                              if (value == true) {
                                ref
                                    .read(generalPreferencesProvider.notifier)
                                    .setBackground(backgroundTheme: t);
                                Navigator.pop(context);
                              }
                            }
                          }),
                  child: SizedBox.expand(child: ColoredBox(color: t.color)),
                );
              },
              itemCount: colorChoices.length,
            ),
          ],
        ),
      ],
    );
  }
}

class ConfirmColorBackgroundScreen extends StatelessWidget {
  const ConfirmColorBackgroundScreen({required this.color, required this.boardPrefs, super.key});

  final Color color;
  final BoardPrefs boardPrefs;

  @override
  Widget build(BuildContext context) {
    return _BackgroundTheme(
      baseTheme: BackgroundImage.getTheme(color),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final orientation =
                constraints.maxWidth > constraints.maxHeight
                    ? Orientation.landscape
                    : Orientation.portrait;
            final landscapeBoardPadding = MediaQuery.paddingOf(context).top + 60.0;
            return Stack(
              children: [
                ColoredBox(color: color, child: const SizedBox.expand()),
                Positioned.fill(
                  child: IgnorePointer(
                    child: Align(
                      alignment:
                          orientation == Orientation.portrait
                              ? Alignment.center
                              : Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: orientation == Orientation.portrait ? 0 : 16.0,
                        ),
                        child: Chessboard.fixed(
                          size:
                              orientation == Orientation.portrait
                                  ? constraints.maxWidth
                                  : constraints.maxHeight - landscapeBoardPadding * 2,
                          fen: kInitialFEN,
                          orientation: Side.white,
                          settings: boardPrefs.toBoardSettings(),
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
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}

class ConfirmImageBackgroundScreen extends StatefulWidget {
  const ConfirmImageBackgroundScreen({
    required this.image,
    required this.boardPrefs,
    required this.meanLuminance,
    required this.baseColor,
    required this.imageSize,
    required this.viewport,
    required this.appDocumentsDirectory,
    super.key,
  });

  final XFile image;
  final BoardPrefs boardPrefs;
  final Color baseColor;
  final double meanLuminance;
  final Size imageSize;
  final Size viewport;
  final Directory appDocumentsDirectory;

  Orientation get viewportOrientation =>
      viewport.width > viewport.height ? Orientation.landscape : Orientation.portrait;

  Orientation get imageOrientation =>
      imageSize.width > imageSize.height ? Orientation.landscape : Orientation.portrait;

  BoxFit get boxFit =>
      imageOrientation == viewportOrientation
          ? BoxFit.cover
          : imageOrientation == Orientation.portrait
          ? BoxFit.fitWidth
          : BoxFit.fitHeight;

  Size get imageFitSize => FullScreenBackgroundImage.imageFitSize(boxFit, imageSize, viewport);

  Matrix4 get centerWidthMatrix =>
      Matrix4.translationValues((viewport.width - imageFitSize.width) / 2, 0, 0);

  Matrix4 get centerHeightMatrix =>
      Matrix4.translationValues(0, (viewport.height - imageFitSize.height) / 2, 0);

  @override
  State<ConfirmImageBackgroundScreen> createState() => _ConfirmImageBackgroundScreenState();
}

class _ConfirmImageBackgroundScreenState extends State<ConfirmImageBackgroundScreen> {
  bool blur = false;
  bool showBoard = true;

  late final TransformationController _controller;
  Matrix4 _transformationMatrix = Matrix4.identity();

  @override
  void initState() {
    super.initState();
    final initialMatrix =
        widget.imageOrientation == widget.viewportOrientation
            ? Matrix4.identity()
            : widget.imageOrientation == Orientation.landscape
            ? widget.centerWidthMatrix
            : widget.centerHeightMatrix;
    _controller = TransformationController(initialMatrix);
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
    final baseTheme = BackgroundImage.getTheme(widget.baseColor);
    final filterColor = BackgroundImage.getFilterColor(
      baseTheme.colorScheme.surface,
      widget.meanLuminance,
    );

    final landscapeBoardPadding = MediaQuery.paddingOf(context).top + 60.0;

    return _BackgroundTheme(
      baseTheme: baseTheme,
      child: Scaffold(
        body: Stack(
          children: [
            InteractiveViewer(
              transformationController: _controller,
              constrained: false,
              minScale: 1,
              maxScale: 2,
              child: Container(
                width: switch (widget.boxFit) {
                  BoxFit.fitHeight => widget.imageFitSize.width,
                  _ => widget.viewport.width,
                },
                height: switch (widget.boxFit) {
                  BoxFit.fitWidth => widget.imageFitSize.height,
                  _ => widget.viewport.height,
                },
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.file(File(widget.image.path)).image,
                    colorFilter: ColorFilter.mode(filterColor, BlendMode.srcOver),
                    fit: widget.boxFit,
                  ),
                ),
                child: BackdropFilter(
                  enabled: blur,
                  filter: ui.ImageFilter.blur(
                    sigmaX: kBackgroundImageBlurFactor,
                    sigmaY: kBackgroundImageBlurFactor,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment:
                    widget.viewportOrientation == Orientation.portrait
                        ? Alignment.center
                        : Alignment.centerLeft,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: showBoard ? 1 : 0,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: widget.viewportOrientation == Orientation.portrait ? 0 : 16.0,
                      ),
                      child: Chessboard.fixed(
                        size:
                            widget.viewportOrientation == Orientation.portrait
                                ? widget.viewport.width
                                : widget.viewport.height - landscapeBoardPadding * 2,
                        fen: kInitialFEN,
                        orientation: Side.white,
                        settings: widget.boardPrefs.toBoardSettings(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 26.0,
              left: widget.viewportOrientation == Orientation.portrait ? 0 : null,
              right: 0,
              child: Center(
                child: PlatformCard(
                  margin: const EdgeInsets.all(16.0),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: AdaptiveInkWell(
                    onTap: () {
                      setState(() {
                        blur = !blur;
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(blur ? Icons.check_circle : Icons.circle_outlined, size: 16),
                          const SizedBox(width: 6.0),
                          const Text('Blur the image', textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.paddingOf(context).bottom,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AdaptiveTextButton(
                    child: Text(showBoard ? 'Hide board' : 'Show board'),
                    onPressed:
                        () => {
                          setState(() {
                            showBoard = !showBoard;
                          }),
                        },
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AdaptiveTextButton(
                        child: Text(context.l10n.cancel),
                        onPressed: () => Navigator.pop(context, null),
                      ),
                      const SizedBox(width: 10.0),
                      AdaptiveTextButton(
                        child: Text(context.l10n.accept),
                        onPressed: () async {
                          final ext = extension(widget.image.path);
                          final relativePath = 'custom-board-background$ext';
                          final targetPath = '${widget.appDocumentsDirectory.path}/$relativePath';
                          await FileImage(File(targetPath)).evict();
                          await File(widget.image.path).copy(targetPath);
                          if (context.mounted) {
                            return Navigator.pop<BackgroundImage>(
                              context,
                              BackgroundImage(
                                path: relativePath,
                                transform: _transformationMatrix,
                                isBlurred: blur,
                                seedColor: widget.baseColor,
                                meanLuminance: widget.meanLuminance,
                                width: widget.imageSize.width,
                                height: widget.imageSize.height,
                                viewportWidth: widget.viewport.width,
                                viewportHeight: widget.viewport.height,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Applies the background theme, based on [baseTheme], to the child widget.
///
/// This is used to try new background themes without changing the whole app theme.
class _BackgroundTheme extends StatelessWidget {
  const _BackgroundTheme({required this.baseTheme, required this.child});

  final ThemeData baseTheme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoThemeData(
      applyThemeToAll: true,
      primaryColor: baseTheme.colorScheme.primary,
      primaryContrastingColor: baseTheme.colorScheme.onPrimary,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: baseTheme.scaffoldBackgroundColor,
      barBackgroundColor: baseTheme.colorScheme.surface.withValues(alpha: 0.9),
      textTheme: cupertinoTextTheme(baseTheme.colorScheme),
    );

    return Theme(
      data: baseTheme,
      child: CupertinoTheme(
        data: cupertinoTheme,
        child: IconTheme(
          data: IconThemeData(color: cupertinoTheme.textTheme.textStyle.color),
          child: DefaultTextStyle.merge(style: cupertinoTheme.textTheme.textStyle, child: child),
        ),
      ),
    );
  }
}
