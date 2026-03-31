# iOS Extensions

## Building extensions as a contributor

Each iOS app extension (e.g. the Lichess widgets) is a separate Xcode target with its own bundle ID. For the extension to be installed on a device, that bundle ID must be registered in the Lichess Apple Developer account with a matching provisioning profile.

As an external contributor you won't have access to that account, so `flutter run` will silently drop the extension from the bundle — you can add the app to your home screen but the widget won't appear in the widget catalog.

### Testing locally

You can still build and test extensions using your own Apple Developer account and iOS Simulator. A free account is enough for device testing.

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select the **Runner** target → **Signing & Capabilities** → set **Team** to your account and change the bundle ID to something you own (e.g. `com.yourname.lichess`).
3. Do the same for the extension target (e.g. **LichessWidgetsExtension**), using a matching sub-ID (e.g. `com.yourname.lichess.widget`).
4. Build and run from Xcode — the extension will be signed with your profile and work on your device.

These changes are local only and should not be committed.

### Merging new extensions

When a PR that adds a new extension is ready to merge, a Lichess org member with Apple Developer access needs to:

1. Register the new App ID (for the extension's bundle ID) in the Apple Developer portal.
2. Create a provisioning profile for it.

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
