import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/widgets/emoji_picker/emoji_picker_configuration.dart';
import 'package:lichess_mobile/src/widgets/emoji_picker/emoji_picker_models.dart';

class EmojiSectionHeader extends StatelessWidget {
  const EmojiSectionHeader({super.key, required this.category, required this.configuration});

  final Category category;
  final EmojiPickerConfiguration configuration;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      color: Theme.of(context).colorScheme.surface,
      child: Text(category.name, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
