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
public final class LiveActivityPlugin: NSObject, FlutterPlugin {
  private let channel: FlutterMethodChannel

  private init(channel: FlutterMethodChannel) {
    self.channel = channel
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
      Task {
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
        content: ActivityContent(state: state, staleDate: nil),
        pushType: nil
      )
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
      Task {
        await activity.update(ActivityContent(state: state, staleDate: nil))
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
      Task {
        await activity.end(content, dismissalPolicy: dismissalPolicy)
        result(nil)
      }
    } catch {
      result(Self.flutterError(error))
    }
  }

  // MARK: - Helpers

  @available(iOS 16.2, *)
  private func observe(_ activity: Activity<GameActivityAttributes>) {
    Task { [weak self] in
      for await state in activity.activityStateUpdates {
        await MainActor.run {
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
