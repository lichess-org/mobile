typedef EmojiSelectedCallback = void Function(
  String emojiId,
  String emoji,
);

enum EmojiSkinTone {
  none,
  light,
  mediumLight,
  medium,
  mediumDark,
  dark;
}

class EmojiPickerConfiguration {
  const EmojiPickerConfiguration({
    this.perLine = 9,
    this.emojiSize = 24,
    this.showTabs = true,
    this.showRecentTab = true,
    this.showSearchBar = true,
    this.showSectionHeader = true,
    this.defaultSkinTone = EmojiSkinTone.none,
    this.i18n = const EmojiPickerI18n(),
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

  // internationalization for the EmojiPicker
  final EmojiPickerI18n i18n;
}

/// The interface for the EmojiPicker's i18n.
///
/// To create a custom i18n, extend this class and override the getters.
class EmojiPickerI18n {
  const EmojiPickerI18n();

  String get activity => 'Activity';
  String get flags => 'Flags';
  String get foods => 'Food & Drink';
  String get frequent => 'Frequently used';
  String get nature => 'Animals & Nature';
  String get objects => 'Objects';
  String get people => 'Smileys & People';
  String get places => 'Travel & Places';
  String get search => 'Search Results';
  String get symbols => 'Symbols';

  String get searchHintText => 'Search';
  String get searchNoResult => 'Oops, no emoji found';
  String get searchClearTooltip => 'Clear';

  String get skinButtonTooltip => 'Select skin tone';
  String get skin1 => 'Default';
  String get skin2 => 'Light';
  String get skin3 => 'Medium-Light';
  String get skin4 => 'Medium';
  String get skin5 => 'Medium-Dark';
  String get skin6 => 'Dark';
}
