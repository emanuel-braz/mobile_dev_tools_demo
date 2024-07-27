import Flutter
import UIKit
import UserNotifications

enum DataCastingError: Error {
    case invalidCast
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   GeneratedPluginRegistrant.register(with: self)
    
    // Notification
    UNUserNotificationCenter.current().delegate = self
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: {_, _ in })
    application.registerForRemoteNotifications()

    // Flutter MethodCallHandler (Flutter asks for a local notification to be scheduled in native)
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.emanuelbraz.vscode/notification_channel", binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler { [weak self] (call, result) in
      if call.method == "scheduleLocalNotification" {
          self?.scheduleLocalNotification(data: call.arguments)
        result(nil)
      }
    }
    
    // Open Url
    let launchUrlChannel = FlutterMethodChannel(name: "com.emanuelbraz.vscode/launch_url", binaryMessenger: controller.binaryMessenger)
    launchUrlChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "openBrowser" {
        if let urlStr = call.arguments as? String, let url = URL(string: urlStr) {
          if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            result("Success")
          } else {
            result(FlutterError(code: "UNAVAILABLE", message: "Cannot open URL", details: nil))
          }
        } else {
          result(FlutterError(code: "INVALID_URL", message: "Invalid URL", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle notification tap
  @available(iOS 10.0, *)
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {

    let userInfo = response.notification.request.content.userInfo

    // Sending it to Flutter
    let flutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.emanuelbraz.vscode/notification_channel", binaryMessenger: flutterViewController.binaryMessenger)
    channel.invokeMethod("onNotificationTap", arguments: userInfo)
    
    completionHandler()
  }
    
  // Show the notification alert even when the app is in the foreground
  override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound])
  }

  // Schedule a local notification as an example
  func scheduleLocalNotification(data: Any?) {
    if data == nil {
      return
    }
      
    let payload = data as? [AnyHashable: Any]

    let content = UNMutableNotificationContent()
    content.title = (payload?["title"] as? String? ?? "") ?? ""
    content.body = (payload?["body"] as? String? ?? "") ?? ""
    content.userInfo = (payload?["userInfo"] as? [AnyHashable: Any]) ?? [:]
    content.sound = .default

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
  }

  // Deep linking
  override func application(
    _ application: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    if let flutterViewController = window?.rootViewController as? FlutterViewController {
      let methodChannel = FlutterMethodChannel(name: "com.emanuelbraz.vscode/deeplink", binaryMessenger: flutterViewController.binaryMessenger)
      methodChannel.invokeMethod("onDeeplink", arguments: url.absoluteString)
    }
    return true
  }
}
