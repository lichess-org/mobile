import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

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
import 'package:lichess_mobile/src/widgets/background_theme.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:material_color_utilities/quantize/quantizer.dart';
import 'package:material_color_utilities/quantize/quantizer_celebi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class BoardBackgroundThemeChoiceScreen extends StatelessWidget {
  const BoardBackgroundThemeChoiceScreen({super.key});

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
const itemsByRow = 3;

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final brightness = Theme.of(context).brightness;

    final viewport = MediaQuery.sizeOf(context);
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    return ListView(
      children: [
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
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: viewport.width * devicePixelRatio * 2,
                  maxHeight: viewport.height * devicePixelRatio * 2,
                  imageQuality: 80,
                );

                if (image != null) {
                  final imageProvider = FileImage(File(image.path));
                  final darkScheme = await ColorScheme.fromImageProvider(
                    provider: imageProvider,
                    brightness: Brightness.dark,
                  );
                  final quantizerResult = await _extractColorsFromImageProvider(imageProvider);
                  final Map<int, int> colorToCount = quantizerResult.colorToCount.map(
                    (int key, int value) => MapEntry<int, int>(_getArgbFromAbgr(key), value),
                  );
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
                          MaterialPageRoute<BoardBackgroundImage?>(
                            builder:
                                (_) => ConfirmImageBackgroundScreen(
                                  boardPrefs: boardPrefs,
                                  image: image,
                                  darkColorScheme: darkScheme,
                                  meanLuminance: meanLuminance,
                                ),
                            fullscreenDialog: true,
                          ),
                        )
                        .then((value) {
                          if (context.mounted && value != null) {
                            ref
                                .read(boardPreferencesProvider.notifier)
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
        ListSection(
          header: const SettingsSectionTitle('Color presets'),
          cupertinoBackgroundColor: ColorScheme.of(context).surfaceContainerLow,
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
                final fsd = t.getFlexScheme(boardPrefs.boardTheme);

                final theme =
                    brightness == Brightness.light
                        ? FlexThemeData.light(
                          colors: fsd.light,
                          surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
                          blendLevel: t.lightBlend,
                        )
                        : FlexThemeData.dark(
                          colors: fsd.dark,
                          surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
                          blendLevel: t.darkBlend,
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
                                  ref
                                      .read(boardPreferencesProvider.notifier)
                                      .setBackground(backgroundTheme: colorChoices[value.toInt()]);
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
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: autoColor,
                                        ),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final orientation =
              constraints.maxWidth > constraints.maxHeight
                  ? Orientation.landscape
                  : Orientation.portrait;
          final landscapeBoardPadding = MediaQuery.paddingOf(context).top + 16.0;
          return Stack(
            children: [
              PageView.builder(
                controller: _controller,
                itemBuilder: (context, index) {
                  final backgroundTheme = colorChoices[index];
                  return BackgroundThemeWidget(
                    backgroundTheme: backgroundTheme,
                    child: const Scaffold(body: SizedBox.expand()),
                  );
                },
                itemCount: colorChoices.length,
              ),
              Positioned.fill(
                child: Align(
                  alignment:
                      orientation == Orientation.portrait ? Alignment.center : Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: orientation == Orientation.portrait ? 0 : landscapeBoardPadding,
                    ),
                    child: Chessboard.fixed(
                      size:
                          orientation == Orientation.portrait
                              ? constraints.maxWidth
                              : constraints.maxHeight - landscapeBoardPadding * 2,
                      fen: kInitialFEN,
                      orientation: Side.white,
                      settings: widget.boardPrefs.toBoardSettings(),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.paddingOf(context).bottom + 16.0,
                left: orientation == Orientation.portrait ? 0 : null,
                right: 0,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Swipe to display other backgrounds', textAlign: TextAlign.center),
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
          onPressed: () => Navigator.pop(context, _controller.page),
        ),
      ],
    );
  }
}

class ConfirmImageBackgroundScreen extends StatefulWidget {
  const ConfirmImageBackgroundScreen({
    required this.image,
    required this.boardPrefs,
    required this.darkColorScheme,
    required this.meanLuminance,
    super.key,
  });

  final XFile image;
  final BoardPrefs boardPrefs;
  final ColorScheme darkColorScheme;
  final double meanLuminance;

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
    final filterColor = BoardBackgroundImage.getFilterColor(
      widget.darkColorScheme,
      widget.meanLuminance,
    );

    return BackgroundThemeWrapper(
      theme: BoardBackgroundImage.getTheme(widget.darkColorScheme),
      brightness: Brightness.dark,
      transparentScaffold: true,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final orientation =
                constraints.maxWidth > constraints.maxHeight
                    ? Orientation.landscape
                    : Orientation.portrait;
            final landscapeBoardPadding = MediaQuery.paddingOf(context).top + 16.0;
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
                        colorFilter: ColorFilter.mode(filterColor, BlendMode.srcOver),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: BackdropFilter(
                      enabled: blur,
                      filter: ui.ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment:
                        orientation == Orientation.portrait
                            ? Alignment.center
                            : Alignment.centerLeft,
                    child: IgnorePointer(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: orientation == Orientation.portrait ? 0 : landscapeBoardPadding,
                        ),
                        child: Chessboard.fixed(
                          size:
                              orientation == Orientation.portrait
                                  ? constraints.maxWidth
                                  : constraints.maxHeight - landscapeBoardPadding * 2,
                          fen: kInitialFEN,
                          orientation: Side.white,
                          settings: widget.boardPrefs.toBoardSettings(),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.paddingOf(context).top + 26.0,
                  left: orientation == Orientation.portrait ? 0 : null,
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AdaptiveTextButton(
                        child: Text(context.l10n.cancel),
                        onPressed: () => Navigator.pop(context, null),
                      ),
                      const SizedBox(width: 16.0),
                      AdaptiveTextButton(
                        child: Text(context.l10n.accept),
                        onPressed: () async {
                          final directory = await getApplicationDocumentsDirectory();
                          final ext = extension(widget.image.path);
                          final targetPath = '${directory.path}/custom-board-background$ext';
                          await FileImage(File(targetPath)).evict();
                          await File(widget.image.path).copy(targetPath);
                          if (context.mounted) {
                            return Navigator.pop<BoardBackgroundImage>(
                              context,
                              BoardBackgroundImage(
                                path: targetPath,
                                transform: _transformationMatrix,
                                isBlurred: blur,
                                darkColors: widget.darkColorScheme,
                                meanLuminance: widget.meanLuminance,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// --
// code below taken from: https://github.com/flutter/flutter/blob/74669e4bf1352a5134ad68398a6bf7fac0a6473b/packages/flutter/lib/src/material/color_scheme.dart

Future<QuantizerResult> _extractColorsFromImageProvider(ImageProvider imageProvider) async {
  final ui.Image scaledImage = await _imageProviderToScaled(imageProvider);
  final ByteData? imageBytes = await scaledImage.toByteData();

  final QuantizerResult quantizerResult = await QuantizerCelebi().quantize(
    imageBytes!.buffer.asUint32List(),
    128,
    returnInputPixelToClusterPixel: true,
  );
  return quantizerResult;
}

// Scale image size down to reduce computation time of color extraction.
Future<ui.Image> _imageProviderToScaled(ImageProvider imageProvider) async {
  const double maxDimension = 112.0;
  final ImageStream stream = imageProvider.resolve(
    const ImageConfiguration(size: Size(maxDimension, maxDimension)),
  );
  final Completer<ui.Image> imageCompleter = Completer<ui.Image>();
  late ImageStreamListener listener;
  late ui.Image scaledImage;
  Timer? loadFailureTimeout;

  listener = ImageStreamListener(
    (ImageInfo info, bool sync) async {
      loadFailureTimeout?.cancel();
      stream.removeListener(listener);
      final ui.Image image = info.image;
      final int width = image.width;
      final int height = image.height;
      double paintWidth = width.toDouble();
      double paintHeight = height.toDouble();
      assert(width > 0 && height > 0);

      final bool rescale = width > maxDimension || height > maxDimension;
      if (rescale) {
        paintWidth = (width > height) ? maxDimension : (maxDimension / height) * width;
        paintHeight = (height > width) ? maxDimension : (maxDimension / width) * height;
      }
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      paintImage(
        canvas: canvas,
        rect: Rect.fromLTRB(0, 0, paintWidth, paintHeight),
        image: image,
        filterQuality: FilterQuality.none,
      );

      final ui.Picture picture = pictureRecorder.endRecording();
      scaledImage = await picture.toImage(paintWidth.toInt(), paintHeight.toInt());
      imageCompleter.complete(info.image);
    },
    onError: (Object exception, StackTrace? stackTrace) {
      stream.removeListener(listener);
      throw Exception('Failed to render image: $exception');
    },
  );

  loadFailureTimeout = Timer(const Duration(seconds: 5), () {
    stream.removeListener(listener);
    imageCompleter.completeError(TimeoutException('Timeout occurred trying to load image'));
  });

  stream.addListener(listener);
  await imageCompleter.future;
  return scaledImage;
}

// Converts AABBGGRR color int to AARRGGBB format.
int _getArgbFromAbgr(int abgr) {
  const int exceptRMask = 0xFF00FFFF;
  const int onlyRMask = ~exceptRMask;
  const int exceptBMask = 0xFFFFFF00;
  const int onlyBMask = ~exceptBMask;
  final int r = (abgr & onlyRMask) >> 16;
  final int b = abgr & onlyBMask;
  return (abgr & exceptRMask & exceptBMask) | (b << 16) | r;
}
