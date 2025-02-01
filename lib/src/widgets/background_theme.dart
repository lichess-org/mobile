import 'dart:io' show Directory, File;
import 'dart:ui' show ImageFilter;

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';

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

    if (backgroundTheme == null &&
        boardPrefs.backgroundTheme == null &&
        boardPrefs.backgroundImage == null) {
      return child;
    }

    if (backgroundTheme != null) {
      return _BoardBackgroundTheme(
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
      return _BoardBackgroundTheme(
        backgroundTheme: boardPrefs.backgroundTheme!,
        boardTheme: boardPrefs.boardTheme,
        child: child,
      );
    }
  }
}

/// Applies the configured background theme to the child widget.
class BackgroundThemeWrapper extends StatelessWidget {
  const BackgroundThemeWrapper({
    required this.child,
    required this.theme,
    required this.brightness,
    this.transparentScaffold = false,
  });

  /// The child widget to apply the theme to.
  final Widget child;

  /// The theme to apply to the child.
  final ThemeData theme;

  /// The brightness of the theme.
  final Brightness brightness;

  /// If true, the scaffold background will be transparent. Useful for displaying a background image.
  final bool transparentScaffold;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final cupertinoTheme = _makeCupertinoTheme(
      theme,
      brightness: brightness,
      transparentScaffold: transparentScaffold,
    );

    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          surface: theme.colorScheme.surface.withValues(alpha: transparentScaffold ? 0.6 : 1),
          surfaceContainerLowest: theme.colorScheme.surfaceContainerLowest.withValues(
            alpha: transparentScaffold ? 0.6 : 1,
          ),
          surfaceContainerLow: theme.colorScheme.surfaceContainerLow.withValues(
            alpha: transparentScaffold ? 0.6 : 1,
          ),
          surfaceContainer: theme.colorScheme.surfaceContainer.withValues(
            alpha: transparentScaffold ? 0.6 : 1,
          ),
          surfaceContainerHigh: theme.colorScheme.surfaceContainerHigh.withValues(
            alpha: transparentScaffold ? 0.6 : 1,
          ),
          surfaceContainerHighest: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: transparentScaffold ? 0.6 : 1,
          ),
          surfaceDim: theme.colorScheme.surfaceDim.withValues(alpha: transparentScaffold ? 0.8 : 1),
          surfaceBright: theme.colorScheme.surfaceBright.withValues(
            alpha: transparentScaffold ? 0.4 : 1,
          ),
        ),
        cupertinoOverrideTheme: cupertinoTheme,
        listTileTheme: ListTileTheme.of(context).copyWith(
          titleTextStyle: isIOS ? cupertinoTheme.textTheme.textStyle : null,
          subtitleTextStyle: isIOS ? cupertinoTheme.textTheme.textStyle : null,
          leadingAndTrailingTextStyle: isIOS ? cupertinoTheme.textTheme.textStyle : null,
        ),
        scaffoldBackgroundColor: theme.scaffoldBackgroundColor.withValues(
          alpha: transparentScaffold ? 0 : 1,
        ),
        splashFactory: isIOS ? NoSplash.splashFactory : null,
        textTheme:
            isIOS
                ? brightness == Brightness.light
                    ? Typography.blackCupertino
                    : Typography.whiteCupertino
                : null,
        extensions: [lichessCustomColors.harmonized(theme.colorScheme)],
      ),
      child: isIOS ? CupertinoTheme(data: cupertinoTheme, child: child) : child,
    );
  }
}

class _BoardBackgroundTheme extends StatelessWidget {
  const _BoardBackgroundTheme({
    required this.backgroundTheme,
    required this.boardTheme,
    required this.child,
  });

  final Widget child;
  final BoardTheme boardTheme;
  final BoardBackgroundTheme backgroundTheme;

  @override
  Widget build(BuildContext context) {
    final flexScheme = backgroundTheme.getFlexScheme(boardTheme);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final lightTheme = FlexThemeData.light(
      colors: flexScheme.light,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
      appBarStyle: isIOS ? null : FlexAppBarStyle.scaffoldBackground,
      blendLevel: backgroundTheme.lightBlend,
    );
    final darkTheme = FlexThemeData.dark(
      colors: flexScheme.dark,
      surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
      blendLevel: backgroundTheme.darkBlend,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      appBarStyle: isIOS ? null : FlexAppBarStyle.scaffoldBackground,
    );

    final brightness = Theme.of(context).brightness;
    final theme = brightness == Brightness.light ? lightTheme : darkTheme;

    return BackgroundThemeWrapper(theme: theme, brightness: brightness, child: child);
  }
}

/// Applies a background image to the child widget.
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

    return BackgroundThemeWrapper(
      theme: widget.backgroundImage.theme,
      brightness: Brightness.dark,
      transparentScaffold: true,
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
                  colorFilter: ColorFilter.mode(
                    widget.backgroundImage.filterColor,
                    BlendMode.srcOver,
                  ),
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

CupertinoThemeData _makeCupertinoTheme(
  ThemeData theme, {
  Brightness brightness = Brightness.light,
  bool transparentScaffold = false,
}) {
  final primary = theme.colorScheme.primary;
  final onPrimary = theme.colorScheme.onPrimary;
  return CupertinoThemeData(
    primaryColor: primary,
    primaryContrastingColor: onPrimary,
    brightness: brightness,
    textTheme: const CupertinoThemeData().textTheme.copyWith(
      primaryColor: primary,
      textStyle: const CupertinoThemeData().textTheme.textStyle.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      navTitleTextStyle: const CupertinoThemeData().textTheme.navTitleTextStyle.copyWith(
        color: Styles.cupertinoTitleColor,
      ),
      navLargeTitleTextStyle: const CupertinoThemeData().textTheme.navLargeTitleTextStyle.copyWith(
        color: Styles.cupertinoTitleColor,
      ),
    ),
    scaffoldBackgroundColor: theme.scaffoldBackgroundColor.withValues(
      alpha: transparentScaffold ? 0 : 1,
    ),
    barBackgroundColor: theme.appBarTheme.backgroundColor?.withValues(
      alpha: transparentScaffold ? 0.5 : 0.9,
    ),
    applyThemeToAll: true,
  );
}
