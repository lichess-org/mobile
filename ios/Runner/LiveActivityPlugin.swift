import ActivityKit
import Flutter
import UIKit
import UserNotifications

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
///  - `setConnected {connected}`: whether the game socket is connected.
///
/// Calls back to Dart with `onActivityState {id, state}` when an activity's state changes, e.g.
/// `dismissed` when the user removes it from the Lock Screen.
///
/// "You left the game" is handled here, not in Dart. When the scene enters the background while a
/// game is ongoing, the plugin begins a background task, which keeps the app (and its socket)
/// running for `backgroundTimeRemaining`, and predicts when the app will be suspended.
///
/// The activities show the warning as soon as nothing updates them any more: just before the
/// predicted suspension, or at once when the socket is lost (`staleDate`). They are handed that
/// date as their `staleDate`, which flips `isStale` (the extension then shows the warning), and a
/// timer also updates them at that date, as the app still runs then.
///
/// The user is alerted later, by a local notification (`leftDate(for:)`): half-way through the
/// grace period lila gives before the opponent can claim victory, or along with the view when Dart
/// sends no `leftWarningDelay` (bullet, or no claim possible). Losing the socket in the background
/// moves it earlier, since lila counts a closed socket as gone at once; getting it back restores
/// it. The app is usually suspended by then, so the notification is scheduled with the system.
///
/// Back in the foreground the task ends, the `staleDate` is cleared and the notification removed.
/// Every activity update re-applies the current `staleDate`, so Dart only sends content.
///
/// While the app is in the background, an update that makes it the user's turn comes with an
/// activity alert, since the user isn't looking at the game: it plays a sound and expands the
/// Dynamic Island (a banner on devices without one).
public final class LiveActivityPlugin: NSObject, FlutterPlugin {
  /// How long before the predicted suspension the activities show the warning.
  private static let staleMargin: TimeInterval = 3
  /// Upper bound of the background window: what iOS grants a background task today. With a
  /// debugger attached `backgroundTimeRemaining` can be much larger and the app isn't suspended,
  /// which would delay the warning past the point where lila marks the player offline (once
  /// `SocketPool` closes the socket after a minute in the background).
  private static let maxBackgroundTime: TimeInterval = 30
  /// How long lila-ws takes to count a silent socket (the app suspended) as gone: it drops the
  /// clients whose last ping is more than 30 s old.
  private static let silentSocketTimeout: TimeInterval = 30
  private static let leftNotificationPrefix = "org.lichess.liveActivity.left."

  private let channel: FlutterMethodChannel

  /// Last content state sent by Dart, by activity id, for the activities this run started and
  /// hasn't ended. Lets the plugin re-apply the content with a new `staleDate`. Values are
  /// `ContentState`, typed `Any` because a stored property can't be limited to iOS 16.2.
  private var contents: [String: Any] = [:]
  private var isInBackground = false
  /// When the app is predicted to be suspended, during a stay in the background.
  private var predictedSuspension: Date?
  /// When the game socket was lost, during a stay in the background.
  private var socketLostAt: Date?
  /// The `staleDate` applied to the activities.
  private var appliedStaleDate: Date?
  /// Fires at `staleDate` to update the activities, in case the system doesn't redraw them by
  /// itself when their `staleDate` passes.
  private var staleTimer: Timer?
  /// The date of the "You left the game" notification scheduled for each activity.
  private var leftDates: [String: Date] = [:]
  /// The activities whose "You left the game" notification went off during this stay in the
  /// background: it goes off once per stay.
  private var warnedLeft: Set<String> = []
  /// Whether the game socket is connected, as reported by Dart.
  private var isSocketConnected = true
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
    case "setConnected":
      setConnected(args["connected"] as? Bool ?? true)
      result(nil)
    case "endAll":
      for id in contents.keys { forget(id) }
      Self.removeAllLeftNotifications()
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
        // Started in the foreground only, so there is no warning date yet.
        content: ActivityContent(state: state, staleDate: nil),
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
      let previous = contents[activity.id] as? GameActivityAttributes.ContentState
      contents[activity.id] = state
      let content = self.content(for: activity.id, state: state)
      let alert = isInBackground
        ? Self.turnAlert(myColor: activity.attributes.myColor, previous: previous, state: state)
        : nil
      enqueue {
        await activity.update(content, alertConfiguration: alert)
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
      forget(activity.id)
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
    isInBackground = true
    guard #available(iOS 16.2, *), hasOngoingGame else { return }
    endBackgroundTask()

    let application = UIApplication.shared
    backgroundTask = application.beginBackgroundTask(withName: "LiveActivityGame") { [weak self] in
      // The system cut the time short: the app is about to be suspended. Best effort, as the
      // updates may not finish in time.
      guard let self else { return }
      if #available(iOS 16.2, *), let suspension = self.predictedSuspension, suspension > Date() {
        self.predictedSuspension = Date()
        self.applyLeftDates()
      }
      self.endBackgroundTask()
    }

    let remaining = backgroundTask == .invalid ? 0 : application.backgroundTimeRemaining
    #if DEBUG
      NSLog("LiveActivityPlugin: background time remaining %.1f s", remaining)
    #endif
    let window = remaining.isFinite ? min(remaining, Self.maxBackgroundTime) : 0
    predictedSuspension = Date().addingTimeInterval(window)
    if !isSocketConnected { socketLostAt = Date() }
    applyLeftDates()
  }

  @objc private func willEnterForeground() {
    isInBackground = false
    predictedSuspension = nil
    socketLostAt = nil
    warnedLeft.removeAll()
    endBackgroundTask()
    guard #available(iOS 16.2, *) else { return }
    applyLeftDates()
    UNUserNotificationCenter.current().removeDeliveredNotifications(
      withIdentifiers: contents.keys.map(Self.leftNotificationIdentifier))
  }

  @available(iOS 16.2, *)
  private func setConnected(_ connected: Bool) {
    guard connected != isSocketConnected else { return }
    isSocketConnected = connected
    guard isInBackground else { return }
    // lila counts a closed socket as gone within a second, and the player as back once it
    // reconnects.
    socketLostAt = connected ? nil : Date()
    applyLeftDates()
  }

  /// When the activities switch to the "You left the game" view, or nil while in the foreground:
  /// as soon as nothing updates them any more, i.e. just before the app is suspended, or at once
  /// when the socket is lost.
  private var staleDate: Date? {
    guard isInBackground else { return nil }
    if let lost = socketLostAt { return lost }
    return predictedSuspension?.addingTimeInterval(-Self.staleMargin)
  }

  /// When to notify that the user left the game shown by `state`, or nil while in the foreground.
  ///
  /// The notification comes `leftWarningDelay` after lila counts the player as gone: at once when
  /// the socket was lost, 30 s after the suspension otherwise (the socket is then silent). Without
  /// a delay, it comes along with the "You left the game" view.
  @available(iOS 16.2, *)
  private func leftDate(for state: GameActivityAttributes.ContentState) -> Date? {
    guard let delay = state.leftWarningDelay.map({ TimeInterval($0) / 1000 }) else {
      return staleDate
    }
    if let lost = socketLostAt { return lost.addingTimeInterval(delay) }
    return predictedSuspension?.addingTimeInterval(Self.silentSocketTimeout + delay)
  }

  /// The content of an activity, with the current `staleDate`. Schedules the "You left the game"
  /// notification when its date changes.
  @available(iOS 16.2, *)
  private func content(
    for id: String, state: GameActivityAttributes.ContentState
  ) -> ActivityContent<GameActivityAttributes.ContentState> {
    let date = leftDate(for: state)
    if date != leftDates[id] {
      if let previous = leftDates[id], previous <= Date() { warnedLeft.insert(id) }
      leftDates[id] = date
      #if DEBUG
        NSLog("LiveActivityPlugin: %@ notification date %@", id, date.map { "\($0)" } ?? "nil")
      #endif
      scheduleLeftNotification(id: id, state: state, at: date)
    }
    return ActivityContent(state: state, staleDate: staleDate)
  }

  /// Re-applies the `staleDate` and notification date of every activity whose dates changed,
  /// keeping its last content, and schedules the update at the `staleDate`.
  @available(iOS 16.2, *)
  private func applyLeftDates() {
    let staleDate = self.staleDate
    let staleDateChanged = staleDate != appliedStaleDate
    appliedStaleDate = staleDate
    if staleDateChanged { scheduleStaleTimer(at: staleDate) }
    updateActivities { id, state in
      staleDateChanged || self.leftDate(for: state) != self.leftDates[id]
    }
  }

  /// Updates the activities `isIncluded` selects with their last content.
  @available(iOS 16.2, *)
  private func updateActivities(
    where isIncluded: (String, GameActivityAttributes.ContentState) -> Bool = { _, _ in true }
  ) {
    let updates = contents.compactMap {
      id, value -> (String, ActivityContent<GameActivityAttributes.ContentState>)? in
      guard let state = value as? GameActivityAttributes.ContentState, isIncluded(id, state)
      else { return nil }
      return (id, content(for: id, state: state))
    }
    guard !updates.isEmpty else { return }
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

  /// Updates the activities at `date`, when it is ahead. The system may not redraw them by itself
  /// when their `staleDate` passes, while an update with a past `staleDate` shows the "You left the
  /// game" view.
  @available(iOS 16.2, *)
  private func scheduleStaleTimer(at date: Date?) {
    staleTimer?.invalidate()
    staleTimer = nil
    guard let date, date > Date() else { return }
    staleTimer = Timer.scheduledTimer(withTimeInterval: date.timeIntervalSinceNow, repeats: false) {
      [weak self] _ in
      self?.staleTimer = nil
      self?.updateActivities()
    }
  }

  /// Schedules the "You left the game" notification of an activity at `date`, replacing a pending
  /// one, unless it already went off during this stay in the background.
  @available(iOS 16.2, *)
  private func scheduleLeftNotification(
    id: String, state: GameActivityAttributes.ContentState, at date: Date?
  ) {
    let center = UNUserNotificationCenter.current()
    let identifier = Self.leftNotificationIdentifier(id)
    center.removePendingNotificationRequests(withIdentifiers: [identifier])
    guard let date, !warnedLeft.contains(id) else { return }
    let content = UNMutableNotificationContent()
    content.title = "You left the game"
    content.body =
      state.claimable ? "Return or your opponent can claim victory soon." : "Return to the game."
    content.sound = .default
    let trigger = UNTimeIntervalNotificationTrigger(
      timeInterval: max(1, date.timeIntervalSinceNow), repeats: false)
    center.add(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger))
  }

  /// Forgets an activity that ended or was dismissed, and removes its warning notification.
  private func forget(_ id: String) {
    contents[id] = nil
    leftDates[id] = nil
    warnedLeft.remove(id)
    let identifier = Self.leftNotificationIdentifier(id)
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: [identifier])
    center.removeDeliveredNotifications(withIdentifiers: [identifier])
    endBackgroundTaskIfIdle()
  }

  /// Whether one of the activities started by this run is still running: an activity is ended as
  /// soon as its game is over.
  @available(iOS 16.2, *)
  private var hasOngoingGame: Bool { !contents.isEmpty }

  /// Ends the background task once no game is ongoing any more: nothing left to keep running for.
  private func endBackgroundTaskIfIdle() {
    if #available(iOS 16.2, *), hasOngoingGame { return }
    endBackgroundTask()
  }

  private func endBackgroundTask() {
    guard backgroundTask != .invalid else { return }
    UIApplication.shared.endBackgroundTask(backgroundTask)
    backgroundTask = .invalid
  }

  // MARK: - Helpers

  private static func leftNotificationIdentifier(_ id: String) -> String {
    leftNotificationPrefix + id
  }

  /// Removes the warning notifications of every activity, including leftovers from a previous run.
  private static func removeAllLeftNotifications() {
    let center = UNUserNotificationCenter.current()
    let isLeft = { (identifier: String) in identifier.hasPrefix(Self.leftNotificationPrefix) }
    center.getPendingNotificationRequests { requests in
      center.removePendingNotificationRequests(
        withIdentifiers: requests.map(\.identifier).filter(isLeft))
    }
    center.getDeliveredNotifications { notifications in
      center.removeDeliveredNotifications(
        withIdentifiers: notifications.map(\.request.identifier).filter(isLeft))
    }
  }

  /// An alert for when the opponent's move makes it the user's turn.
  @available(iOS 16.2, *)
  private static func turnAlert(
    myColor: GameActivityAttributes.Side,
    previous: GameActivityAttributes.ContentState?,
    state: GameActivityAttributes.ContentState
  ) -> AlertConfiguration? {
    guard let previous, previous.turn != myColor, state.turn == myColor else { return nil }
    let body: LocalizedStringResource =
      state.lastSan.map { "Your opponent played \($0)" } ?? "Your opponent moved"
    return AlertConfiguration(title: "Your turn", body: body, sound: .default)
  }

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
          #if DEBUG
            NSLog("LiveActivityPlugin: %@ state %@", activity.id, Self.name(of: state))
          #endif
          if state == .dismissed || state == .ended {
            self?.forget(activity.id)
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
