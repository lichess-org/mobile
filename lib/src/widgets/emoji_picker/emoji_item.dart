import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:material_ui/material_ui.dart';

class const EmojiItem({
  super.key,
  required final VoidCallback onTap,
  required final String emoji,
  final double size = 24,
}) extends StatelessWidget {
  // size of the emoji, font size
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      alignment: Alignment.center,
      icon: HttpNetworkImageWidget(
        emoji,
        errorBuilder: (_, _, _) => kEmptyWidget,
        width: size,
        height: size,
      ),
    );
  }
}
