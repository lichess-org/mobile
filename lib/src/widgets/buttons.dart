import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/providers.dart';

/// Platform agnostic button which is used for important actions.
///
/// Will use an [ElevatedButton] on Android and a [CupertinoButton.filled] on iOS.
class FatButton extends StatelessWidget {
  const FatButton({
    required this.semanticsLabel,
    required this.child,
    required this.onPressed,
    super.key,
  });

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
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: child,
            ),
    );
  }
}

/// Platform agnostic button meant for medium importance actions.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.semanticsLabel,
    required this.child,
    required this.onPressed,
    this.textStyle,
    super.key,
  });

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
              ? const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                )
              : null,
        ),
        child: child,
      ),
    );
  }
}

/// Cupertino icon button with mandatory semantics label
class CupertinoIconButton extends StatelessWidget {
  const CupertinoIconButton({
    required this.onPressed,
    required this.semanticsLabel,
    required this.icon,
    super.key,
  });
  final VoidCallback? onPressed;
  final Widget icon;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      enabled: true,
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: CupertinoButton(
        // tooltip: context.l10n.settings,
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: icon,
      ),
    );
  }
}

class SoundButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSoundMuted = ref.watch(muteSoundPrefProvider);

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return IconButton(
          icon: isSoundMuted
              ? const Icon(Icons.volume_off)
              : const Icon(Icons.volume_up),
          onPressed: () => ref.read(muteSoundPrefProvider.notifier).toggle(),
        );
      case TargetPlatform.iOS:
        return CupertinoButton(
          padding: EdgeInsets.zero,
          child: isSoundMuted
              ? const Icon(CupertinoIcons.volume_off)
              : const Icon(CupertinoIcons.volume_up),
          onPressed: () => ref.read(muteSoundPrefProvider.notifier).toggle(),
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}
