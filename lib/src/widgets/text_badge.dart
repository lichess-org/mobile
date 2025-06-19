import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';

// A simple badge widget to display text in a pill-shaped container.
class TextBadge extends StatelessWidget {
  const TextBadge({
    super.key,
    required this.text,
    this.badgeColor = LichessColors.red,
    this.textColor = Colors.white,
  });

  final String text;
  final Color badgeColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
      decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(15.0)),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }
}
