import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:vpon_sdk/Datamodel/VponInterstitialAd.dart';
import 'vpon_sdk_platform_interface.dart';

VponSDK vponSDK = VponSDK();

/// An implementation of [VponSdkPlatform] that uses method channels.
class VponSDK extends VponSdkPlatform {
  /// The method channel used to interact with the native platform.

  late MethodChannel methodChannel;

  VponSDK() {
    methodChannel = MethodChannel('vpon_sdk');
    methodChannel.setMethodCallHandler(platformMethodCallHandler);
  }

  Map<int, VponInterstitialAd> interstitialAds = {};
  int lastAdId = 0;

  @override
  Future<void> init() async {
    return methodChannel.invokeMethod('init');
  }

  @override
  Future<void> loadVponInterstitialAd({
    required VponInterstitialAd interstitialAd
  }) async {
    if (!interstitialAds.values.contains(interstitialAd)) {
      try {
        int adId = ++lastAdId;
        interstitialAds[adId] = interstitialAd;

        return await methodChannel.invokeMethod("loadVponInterstitialAd", {
          "adId": adId,
          "licenseKey": interstitialAd.licenseKey,
          "platform": interstitialAd.platform,
          "testAd": interstitialAd.testAd,
        });
      } on PlatformException catch (e) {
        print("createVponInterstitialAd ! error with e: ${e}");
        rethrow;
      }
    } else {
      throw("Ad already loaded once.");
    }
  }

  @override
  Future<void> showVponInterstitialAd({
    required VponInterstitialAd interstitialAd
  }) async {
    MapEntry<int, VponInterstitialAd> data = interstitialAds.entries.firstWhere((element) => element.value == interstitialAd);

    if (!data.value.showed) {
      data.value.setAdShowed();
      return await methodChannel.invokeMethod('showVponInterstitialAd', {
        "adId": data.key
      });
    } else {
      throw("Ad can show once only.");
    }
  }

  Future<dynamic> platformMethodCallHandler(MethodCall call) async {
    int adId = call.arguments['adId'];
    VponInterstitialAd? interstitialAd = interstitialAds[adId];
    if (interstitialAd != null) {
      switch (call.method) {
        case "onVponInterstitialLoaded":
          interstitialAd.setAdLoaded();
          if (interstitialAd.eventListener?.onAdLoaded != null) {
            interstitialAd.eventListener!.onAdLoaded!();
          }
          break;
        case "onVponInterstitialFailedToLoad":
          if (interstitialAd.eventListener?.onAdFailedToLoad != null) {
            interstitialAd.eventListener!.onAdFailedToLoad!(call.arguments['error']);
          }
          break;
        case "onVponInterstitialWillOpen":
          if (interstitialAd.eventListener?.onAdOpened != null) {
            interstitialAd.eventListener!.onAdOpened!();
          }
          break;
        case "onVponInterstitialWillLeaveApplication":
          if (interstitialAd.eventListener?.onAdLeftApplication != null) {
            interstitialAd.eventListener!.onAdLeftApplication!();
          }
          break;
        case "onVponInterstitialClicked":
          if (interstitialAd.eventListener?.onAdClicked != null) {
            interstitialAd.eventListener!.onAdClicked!();
          }
          break;
        case "onVponInterstitialClosed":
          if (interstitialAd.eventListener?.onAdClosed != null) {
            interstitialAd.eventListener!.onAdClosed!();
          }
      }
    }
  }
}
