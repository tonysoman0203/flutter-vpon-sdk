
import 'package:vpon_sdk/callback/ad_listener.dart';

import 'vpon_sdk_platform_interface.dart';

class VponSdk {
  Future<String?> getPlatformVersion() {
    return VponSdkPlatform.instance.getPlatformVersion();
  }

  Future<void> initSdk () {
    return VponSdkPlatform.instance.init();
  }

  Future<dynamic> createVponInterstitialAd({required String adKey}) async{
    return VponSdkPlatform.instance.createVponInterstitialAd(
        adKey: adKey
    );
  }

  Future<String> showVponInterstitialAd() async {
    return VponSdkPlatform.instance.showVponInterstitialAd();
  }
}
