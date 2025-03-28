import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let apiKey = Bundle.main.object(forInfoDictionaryKey: "MAPS_API_KEY") as? String {
        GMSServices.provideAPIKey(apiKey)
    } else {
        fatalError("MAPS_API_KEY not found in Info.plist")
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
