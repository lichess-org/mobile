import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

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
          color: theme.platform == TargetPlatform.iOS
              ? cupertinoTheme.barBackgroundColor
              : theme.colorScheme.tertiary.withOpacity(0.15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.report),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    'Network connectivity unavailable.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.platform == TargetPlatform.iOS
                          ? null
                          : theme.colorScheme.onSurfaceVariant,
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
      child: CircularProgressIndicator.adaptive(
        strokeWidth: 2,
      ),
    );
  }
}

/// A centered circular progress indicator
class CenterLoadingIndicator extends StatelessWidget {
  const CenterLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}

class FullScreenRetryRequest extends StatelessWidget {
  const FullScreenRetryRequest({
    super.key,
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // TODO translate
          Text(
            'Something went wrong.',
            style: Styles.sectionTitle,
          ),
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

enum SnackBarType {
  error,
  info,
  success,
}

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
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: type == SnackBarType.error ? Colors.red : null,
        ),
      );
    case TargetPlatform.iOS:
      showCupertinoSnackBar(
        context: context,
        message: message,
        type: type,
      );
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
    builder: (context) => Positioned(
      // default iOS tab bar height + 10
      bottom: 60.0,
      left: 8.0,
      right: 8.0,
      child: _CupertinoSnackBarManager(
        snackBar: CupertinoSnackBar(
          message: message,
          backgroundColor: type == SnackBarType.error
              ? CupertinoColors.systemRed
              : type == SnackBarType.success
                  ? CupertinoColors.systemGreen
                  : CupertinoColors.systemBlue,
          textStyle: type == SnackBarType.error
              ? const TextStyle(color: Colors.white)
              : null,
        ),
        duration: duration,
      ),
    ),
  );
  Future.delayed(
    duration + _snackBarAnimationDuration * 2,
    overlayEntry.remove,
  );
  Overlay.of(context).insert(overlayEntry);
}

class CupertinoSnackBar extends StatelessWidget {
  final String message;
  final TextStyle? textStyle;
  final Color? backgroundColor;

  const CupertinoSnackBar({
    required this.message,
    this.textStyle,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPopupSurface(
      isSurfacePainted: true,
      child: ColoredBox(
        color: backgroundColor ?? CupertinoColors.systemGrey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          child: Text(
            message,
            style: textStyle,
            textAlign: TextAlign.center,
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

  const _CupertinoSnackBarManager({
    required this.snackBar,
    required this.duration,
  });

  @override
  State<_CupertinoSnackBarManager> createState() => _CupertinoSnackBarState();
}

class _CupertinoSnackBarState extends State<_CupertinoSnackBarManager> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => setState(() => _show = true));
    Future.delayed(
      widget.duration,
      () {
        if (mounted) {
          setState(() => _show = false);
        }
      },
    );
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
