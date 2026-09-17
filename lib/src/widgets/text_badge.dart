import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:material_ui/material_ui.dart';

// A simple badge widget to display text in a pill-shaped container.
class const TextBadge({
  super.key,
  required final String text,
  final Color badgeColor = LichessColors.red,
  final Color textColor = Colors.white,
}) extends StatelessWidget {
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
