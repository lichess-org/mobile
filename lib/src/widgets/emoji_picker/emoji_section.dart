import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/widgets/emoji_picker/emoji_picker_models.dart';
import 'package:lichess_mobile/src/widgets/emoji_picker/widget.dart';

typedef EmojiSectionHeaderBuilder = Widget Function(BuildContext context, Category category);

typedef EmojiItemBuilder =
    Widget Function(
      BuildContext context,
      String emojiId,
      String emoji,
      EmojiSelectedCallback callback,
    );

class EmojiSection extends StatelessWidget {
  const EmojiSection({
    super.key,
    required this.configuration,
    required this.emojiData,
    required this.category,
    required this.onEmojiSelected,
    required this.sectionKey,
    this.headerBuilder,
    this.itemBuilder,
    this.skinTone = EmojiSkinTone.none,
  });

  final Key sectionKey;
  final EmojiPickerConfiguration configuration;
  final EmojiData emojiData;
  final Category category;
  final EmojiSkinTone skinTone;
  final EmojiSelectedCallback onEmojiSelected;
  final EmojiSectionHeaderBuilder? headerBuilder;
  final EmojiItemBuilder? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        if (configuration.showSectionHeader)
          PinnedHeaderSliver(
            child:
                headerBuilder?.call(context, category) ??
                EmojiSectionHeader(category: category, configuration: configuration),
          ),
        SliverGrid.builder(
          key: sectionKey,
          itemCount: category.emojiIds.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: configuration.perLine,
          ),
          itemBuilder: (context, index) {
            final emojiId = category.emojiIds[index];
            final emojiSrc = emojiData.getEmojiById(emojiId);
            return itemBuilder?.call(context, emojiId, emojiSrc, onEmojiSelected) ??
                EmojiItem(
                  size: configuration.emojiSize,
                  emoji: emojiSrc,
                  onTap: () => onEmojiSelected(emojiId, emojiSrc),
                );
          },
        ),
      ],
    );
  }
}
