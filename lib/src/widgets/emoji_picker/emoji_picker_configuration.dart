typedef EmojiSelectedCallback = void Function(String emojiId, String emoji);

enum EmojiSkinTone { none, light, mediumLight, medium, mediumDark, dark }

class EmojiPickerConfiguration {
  const EmojiPickerConfiguration({
    this.perLine = 9,
    this.emojiSize = 24,
    this.showTabs = true,
    this.showRecentTab = true,
    this.showSearchBar = true,
    this.showSectionHeader = true,
    this.defaultSkinTone = EmojiSkinTone.none,
  });

  // the number of emojis to show per line
  final int perLine;

  // size of the emoji, font size
  final double emojiSize;

  // whether to show the recent tab
  final bool showRecentTab;

  // whether to show the search bar
  final bool showSearchBar;

  // whether to show the section header
  final bool showSectionHeader;

  // whether to show the tabs
  final bool showTabs;

  // the default skin tone
  final EmojiSkinTone defaultSkinTone;
}
