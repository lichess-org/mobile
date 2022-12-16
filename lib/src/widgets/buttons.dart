import 'package:flutter/material.dart';

/// A tappable ListTile that will push a new screen
class ListNavigateButton extends StatelessWidget {
  const ListNavigateButton({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final Icon icon;
  final String label;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: label,
      excludeSemantics: true,
      child: ListTile(
        leading: icon,
        title: Text(label),
        onTap: onTap,
        trailing: const Icon(Icons.keyboard_arrow_right),
      ),
    );
  }
}

/// A simple wrapper to add a semantic label on important buttons where the visual
/// button label is not enough.
class SemanticsButton extends StatelessWidget {
  const SemanticsButton({
    required this.label,
    required this.child,
    this.enabled = true,
    super.key,
  });

  final String label;
  final ButtonStyleButton child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      enabled: true,
      button: true,
      label: label,
      excludeSemantics: true,
      child: child,
    );
  }
}
