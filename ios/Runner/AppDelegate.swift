import UIKit
import Flutter
import UserNotifications
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Apple requires the UNUserNotificationCenter delegate to be assigned before
    // `application:didFinishLaunchingWithOptions:` returns, otherwise a notification tapped from a
    // terminated state can be dropped. This app uses the UIScene lifecycle, so plugins are only
    // registered later in `didInitializeImplicitFlutterEngine`, which is too late.
    // FlutterAppDelegate forwards the notification center callbacks to every plugin registered
    // with `addApplicationDelegate:`, which is how both firebase_messaging and
    // flutter_local_notifications expect to receive them.
    UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    if let shareRegistrar = engineBridge.pluginRegistry.registrar(forPlugin: "SharePlugin") {
      SharePlugin.register(with: shareRegistrar)
    }

    let BADGE_CHANNEL = FlutterMethodChannel(name: "mobile.lichess.org/badge",
                                                    binaryMessenger: engineBridge.applicationRegistrar.messenger())

    let SYSTEM_CHANNEL = FlutterMethodChannel(name: "mobile.lichess.org/system",
                                                    binaryMessenger: engineBridge.applicationRegistrar.messenger())

    BADGE_CHANNEL.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard call.method == "setBadge" else {
        result(FlutterMethodNotImplemented)
        return
      }

        if let args = call.arguments as? Dictionary<String, Any>,
            let badge = args["badge"] as? Int {
            UIApplication.shared.applicationIconBadgeNumber = badge
            result(nil)
        } else {
            result(FlutterError(code: "bad_args", message: "bad arguments", details: nil))
        }
    })

    SYSTEM_CHANNEL.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard call.method == "getTotalRam" else {
        result(FlutterMethodNotImplemented)
        return
      }

      result(self.getPhysicalMemory())
    })

    // Cf: https://github.com/MaikuB/flutter_local_notifications/tree/master/flutter_local_notifications#notification-actions
    // This is required to make any communication available in the action isolate.
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }
  }

  private func getPhysicalMemory() -> Int {
    let memory : Int = Int(ProcessInfo.processInfo.physicalMemory)
    let constant : Int = 1_048_576
    let res = memory / constant
    return Int(res)
  }
}
