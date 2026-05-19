import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

//Widget to indicate the side of the player based on the current theme.
class SideIndicator extends StatelessWidget {
  const SideIndicator({super.key, required this.side, required this.size});

  final Side side;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return isLight
        ? Icon(side == .white ? Icons.circle_outlined : Icons.circle, size: size)
        : Icon(side == .white ? Icons.circle : Icons.circle_outlined, size: size);
  }
}
