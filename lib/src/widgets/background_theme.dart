import 'dart:io' show Directory, File;
import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/theme.dart';

const kBackgroundImageBlurFactor = 8.0;

/// Applies the configured theme to the child widget.
///
/// Tries first to apply the theme provided ar argument, and then from the stored settings.
///
/// The background can be a color or an image. If an image is provided, it will be used instead of
/// the color, and the color will be ignored.
///
/// Since the background image is always full screen, this widget should be used to wrap only [Scaffold]
/// or [CupertinoPageScaffold] widgets.
class FullScreenBackgroundTheme extends ConsumerWidget {
  const FullScreenBackgroundTheme({required this.child, this.backgroundTheme, super.key});

  /// The child widget to apply the theme to.
  final Widget child;

  /// The background theme to apply to the child. If null, the theme from the stored settings will be used.
  final BoardBackgroundTheme? backgroundTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final appDocumentsDirectory =
        ref.read(preloadedDataProvider).requireValue.appDocumentsDirectory;

    if (backgroundTheme == null && boardPrefs.backgroundImage == null) {
      return child;
    }

    if (backgroundTheme != null) {
      return _ColoredBackgroundTheme(
        backgroundTheme: backgroundTheme!,
        boardTheme: boardPrefs.boardTheme,
        child: child,
      );
    } else if (boardPrefs.backgroundImage != null && appDocumentsDirectory != null) {
      return FullScreenBackgroundImageTheme(
        backgroundImage: boardPrefs.backgroundImage!,
        viewport: MediaQuery.sizeOf(context),
        appDocumentsDirectory: appDocumentsDirectory,
        child: child,
      );
    } else {
      return child;
    }
  }
}

class _ColoredBackgroundTheme extends StatelessWidget {
  const _ColoredBackgroundTheme({
    required this.backgroundTheme,
    required this.boardTheme,
    required this.child,
  });

  final Widget child;
  final BoardTheme boardTheme;
  final BoardBackgroundTheme backgroundTheme;

  @override
  Widget build(BuildContext context) {
    final (:light, :dark) = makeColoredBackgroundTheme(
      boardTheme,
      backgroundTheme,
      isIOS: Theme.of(context).platform == TargetPlatform.iOS,
    );
    final theme = Theme.of(context).brightness == Brightness.light ? light : dark;
    return Theme(data: theme, child: child);
  }
}

/// Applies a background image theme to the child widget.
///
/// The image is always sized to cover the full screen, and the image is blurred if requested.
/// This is intended to be used with [Scaffold] or [CupertinoPageScaffold] as the child.
class FullScreenBackgroundImageTheme extends StatefulWidget {
  const FullScreenBackgroundImageTheme({
    required this.backgroundImage,
    required this.viewport,
    required this.appDocumentsDirectory,
    required this.child,
  });

  final BoardBackgroundImage backgroundImage;
  final Size viewport;
  final Directory appDocumentsDirectory;
  final Widget child;

  static Size imageFitSize(BoxFit boxFit, Size imageSize, Size viewportSize) => switch (boxFit) {
    BoxFit.fitWidth => Size(
      viewportSize.width,
      imageSize.height * viewportSize.width / imageSize.width,
    ),
    BoxFit.fitHeight => Size(
      imageSize.width * viewportSize.height / imageSize.height,
      viewportSize.height,
    ),
    _ => Size(imageSize.width, imageSize.height),
  };

  @override
  State<FullScreenBackgroundImageTheme> createState() => _FullScreenBackgroundImageState();
}

class _FullScreenBackgroundImageState extends State<FullScreenBackgroundImageTheme> {
  final TransformationController _controller = TransformationController();

  Size get pickedImageViewport =>
      Size(widget.backgroundImage.viewportWidth, widget.backgroundImage.viewportHeight);

  @override
  void initState() {
    _updateMatrix(widget.viewport);
    super.initState();
  }

  @override
  void didUpdateWidget(FullScreenBackgroundImageTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.backgroundImage.transform != oldWidget.backgroundImage.transform ||
        widget.viewport != oldWidget.viewport) {
      _updateMatrix(widget.viewport);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _updateMatrix(Size viewport) {
    final matrix =
        viewport == pickedImageViewport ? widget.backgroundImage.transform : Matrix4.identity();
    _controller.value = matrix;
  }

  @override
  Widget build(BuildContext context) {
    final viewportOrientation =
        widget.viewport.width > widget.viewport.height
            ? Orientation.landscape
            : Orientation.portrait;
    final imageOrientation =
        widget.backgroundImage.width > widget.backgroundImage.height
            ? Orientation.landscape
            : Orientation.portrait;
    final boxFit =
        imageOrientation == viewportOrientation
            ? BoxFit.cover
            : imageOrientation == Orientation.portrait
            ? BoxFit.fitWidth
            : BoxFit.fitHeight;

    final imageFitSize = FullScreenBackgroundImageTheme.imageFitSize(
      boxFit,
      Size(widget.backgroundImage.width, widget.backgroundImage.height),
      widget.viewport,
    );

    final baseTheme = BoardBackgroundImage.getTheme(widget.backgroundImage.seedColor);
    final filterColor = BoardBackgroundImage.getFilterColor(
      baseTheme.colorScheme.surface,
      widget.backgroundImage.meanLuminance,
    );

    return Theme(
      data:
          makeBackgroundImageTheme(
            baseTheme: baseTheme,
            isIOS: Theme.of(context).platform == TargetPlatform.iOS,
          ).dark,
      child: Stack(
        children: [
          InteractiveViewer(
            transformationController: _controller,
            constrained: false,
            minScale: 1,
            maxScale: 2,
            panEnabled: false,
            scaleEnabled: false,
            child: Container(
              width: switch (boxFit) {
                BoxFit.fitHeight => imageFitSize.width,
                _ => widget.viewport.width,
              },
              height: switch (boxFit) {
                BoxFit.fitWidth => imageFitSize.height,
                _ => widget.viewport.height,
              },
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(
                    File('${widget.appDocumentsDirectory.path}/${widget.backgroundImage.path}'),
                  ),
                  fit: boxFit,
                  colorFilter: ColorFilter.mode(filterColor, BlendMode.srcOver),
                ),
              ),
              child: ClipRect(
                child: BackdropFilter(
                  enabled: widget.backgroundImage.isBlurred,
                  filter: ImageFilter.blur(
                    sigmaX: kBackgroundImageBlurFactor,
                    sigmaY: kBackgroundImageBlurFactor,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
          Positioned.fill(child: widget.child),
        ],
      ),
    );
  }
}
