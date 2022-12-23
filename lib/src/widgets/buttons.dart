import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Platform agnostic button which is used for important actions.
///
/// Will use an [ElevatedButton] on Android and a [CupertinoButton.filled] on iOS.
class FatButton extends StatelessWidget {
  const FatButton(
      {required this.semanticsLabel,
      required this.child,
      required this.onPressed,
      super.key});

  final String semanticsLabel;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      enabled: true,
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoButton.filled(onPressed: onPressed, child: child)
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 18)),
              child: child,
            ),
    );
  }
}

/// Platform agnostic button meant for medium importance actions.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton(
      {required this.semanticsLabel,
      required this.child,
      required this.onPressed,
      this.textStyle,
      super.key});

  final String semanticsLabel;
  final VoidCallback? onPressed;
  final Widget child;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      enabled: true,
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          textStyle: textStyle,
          padding: defaultTargetPlatform == TargetPlatform.iOS
              ? const EdgeInsets.all(10.0)
              : null,
          shape: defaultTargetPlatform == TargetPlatform.iOS
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )
              : null,
        ),
        child: child,
      ),
    );
  }
}
