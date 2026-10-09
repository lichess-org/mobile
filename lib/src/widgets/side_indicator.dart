import 'package:dartchess/dartchess.dart';
import 'package:material_ui/material_ui.dart';

//Widget to indicate the side of the player based on the current theme.
class const SideIndicator({super.key, required final Side side, required final double size})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return isLight
        ? Icon(side == .white ? Icons.circle_outlined : Icons.circle, size: size)
        : Icon(side == .white ? Icons.circle : Icons.circle_outlined, size: size);
  }
}
