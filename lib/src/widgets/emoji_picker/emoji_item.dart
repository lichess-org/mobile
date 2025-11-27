import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';

class EmojiItem extends StatelessWidget {
  const EmojiItem({super.key, required this.onTap, required this.emoji, this.size = 24});

  final VoidCallback onTap;

  final String emoji;

  // size of the emoji, font size
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      alignment: Alignment.center,
      icon: CachedHttpNetworkImage(
        emoji,
        errorWidget: (_, _, _) => kEmptyWidget,
        width: size,
        height: size,
      ),
    );
  }
}
