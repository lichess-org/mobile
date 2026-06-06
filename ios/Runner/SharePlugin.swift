import Flutter
import UIKit

/// Receives PGN content shared into the app and forwards it to Flutter over the
/// `mobile.lichess.org/share` channels.
///
/// Two delivery paths feed the same channels:
///  - A `.pgn` file opened from the Files app or another app arrives as a
///    security-scoped `file://` URL.
///  - The Share Extension writes the PGN into the shared App Group container and
///    opens `org.lichess.mobile://shared-pgn`, which we read back from the
///    container here.
///
/// The app uses a scene-based lifecycle (`FlutterSceneDelegate`), so URL opens
/// are delivered through the `UISceneDelegate` callbacks, not `application(_:open:)`.
/// This plugin registers as both an application and a scene delegate (mirroring
/// how `app_links` hooks in) so it works for cold and warm starts.
///
/// Cold-start PGNs are stashed and served via the `getInitialPgn` method call;
/// PGNs received while the app is running are pushed through the event channel.
public final class SharePlugin: NSObject, FlutterPlugin, FlutterStreamHandler,
  FlutterSceneLifeCycleDelegate
{
  private static let appGroupId = "group.org.lichess.mobileV2.share"
  private static let lichessScheme = "org.lichess.mobile"
  private static let sharedPgnHost = "shared-pgn"
  private static let sharedFileName = "shared.pgn"

  private var eventSink: FlutterEventSink?
  private var initialPgn: String?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(
      name: "mobile.lichess.org/share", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(
      name: "mobile.lichess.org/share/events", binaryMessenger: registrar.messenger())

    let instance = SharePlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    eventChannel.setStreamHandler(instance)
    registrar.addApplicationDelegate(instance)
    registrar.addSceneDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "getInitialPgn" {
      result(initialPgn)
      initialPgn = nil
    } else {
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - URL handling

  /// Extracts PGN text from a shared/opened URL and forwards it. Returns whether
  /// the URL was one we handle.
  private func handle(url: URL) -> Bool {
    let pgn: String?
    if url.scheme == Self.lichessScheme && url.host == Self.sharedPgnHost {
      pgn = readSharedPgnFromAppGroup()
    } else if url.isFileURL {
      pgn = readPgn(fromFileURL: url)
    } else {
      return false
    }
    guard let pgn else { return false }
    if let sink = eventSink {
      sink(pgn)
    } else {
      initialPgn = pgn
    }
    return true
  }

  private func readPgn(fromFileURL url: URL) -> String? {
    let scoped = url.startAccessingSecurityScopedResource()
    defer { if scoped { url.stopAccessingSecurityScopedResource() } }
    guard let data = try? Data(contentsOf: url) else { return nil }
    return decodePgn(data)
  }

  private func readSharedPgnFromAppGroup() -> String? {
    guard
      let container = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: Self.appGroupId)
    else { return nil }
    let fileURL = container.appendingPathComponent(Self.sharedFileName)
    let data = try? Data(contentsOf: fileURL)
    try? FileManager.default.removeItem(at: fileURL)
    return data.map(decodePgn)
  }

  /// Decodes PGN bytes tolerantly. PGN files are usually UTF-8 but legacy files
  /// may use ISO-8859-1 (e.g. for player names), so we fall back to Latin-1 —
  /// which maps every byte to a code point and never fails — rather than silently
  /// dropping a file that isn't valid UTF-8.
  private func decodePgn(_ data: Data) -> String {
    if let utf8 = String(data: data, encoding: .utf8) { return utf8 }
    return String(data: data, encoding: .isoLatin1) ?? String(decoding: data, as: UTF8.self)
  }

  // MARK: - Application delegate (non-scene fallback)

  public func application(
    _ application: UIApplication, open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    return handle(url: url)
  }

  // MARK: - Scene delegate

  public func scene(
    _ scene: UIScene, willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions?
  ) -> Bool {
    guard let options = connectionOptions else { return false }
    return self.scene(scene, openURLContexts: options.urlContexts)
  }

  public func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) -> Bool {
    var handled = false
    for context in URLContexts {
      handled = handle(url: context.url) || handled
    }
    return handled
  }

  // MARK: - FlutterStreamHandler

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
    -> FlutterError?
  {
    eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}
