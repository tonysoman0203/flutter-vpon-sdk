import Flutter
import UIKit
import VpadnSDKAdKit
import AdSupport


public class SwiftVponSdkPlugin: NSObject, FlutterPlugin {
    var channel: FlutterMethodChannel
    var interstitalAds : [Int: VpadnInterstitial] = [:];
    
    init(channel : FlutterMethodChannel) {
        self.channel = channel
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vpon_sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftVponSdkPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            initVponSDK(call, result: result)
        case "loadVponInterstitialAd":
            loadVponInterstitialAd(call, result: result)
        case "showVponInterstitialAd":
            showInterstitialAd(call, result: result)
        default:
            result(FlutterError(code: "0", message: "method did not support", details: nil))
        }
    }
    
    func initVponSDK(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let config = VpadnAdConfiguration.sharedInstance()
        config.initializeSdk()
        result(nil)
    }
    
    func loadVponInterstitialAd(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if  let adId: Int = (call.arguments as? [String: Any])?["adId"] as? Int,
            let licenseKey: String = (call.arguments as? [String: Any])?["licenseKey"] as? String,
           let platform: String? = (call.arguments as? [String: Any])?["platform"] as? String?,
           let testAd: Bool? = (call.arguments as? [String: Any])?["testAd"] as? Bool?
        {
            let interstitialAd: VpadnInterstitial = VpadnInterstitial(licenseKey: licenseKey)
            interstitialAd.delegate = self
            if (platform != nil) {
                interstitialAd.platform = platform!
            }
            let vpadnRequest = VpadnAdRequest()
            if (testAd ?? false) {
                vpadnRequest.setTestDevices([ASIdentifierManager.shared().advertisingIdentifier.uuidString])
            }
            interstitalAds[adId] = interstitialAd
            interstitialAd.load(vpadnRequest)
            result(nil)
        } else {
            result(FlutterError(code: "1", message: "adKey did not provide", details: nil))
        }
        
    }
    
    func showInterstitialAd(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let adId: Int = (call.arguments as? [String: Any])?["adId"] as? Int {
            print("show: \(adId)")
            let interstitialAd = interstitalAds[adId]
            interstitialAd?.show(fromRootViewController: (UIApplication.shared.keyWindow?.rootViewController)!)
            result(nil)
        } else {
            result(FlutterError(code: "2", message: "adId did not provide", details: nil))
        }
    }
}

extension SwiftVponSdkPlugin : VpadnInterstitialDelegate {
    public func onVpadnInterstitialLoaded(_ interstitial: VpadnInterstitial) {
        // Invoked if receive Banner Ad successfully
        channel.invokeMethod("onVponInterstitialLoaded", arguments: [
            "adId": interstitalAds.first(where: { (key: Int, value: VpadnInterstitial) in
                return value == interstitial
            })?.key
        ])
    }
    public func onVpadnInterstitial(_ interstitial: VpadnInterstitial, failedToLoad error: Error) {
        // Invoked if received ad fail, check this callback to indicates what type of failure occurred
        channel.invokeMethod("onVponInterstitialFailedToLoad", arguments: [
            "adId": interstitalAds.first(where: { (key: Int, value: VpadnInterstitial) in
                return value == interstitial
            })?.key,
            "error": error.localizedDescription,
        ])
    }
    public func onVpadnInterstitialWillOpen(_ interstitial: VpadnInterstitial) {
        // Invoked if the Interstitial Ad is going to be displayed
        channel.invokeMethod("onVponInterstitialWillOpen", arguments: [
            "adId": interstitalAds.first(where: { (key: Int, value: VpadnInterstitial) in
                return value == interstitial
            })?.key
        ])
    }
    public func onVpadnInterstitialWillLeaveApplication(_ interstitial: VpadnInterstitial) {
        // Invoked if user leave the app and the current app was backgrounded
        channel.invokeMethod("onVponInterstitialWillLeaveApplication", arguments: [
            "adId": interstitalAds.first(where: { (key: Int, value: VpadnInterstitial) in
                return value == interstitial
            })?.key
        ])
    }
    public func onVpadnInterstitialClicked(_ interstitial: VpadnInterstitial) {
        // Invoked if the Banner Ad was clicked
        channel.invokeMethod("onVponInterstitialClicked", arguments: [
            "adId": interstitalAds.first(where: { (key: Int, value: VpadnInterstitial) in
                return value == interstitial
            })?.key
        ])
    }
    public func onVpadnInterstitialClosed(_ interstitial: VpadnInterstitial) {
        channel.invokeMethod("onVponInterstitialClosed", arguments: [
            "adId": interstitalAds.first(where: { (key: Int, value: VpadnInterstitial) in
                return value == interstitial
            })?.key
        ])
    }
}
