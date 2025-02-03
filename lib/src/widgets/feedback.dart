import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/cupertino.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';

class LagIndicator extends StatelessWidget {
  const LagIndicator({
    required this.lagRating,
    this.size = 20.0,
    this.showLoadingIndicator = false,
    super.key,
  }) : assert(lagRating >= 0 && lagRating <= 4);

  /// The lag rating from 0 to 4.
  final int lagRating;

  /// Visual size of the indicator.
  final double size;

  /// Whether to show a loading indicator when the lag rating is 0.
  final bool showLoadingIndicator;

  static const spinKit = SpinKitThreeBounce(color: Colors.grey, size: 15);

  static const cupertinoLevels = {
    0: CupertinoColors.systemRed,
    1: CupertinoColors.systemYellow,
    2: CupertinoColors.systemGreen,
    3: CupertinoColors.systemGreen,
  };

  static const materialLevels = {0: Colors.red, 1: Colors.yellow, 2: Colors.green, 3: Colors.green};

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        children: [
          SignalStrengthIndicator.bars(
            barCount: 4,
            minValue: 1,
            maxValue: 4,
            value: lagRating,
            size: size,
            inactiveColor:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoDynamicColor.resolve(
                      CupertinoColors.systemGrey,
                      context,
                    ).withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.2),
            levels:
                Theme.of(context).platform == TargetPlatform.iOS ? cupertinoLevels : materialLevels,
          ),
          if (showLoadingIndicator && lagRating == 0) spinKit,
        ],
      ),
    );
  }
}

class ConnectivityBanner extends ConsumerWidget {
  const ConnectivityBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityChangesProvider);
    final cupertinoTheme = CupertinoTheme.of(context);
    final theme = Theme.of(context);
    return connectivity.when(
      data: (data) {
        if (data.isOnline) {
          return const SizedBox.shrink();
        }
        return Container(
          height: 45,
          color:
              theme.platform == TargetPlatform.iOS
                  ? cupertinoTheme.scaffoldBackgroundColor
                  : theme.colorScheme.surfaceContainer,
          child: Padding(
            padding: Styles.horizontalBodyPadding,
            child: Row(
              children: [
                const Icon(Icons.report),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    'Network connectivity unavailable.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          theme.platform == TargetPlatform.iOS ? null : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}

/// A adaptive circular progress indicator which size is constrained so it can fit
/// in buttons.
class ButtonLoadingIndicator extends StatelessWidget {
  const ButtonLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
    );
  }
}

/// A centered circular progress indicator
class CenterLoadingIndicator extends StatelessWidget {
  const CenterLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}

/// A screen with an error message and a retry button.
///
/// This widget is intended to be used when a request fails and the user can
/// retry it.
class FullScreenRetryRequest extends StatelessWidget {
  const FullScreenRetryRequest({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(context.l10n.mobileSomethingWentWrong, style: Styles.sectionTitle),
          const SizedBox(height: 10),
          SecondaryButton(
            onPressed: onRetry,
            semanticsLabel: context.l10n.retry,
            child: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }
}

enum SnackBarType { error, info, success }

void showPlatformSnackbar(
  BuildContext context,
  String message, {
  SnackBarType type = SnackBarType.info,
}) {
  switch (Theme.of(context).platform) {
    case TargetPlatform.android:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: type == SnackBarType.error ? const TextStyle(color: Colors.white) : null,
          ),
          backgroundColor: type == SnackBarType.error ? Colors.red : null,
        ),
      );
    case TargetPlatform.iOS:
      showCupertinoSnackBar(context: context, message: message, type: type);
    default:
      assert(false, 'Unexpected platform ${Theme.of(context).platform}');
  }
}

// TODO add message queue and possibility to clear it
void showCupertinoSnackBar({
  required BuildContext context,
  required String message,
  SnackBarType type = SnackBarType.info,
  Duration duration = const Duration(milliseconds: 4000),
}) {
  final overlayEntry = OverlayEntry(
    builder:
        (context) => Positioned(
          // default iOS tab bar height + 10
          bottom: 60.0,
          left: 8.0,
          right: 8.0,
          child: _CupertinoSnackBarManager(
            snackBar: CupertinoSnackBar(
              message: message,
              backgroundColor: (type == SnackBarType.error
                      ? context.lichessColors.error
                      : type == SnackBarType.success
                      ? context.lichessColors.good
                      : CupertinoColors.systemGrey.resolveFrom(context))
                  .withValues(alpha: 0.6),
              textStyle: const TextStyle(color: Colors.white),
            ),
            duration: duration,
          ),
        ),
  );
  Future.delayed(duration + _snackBarAnimationDuration * 2, overlayEntry.remove);
  Overlay.of(context).insert(overlayEntry);
}

class CupertinoSnackBar extends StatelessWidget {
  final String message;
  final TextStyle? textStyle;
  final Color? backgroundColor;

  const CupertinoSnackBar({required this.message, this.textStyle, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return CupertinoMaterialWrapper(
      child: CupertinoPopupSurface(
        isSurfacePainted: true,
        child: ColoredBox(
          color: backgroundColor ?? CupertinoColors.systemGrey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(message, style: textStyle, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}

const _snackBarAnimationDuration = Duration(milliseconds: 400);

class _CupertinoSnackBarManager extends StatefulWidget {
  final CupertinoSnackBar snackBar;
  final Duration duration;

  const _CupertinoSnackBarManager({required this.snackBar, required this.duration});

  @override
  State<_CupertinoSnackBarManager> createState() => _CupertinoSnackBarState();
}

class _CupertinoSnackBarState extends State<_CupertinoSnackBarManager> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => setState(() => _show = true));
    Future.delayed(widget.duration, () {
      if (mounted) {
        setState(() => _show = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _show ? 1.0 : 0,
      duration: _snackBarAnimationDuration,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: widget.snackBar,
        ),
      ),
    );
  }
}
