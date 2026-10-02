import ActivityKit
import Flutter
import UIKit

/// Starts, updates and ends the game Live Activity (`GameActivityAttributes`, rendered by the
/// LichessWidgets extension) on behalf of Flutter, over the `mobile.lichess.org/live_activity`
/// channel.
///
/// Dart sends the attributes and content state as JSON-compatible maps, decoded here with
/// `JSONDecoder` into the shared Codable types.
///
/// Methods:
///  - `isSupported` → `Bool`: iOS 16.2+ and Live Activities allowed by the user.
///  - `start {attributes, state}` → activity id.
///  - `update {id, state}`.
///  - `end {id, state?, dismissAfterSeconds?}`: without a dismissal delay the system default applies.
///  - `endAll`: ends every game activity, e.g. leftovers from a previous run.
///
/// Calls back to Dart with `onActivityState {id, state}` when an activity's state changes, e.g.
/// `dismissed` when the user removes it from the Lock Screen.
///
/// "You left the game" is handled here, not in Dart. When the scene enters the background while a
/// game is ongoing, the plugin begins a background task, which keeps the app (and its socket)
/// running for `backgroundTimeRemaining`, and sets the activities' `staleDate` to just before the
/// app is suspended. The system flips `isStale` at that time with no app code running, and the
/// extension shows the warning. Back in the foreground the task ends and the `staleDate` is
/// cleared. Every activity update re-applies the current `staleDate`, so Dart only sends content.
public final class LiveActivityPlugin: NSObject, FlutterPlugin {
  /// How long before the predicted suspension the activity turns stale.
  private static let staleMargin: TimeInterval = 3
  /// Upper bound of the background window: what iOS grants a background task today. With a
  /// debugger attached `backgroundTimeRemaining` can be much larger and the app isn't suspended,
  /// which would delay the warning past the point where lila marks the player offline (once
  /// `SocketPool` closes the socket after a minute in the background).
  private static let maxBackgroundTime: TimeInterval = 30

  private let channel: FlutterMethodChannel

  /// Last content state sent by Dart, by activity id, for the activities this run started and
  /// hasn't ended. Lets the plugin re-apply the content with a new `staleDate`. Values are
  /// `ContentState`, typed `Any` because a stored property can't be limited to iOS 16.2.
  private var contents: [String: Any] = [:]
  private var staleDate: Date?
  private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
  /// Tail of the chain of activity updates. ActivityKit calls are async, so they are chained to
  /// apply in the order they were made (Dart updates interleave with lifecycle ones).
  private var lastActivityTask: Task<Void, Never>?

  private init(channel: FlutterMethodChannel) {
    self.channel = channel
    super.init()
    NotificationCenter.default.addObserver(
      self, selector: #selector(didEnterBackground),
      name: UIScene.didEnterBackgroundNotification, object: nil)
    NotificationCenter.default.addObserver(
      self, selector: #selector(willEnterForeground),
      name: UIScene.willEnterForegroundNotification, object: nil)
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "mobile.lichess.org/live_activity", binaryMessenger: registrar.messenger())
    let instance = LiveActivityPlugin(channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard #available(iOS 16.2, *) else {
      if call.method == "isSupported" {
        result(false)
      } else {
        result(FlutterError(code: "unsupported", message: "Requires iOS 16.2", details: nil))
      }
      return
    }

    let args = call.arguments as? [String: Any] ?? [:]
    switch call.method {
    case "isSupported":
      result(ActivityAuthorizationInfo().areActivitiesEnabled)
    case "start":
      start(args: args, result: result)
    case "update":
      update(args: args, result: result)
    case "end":
      end(args: args, result: result)
    case "endAll":
      contents.removeAll()
      endBackgroundTaskIfIdle()
      enqueue {
        for activity in Activity<GameActivityAttributes>.activities {
          await activity.end(nil, dismissalPolicy: .immediate)
        }
        result(nil)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - Methods

  @available(iOS 16.2, *)
  private func start(args: [String: Any], result: @escaping FlutterResult) {
    do {
      let attributes: GameActivityAttributes = try decode(args["attributes"])
      let state: GameActivityAttributes.ContentState = try decode(args["state"])
      let activity = try Activity.request(
        attributes: attributes,
        content: ActivityContent(state: state, staleDate: staleDate),
        pushType: nil
      )
      contents[activity.id] = state
      observe(activity)
      result(activity.id)
    } catch {
      result(Self.flutterError(error))
    }
  }

  @available(iOS 16.2, *)
  private func update(args: [String: Any], result: @escaping FlutterResult) {
    do {
      let activity = try find(args["id"])
      let state: GameActivityAttributes.ContentState = try decode(args["state"])
      contents[activity.id] = state
      let content = ActivityContent(state: state, staleDate: staleDate)
      enqueue {
        await activity.update(content)
        result(nil)
      }
    } catch {
      result(Self.flutterError(error))
    }
  }

  @available(iOS 16.2, *)
  private func end(args: [String: Any], result: @escaping FlutterResult) {
    do {
      let activity = try find(args["id"])
      var content: ActivityContent<GameActivityAttributes.ContentState>?
      if let state = args["state"], !(state is NSNull) {
        content = ActivityContent(state: try decode(state), staleDate: nil)
      }
      let dismissalPolicy: ActivityUIDismissalPolicy =
        (args["dismissAfterSeconds"] as? Double).map { .after(Date().addingTimeInterval($0)) }
        ?? .default
      contents[activity.id] = nil
      endBackgroundTaskIfIdle()
      enqueue {
        await activity.end(content, dismissalPolicy: dismissalPolicy)
        result(nil)
      }
    } catch {
      result(Self.flutterError(error))
    }
  }

  // MARK: - Background

  @objc private func didEnterBackground() {
    guard #available(iOS 16.2, *), hasOngoingGame else { return }
    endBackgroundTask()

    let application = UIApplication.shared
    backgroundTask = application.beginBackgroundTask(withName: "LiveActivityGame") { [weak self] in
      // The system cut the time short, or the margin was too small: make sure the activity is
      // stale before the app is suspended. Best effort, as the update may not finish in time.
      guard let self else { return }
      if #available(iOS 16.2, *) {
        self.setStaleDate(Date())
      }
      self.endBackgroundTask()
    }

    if backgroundTask == .invalid {
      setStaleDate(Date())
    } else {
      let remaining = application.backgroundTimeRemaining
      #if DEBUG
        NSLog("LiveActivityPlugin: background time remaining %.1f s", remaining)
      #endif
      let window = remaining.isFinite ? min(remaining, Self.maxBackgroundTime) : 0
      setStaleDate(Date().addingTimeInterval(max(0, window - Self.staleMargin)))
    }
  }

  @objc private func willEnterForeground() {
    endBackgroundTask()
    guard #available(iOS 16.2, *), staleDate != nil else { return }
    setStaleDate(nil)
  }

  /// Whether one of the activities started by this run shows a game in progress.
  @available(iOS 16.2, *)
  private var hasOngoingGame: Bool {
    contents.values.contains { ($0 as? GameActivityAttributes.ContentState)?.status == .started }
  }

  /// Sets the `staleDate` of every activity started by this run, keeping its last content.
  @available(iOS 16.2, *)
  private func setStaleDate(_ date: Date?) {
    staleDate = date
    let updates = contents.compactMap { id, state -> (String, ActivityContent<GameActivityAttributes.ContentState>)? in
      guard let state = state as? GameActivityAttributes.ContentState else { return nil }
      return (id, ActivityContent(state: state, staleDate: date))
    }
    enqueue {
      for (id, content) in updates {
        guard
          let activity = Activity<GameActivityAttributes>.activities.first(where: { $0.id == id }),
          activity.activityState == .active || activity.activityState == .stale
        else { continue }
        await activity.update(content)
      }
    }
  }

  /// Ends the background task once no game is ongoing any more: nothing left to keep running for.
  private func endBackgroundTaskIfIdle() {
    guard backgroundTask != .invalid else { return }
    if #available(iOS 16.2, *), hasOngoingGame { return }
    endBackgroundTask()
  }

  private func endBackgroundTask() {
    guard backgroundTask != .invalid else { return }
    UIApplication.shared.endBackgroundTask(backgroundTask)
    backgroundTask = .invalid
  }

  // MARK: - Helpers

  /// Runs `operation` after every activity operation enqueued before it.
  private func enqueue(_ operation: @escaping () async -> Void) {
    let previous = lastActivityTask
    lastActivityTask = Task {
      await previous?.value
      await operation()
    }
  }

  @available(iOS 16.2, *)
  private func observe(_ activity: Activity<GameActivityAttributes>) {
    Task { [weak self] in
      for await state in activity.activityStateUpdates {
        await MainActor.run {
          if state == .dismissed || state == .ended {
            self?.contents[activity.id] = nil
            self?.endBackgroundTaskIfIdle()
          }
          self?.channel.invokeMethod(
            "onActivityState", arguments: ["id": activity.id, "state": Self.name(of: state)])
        }
      }
    }
  }

  @available(iOS 16.2, *)
  private func find(_ id: Any?) throws -> Activity<GameActivityAttributes> {
    guard let id = id as? String,
      let activity = Activity<GameActivityAttributes>.activities.first(where: { $0.id == id })
    else {
      throw PluginError.activityNotFound
    }
    return activity
  }

  private func decode<T: Decodable>(_ value: Any?) throws -> T {
    guard let value, JSONSerialization.isValidJSONObject(value) else {
      throw PluginError.badArguments
    }
    let data = try JSONSerialization.data(withJSONObject: value)
    return try JSONDecoder().decode(T.self, from: data)
  }

  @available(iOS 16.2, *)
  private static func name(of state: ActivityState) -> String {
    switch state {
    case .active: return "active"
    case .ended: return "ended"
    case .dismissed: return "dismissed"
    case .stale: return "stale"
    @unknown default: return "unknown"
    }
  }

  private static func flutterError(_ error: Error) -> FlutterError {
    FlutterError(
      code: String(describing: type(of: error)), message: String(describing: error), details: nil)
  }

  private enum PluginError: Error {
    case badArguments
    case activityNotFound
  }
}
