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
      child: Text(categoryI18n, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  // map category id to i18n string
  String get categoryI18n {
    switch (category.id) {
      case 'people':
        return configuration.i18n.people;
      case 'nature':
        return configuration.i18n.nature;
      case 'foods':
        return configuration.i18n.foods;
      case 'activity':
        return configuration.i18n.activity;
      case 'places':
        return configuration.i18n.places;
      case 'objects':
        return configuration.i18n.objects;
      case 'symbols':
        return configuration.i18n.symbols;
      case 'flags':
        return configuration.i18n.flags;
      default:
        return category.id;
    }
  }
}
