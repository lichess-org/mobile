import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Wraps a widget in a [Material] widget with a default text color for icons.
class CupertinoMaterialWrapper extends StatelessWidget {
  const CupertinoMaterialWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IconTheme.merge(
      data: IconThemeData(color: CupertinoTheme.of(context).textTheme.textStyle.color),
      child: Material(color: Colors.transparent, child: child),
    );
  }
}
