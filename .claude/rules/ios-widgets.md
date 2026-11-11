---
paths:
  - "ios/**"
  - "lib/src/app.dart"
  - "scripts/gen-widget-strings.mjs"
---

# iOS Home Screen Widgets (WidgetKit Extension)

The WidgetKit extension is in `ios/LichessWidgets/`; contributor setup is in `ios/EXTENSIONS.md`.

## Files

- `LichessWidgetsBundle.swift`: `@main` entry point, registers the 4 widgets.
- `LichessAppGroup.swift`: reads the shared `UserDefaults` of the App Group
  `group.org.lichess.mobileV2.LichessWidgets` (`lichessHost`, `boardTheme`, `pieceSet`,
  `isKidMode`).
- `Deeplinks.swift`: custom URI scheme to open URLs in the in-app browser.
- Dependencies: WidgetKit, ChessgroundAssets (Swift package shared with Dart), FeedKit, XMLKit.

## Rules

- `lib/src/app.dart` writes the App Group keys with `home_widget`. When changing a widget setting
  or the board theme / piece set preferences, update both `HomeWidget.saveWidgetData` and
  `HomeWidget.updateWidget` there (`boardTheme` / `pieceSet` reload `DailyPuzzleWidget`,
  `isKidMode` reloads the blog widgets, which it hides).
- To add a translated widget string, add its key to `WIDGET_KEYS` in
  `scripts/gen-widget-strings.mjs` and run `./scripts/gen-translations.sh` (it updates
  `ios/LichessWidgets/Localizable.xcstrings`).
- The extension has its own bundle ID (`org.lichess.mobileV2.LichessWidgets`) and App Group
  entitlement; fastlane `sync_code_signing` provisions both targets (`ios/fastlane/Matchfile`).
