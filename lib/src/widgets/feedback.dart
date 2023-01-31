import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showAdaptiveSnackBar(
  BuildContext context, {
  required Widget content,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: content,
      behavior: defaultTargetPlatform == TargetPlatform.iOS
          ? SnackBarBehavior.floating
          : null,
      margin: defaultTargetPlatform == TargetPlatform.iOS
          ? const EdgeInsets.all(8)
          : null,
      shape: defaultTargetPlatform == TargetPlatform.iOS
          ? const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            )
          : null,
    ),
  );
}
