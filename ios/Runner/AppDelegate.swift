import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let badgeChannel = FlutterMethodChannel(name: "mobile.lichess.org/badge",
                                                    binaryMessenger: controller.binaryMessenger)

    badgeChannel.setMethodCallHandler({
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

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
