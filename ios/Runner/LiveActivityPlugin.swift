import ActivityKit
import Flutter
import UIKit
import UserNotifications

/// Starts, updates and ends the game Live Activity on behalf of Flutter, over the 
/// `mobile.lichess.org/live_activity` channel.
///
/// Calls back to Dart with `onActivityState {id, state}` when an activity's state changes, e.g.
/// `dismissed` when the user removes it from the Lock Screen.
public final class LiveActivityPlugin: NSObject, FlutterPlugin {
  /// How long before the predicted suspension the activities show the warning.
  private static let staleMargin: TimeInterval = 3
  /// How long lila-ws takes to count a silent socket (the app suspended) as gone: it drops the
  /// clients whose last ping is more than 30 s old.
  private static let silentSocketTimeout: TimeInterval = 30
  private static let leftNotificationPrefix = "org.lichess.liveActivity.left."

  private let channel: FlutterMethodChannel

  /// Last content state sent by Dart, by activity id, for the activities this run started and
  /// hasn't ended.
  private var contents: [String: Any] = [:]
  private var isInBackground = false
  /// Upper bound of the background window: how long the app keeps the game socket open in the
  /// background (`kDisconnectOnBackgroundTimeout` in Dart, sent with `start`). Where iOS grants
  /// more background time, e.g. with a debugger attached, the app leaves the game then. The default
  /// is a fallback only: every activity is started before the app goes to the background.
  private var socketBackgroundTimeout: TimeInterval = 60
  /// When the app is predicted to be suspended, during a stay in the background.
  private var predictedSuspension: Date?
  /// When the game socket was lost, during a stay in the background: lila counts the player as gone
  /// from then on, which dates the "You left the game" notification.
  private var socketLostAt: Date?
  /// The `staleDate` applied to the activities.
  private var appliedStaleDate: Date?
  /// Fires at `staleDate` to update the activities, in case the system doesn't redraw them by
  /// itself when their `staleDate` passes.
  private var staleTimer: Timer?
  /// The date of the "You left the game" notification scheduled for each activity.
  private var leftDates: [String: Date] = [:]
  /// When the pending "You left the game" notification of each activity goes off: later than its
  /// `leftDates` entry when that date was already past at scheduling time.
  private var leftFireDates: [String: Date] = [:]
  /// The activities whose "You left the game" notification went off during this stay in the
  /// background: it goes off once per stay.
  private var warnedLeft: Set<String> = []
  /// Whether the game socket is connected, as reported by Dart. While it isn't, the activities show
  /// "Reconnecting": Dart only reports it while the app runs, so the socket was lost to the network
  /// (or the server), not to the app being suspended.
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
    NotificationCenter.default.addObserver(
      self, selector: #selector(willTerminate),
      name: UIApplication.willTerminateNotification, object: nil)
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
      if let timeout = args["socketBackgroundTimeout"] as? Int {
        socketBackgroundTimeout = TimeInterval(timeout) / 1000
      }
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
      // Ignores an activity this run didn't start or already ended: an update racing `end` would
      // otherwise bring back a finished game.
      guard let previous = contents[activity.id] as? GameActivityAttributes.ContentState else {
        result(nil)
        return
      }
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
      forget(activity.id)
      enqueue {
        await activity.end(nil, dismissalPolicy: .immediate)
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
      self?.endBackgroundTask()
    }

    let remaining = backgroundTask == .invalid ? 0 : application.backgroundTimeRemaining
    #if DEBUG
      NSLog("LiveActivityPlugin: background time remaining %.1f s", remaining)
    #endif
    let window = min(remaining, socketBackgroundTimeout)
    predictedSuspension = Date().addingTimeInterval(window)
    if !isSocketConnected { socketLostAt = Date() }
    applyLeftDates()
  }

  @objc private func willEnterForeground() {
    isInBackground = false
    predictedSuspension = nil
    socketLostAt = nil
    endBackgroundTask()
    guard #available(iOS 16.2, *) else { return }
    applyLeftDates()
    // After `applyLeftDates`, which marks the activities whose notification went off as warned.
    warnedLeft.removeAll()
    UNUserNotificationCenter.current().removeDeliveredNotifications(
      withIdentifiers: contents.keys.map(Self.leftNotificationIdentifier))
  }

  /// The user killed the app while it was running (a suspended app is killed without notice): no
  /// game screen will be left to return to, so the pending warnings go.
  @objc private func willTerminate() {
    UNUserNotificationCenter.current().removePendingNotificationRequests(
      withIdentifiers: leftDates.keys.map(Self.leftNotificationIdentifier))
  }

  @available(iOS 16.2, *)
  private func setConnected(_ connected: Bool) {
    guard connected != isSocketConnected else { return }
    isSocketConnected = connected
    if isInBackground {
      // lila counts a closed socket as gone within a second, and the player as back once it
      // reconnects.
      socketLostAt = connected ? nil : Date()
    }
    // All of them, to show or hide "Reconnecting".
    updateActivities()
  }

  /// When the activities switch to the "You left the game" view, or nil while in the foreground:
  /// just before the app is suspended. A socket lost before that shows "Reconnecting" instead.
  private var staleDate: Date? {
    guard isInBackground else { return nil }
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

  /// The content of an activity, with the current `staleDate` and connection state. Schedules the
  /// "You left the game" notification when its date changes.
  @available(iOS 16.2, *)
  private func content(
    for id: String, state: GameActivityAttributes.ContentState
  ) -> ActivityContent<GameActivityAttributes.ContentState> {
    let date = leftDate(for: state)
    if date != leftDates[id] {
      if let fireDate = leftFireDates[id], fireDate <= Date() { warnedLeft.insert(id) }
      leftDates[id] = date
      #if DEBUG
        NSLog("LiveActivityPlugin: %@ notification date %@", id, date.map { "\($0)" } ?? "nil")
      #endif
      leftFireDates[id] = scheduleLeftNotification(id: id, state: state, at: date)
    }
    var state = state
    state.reconnecting = !isSocketConnected
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
  /// one, unless it already went off during this stay in the background. Returns when it goes off,
  /// or nil if none is scheduled.
  @available(iOS 16.2, *)
  private func scheduleLeftNotification(
    id: String, state: GameActivityAttributes.ContentState, at date: Date?
  ) -> Date? {
    let center = UNUserNotificationCenter.current()
    let identifier = Self.leftNotificationIdentifier(id)
    center.removePendingNotificationRequests(withIdentifiers: [identifier])
    guard let date, !warnedLeft.contains(id) else { return nil }
    let content = UNMutableNotificationContent()
    content.title = String(localized: "You left the game")
    content.body =
      state.claimable
      ? String(localized: "Return or your opponent can claim victory soon.")
      : String(localized: "Return to the game.")
    content.sound = .default
    // A time interval trigger needs a positive interval.
    let interval = max(1, date.timeIntervalSinceNow)
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
    center.add(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger))
    return Date().addingTimeInterval(interval)
  }

  /// Forgets an activity that ended or was dismissed, and removes its warning notification.
  private func forget(_ id: String) {
    contents[id] = nil
    leftDates[id] = nil
    leftFireDates[id] = nil
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

  /// Runs `operation` after every activity operation enqueued before it, on the main actor, where
  /// Flutter results must be sent.
  private func enqueue(_ operation: @escaping @MainActor () async -> Void) {
    let previous = lastActivityTask
    lastActivityTask = Task { @MainActor in
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
