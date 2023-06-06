import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';

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

void showPlatformSnackbar(BuildContext context, String message) {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    case TargetPlatform.iOS:
      showCupertinoErrorSnackBar(
        context: context,
        message: message,
      );
    default:
      assert(false, 'Unexpected platform $defaultTargetPlatform');
  }
}

// TODO add message queue and possibility to clear it
void showCupertinoErrorSnackBar({
  required BuildContext context,
  required String message,
  Duration duration = const Duration(milliseconds: 4000),
}) {
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      // default iOS tab bar height + 10
      bottom: 60.0,
      left: 8.0,
      right: 8.0,
      child: _CupertinoSnackBar(message: message, duration: duration),
    ),
  );
  Future.delayed(
    duration + _snackBarAnimationDuration * 2,
    overlayEntry.remove,
  );
  Overlay.of(Navigator.of(context).context).insert(overlayEntry);
}

const _snackBarAnimationDuration = Duration(milliseconds: 400);

class _CupertinoSnackBar extends StatefulWidget {
  final String message;
  final Duration duration;

  const _CupertinoSnackBar({
    required this.message,
    required this.duration,
  });

  @override
  State<_CupertinoSnackBar> createState() => _CupertinoSnackBarState();
}

class _CupertinoSnackBarState extends State<_CupertinoSnackBar> {
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
        child: CupertinoPopupSurface(
          isSurfacePainted: true,
          child: ColoredBox(
            color: CupertinoColors.systemRed,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Text(
                widget.message,
                style: const TextStyle(
                  color: CupertinoColors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
