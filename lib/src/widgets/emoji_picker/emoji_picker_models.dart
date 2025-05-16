import 'package:freezed_annotation/freezed_annotation.dart';

part 'emoji_picker_models.freezed.dart';
part 'emoji_picker_models.g.dart';

@Freezed(toJson: true, fromJson: true)
sealed class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    @JsonKey(name: 'emojis') required List<String> emojiIds,
  }) = _Category;

  factory Category.fromJson(Map<String, Object?> json) => _$CategoryFromJson(json);
}

@Freezed(toJson: true, fromJson: true)
sealed class Skin with _$Skin {
  const factory Skin({required String src}) = _Skin;

  factory Skin.fromJson(Map<String, dynamic> json) => _$SkinFromJson(json);
}

@Freezed(toJson: true, fromJson: true)
sealed class Emoji with _$Emoji {
  const factory Emoji({
    required String id,
    required String name,
    required Set<String> keywords,
    required List<Skin> skins,
  }) = _Emoji;

  factory Emoji.fromJson(Map<String, dynamic> json) => _$EmojiFromJson(json);
}

@Freezed(toJson: true, fromJson: true)
sealed class EmojiData with _$EmojiData {
  const EmojiData._(); // Added constructor

  const factory EmojiData({
    required List<Category> categories,
    required Map<String, Emoji> emojis,
  }) = _EmojiData;

  factory EmojiData.fromJson(Map<String, dynamic> json) => _$EmojiDataFromJson(json);

  String getEmojiById(String id) {
    final emoji = emojis[id];
    if (emoji == null) {
      throw ArgumentError.value(id, 'id', 'Emoji not found');
    }
    return emoji.skins.first.src;
  }

  EmojiData filterByKeyword(String keyword, {bool keepEmptyCategories = false}) {
    final filteredCategories = <Category>[];
    final filteredEmojis = <String, Emoji>{};

    for (final category in categories) {
      final filteredEmojiIds = <String>[];
      for (final emojiId in category.emojiIds) {
        final emoji = emojis[emojiId]!;
        final lowercaseKey = keyword.toLowerCase();
        if (emoji.keywords.any((k) => k.toLowerCase().contains(lowercaseKey)) ||
            emoji.id.toLowerCase().contains(lowercaseKey) ||
            emoji.name.toLowerCase().contains(lowercaseKey)) {
          filteredEmojiIds.add(emojiId);
          filteredEmojis[emojiId] = emoji;
        }
      }

      if (filteredEmojiIds.isNotEmpty || keepEmptyCategories) {
        filteredCategories.add(category.copyWith(emojiIds: filteredEmojiIds));
      }
    }

    final filteredEmojiData = copyWith(categories: filteredCategories, emojis: filteredEmojis);

    return filteredEmojiData;
  }
}
