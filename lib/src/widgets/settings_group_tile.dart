import 'package:flutter/material.dart';

/// A tappable [ListTile] that represents a settings value.
class SettingsGroupTile extends StatelessWidget {
  const SettingsGroupTile({
    required this.icon,
    required this.settingsLabel,
    required this.settingsValue,
    required this.onTap,
    super.key,
  });

  final Icon icon;
  final String settingsLabel;
  final String settingsValue;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: '$settingsLabel: $settingsValue',
      excludeSemantics: true,
      child: ListTile(
        leading: icon,
        title: Text(settingsLabel),
        subtitle: Text(settingsValue),
        onTap: onTap,
        trailing: const Icon(Icons.keyboard_arrow_right),
      ),
    );
  }
}
