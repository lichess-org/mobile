# iOS Extensions

## Building extensions as a contributor

Each iOS app extension (e.g. the Lichess widgets) is a separate Xcode target with its own bundle ID. For the extension to be installed on a device, that bundle ID must be registered in the Lichess Apple Developer account with a matching provisioning profile.

As an external contributor you won't have access to that account, so `flutter run` will silently drop the extension from the bundle — you can add the app to your home screen but the widget won't appear in the widget catalog.

### Testing locally

You can still build and test extensions using your own Apple Developer account and iOS Simulator. A free account is enough for device testing.

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select the **Runner** target → **Signing & Capabilities** → set **Team** to your account and change the bundle ID to something you own (e.g. `com.yourname.lichess`).
3. Do the same for the extension target (e.g. **LichessWidgetsExtension**), using a matching sub-ID (e.g. `com.yourname.lichess.widget`).
4. For both targets, go to **Signing & Capabilities** → **+ Capability** → **App Groups**, and add an app group matching your bundle ID (e.g. `group.com.yourname.lichess`). The group ID must match across both targets and must also match what the Flutter app passes to `HomeWidget.setAppGroupId(...)` in `lib/src/app.dart`.
5. Build and run from Xcode — the extension will be signed with your profile and work on your device.

These changes are local only and should not be committed.

### Merging new extensions

When a PR that adds a new extension is ready to merge, a Lichess org member with Apple Developer access needs to:

1. Register the new App ID (for the extension's bundle ID) in the Apple Developer portal.
2. Create a provisioning profile for it.

### Registering a new App Group

When a PR introduces a new App Group (shared `UserDefaults` between the main app and an extension), a Lichess org member needs to do this once:

1. In the [Apple Developer portal](https://developer.apple.com/account/resources/identifiers/list/applicationGroup), go to **Identifiers** → **App Groups** → **+** and register the new group ID (e.g. `group.org.lichess.mobileV2`).
2. Edit the **main app** identifier (`org.lichess.mobileV2`) → **App Groups** → enable the new group.
3. Edit the **extension** identifier (e.g. `org.lichess.mobileV2.LichessWidgets`) → **App Groups** → enable the same group.
4. Regenerate and re-download any affected provisioning profiles, or let `match` handle it (see below).

## Deploying extensions via fastlane

Extensions have their own bundle ID (`org.lichess.mobileV2.<ExtensionName>`) and require a separate provisioning profile managed by `match`. The `Matchfile` and `Fastfile` list all extension bundle IDs alongside the main app.

### Adding a new extension to the fastlane setup

After registering the App ID in the developer portal (see above), run `match` once to create and store the provisioning profile:

```sh
cd ios
bundle exec fastlane match appstore --app_identifier org.lichess.mobileV2.<ExtensionName>
```

This will generate the profile, push it to the certificates repo, and set the correct `PROVISIONING_PROFILE_SPECIFIER` in the Xcode project. After that, `fastlane beta` handles signing for all targets automatically — including in CI.

Also add the new bundle ID to both `app_identifier` arrays in `fastlane/Matchfile` and the `sync_code_signing` call in `fastlane/Fastfile`.

## Internationalisation

Widget UI strings are translated using a String Catalog at `ios/LichessWidgets/Localizable.xcstrings`. This file is generated from the app's ARB translation files and must not be edited by hand.

### How it works

`scripts/gen-widget-strings.mjs` reads every `lib/l10n/app_*.arb` file and extracts the keys listed in its `WIDGET_KEYS` map, then writes them into `Localizable.xcstrings` with all available translations. The String Catalog is picked up automatically by Xcode via the `fileSystemSynchronizedRootGroup` — no project file changes needed.

SwiftUI `Text("Daily Puzzle")` resolves the string at runtime against the catalog using the device locale, so no code changes are needed on the Swift side for existing strings.

### Adding a new translatable string

1. Make sure the string exists in the ARB files (either from Crowdin or from `translation/source/mobile.xml` — see [docs/internationalisation.md](../docs/internationalisation.md)).
2. Add an entry to `WIDGET_KEYS` in `scripts/gen-widget-strings.mjs`:
   ```js
   'English UI string': { arbKey: 'theArbKey', fallback: 'English UI string' },
   ```
3. Run `./scripts/gen-translations.sh` to regenerate the catalog.
4. Use the exact same English string as a `LocalizedStringKey` in SwiftUI (`Text("English UI string")`).

## Chessboard assets

Board textures, piece images, and theme colour data used by the widgets are
provided by the `ChessgroundAssets` Swift package, which lives inside the
[flutter-chessground](https://github.com/lichess-org/flutter-chessground)
repository. This means the widget always uses the same assets as the Flutter
app — one source of truth distributed via both pub and SPM.

### Adding the package (one-time Xcode setup)

1. In Xcode, select **File → Add Package Dependencies**.
2. Enter `https://github.com/lichess-org/flutter-chessground` as the URL.
3. Choose the version rule and add the `ChessgroundAssets` library to the
   **LichessWidgets** extension target only (not the Runner target).

### Keeping assets in sync

Assets are versioned alongside the Dart package. When `chessground` is bumped in
`pubspec.yaml`, update the SPM dependency to the matching version tag in Xcode
(**File → Packages → Update to Latest Package Versions**) or pin it to the
specific tag. No script needs to be run in this repository.

If you need to regenerate the xcassets on the flutter-chessground side (e.g.
after a new piece set is added), run `./scripts/gen-swift-xcassets.sh` there and
commit the result before cutting a new release tag.
