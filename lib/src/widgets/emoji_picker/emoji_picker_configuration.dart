typedef EmojiSelectedCallback = void Function(String emojiId, String emoji);

enum EmojiSkinTone() {
  none,
  light,
  mediumLight,
  medium,
  mediumDark,
  dark,
}

class const EmojiPickerConfiguration({
  final int perLine = 9,
  final double emojiSize = 24,
  final bool showTabs = true,
  final bool showRecentTab = true,
  final bool showSearchBar = true,
  final bool showSectionHeader = true,
  final EmojiSkinTone defaultSkinTone = EmojiSkinTone.none,
}) {
  // size of the emoji, font size
  // whether to show the recent tab
  // whether to show the search bar
  // whether to show the section header
  // whether to show the tabs
  // the default skin tone
}
