import 'package:vpon_sdk/Datamodel/VponAdListener.dart';

class VponInterstitialAd {

  late String licenseKey;
  late bool testAd;
  late String? platform;
  late VponAdListener? eventListener;

  bool _showed = false;
  bool _loaded = false;

  VponInterstitialAd({
    required this.licenseKey,
    this.testAd = false,
    this.platform,
    this.eventListener,
  });

  bool get showed {
    return _showed;
  }

  setAdShowed() {
    _showed = true;
  }

  bool get loaded {
    return _loaded;
  }

  setAdLoaded() {
    _loaded = true;
  }
}