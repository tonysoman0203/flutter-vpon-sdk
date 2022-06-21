
typedef AdEventCallback = void Function();
typedef AdEventFailCallback = void Function(int errorCode);

class VponAdListener {
  const VponAdListener({
    required this.onAdLoaded,
    required this.onAdFailedToLoad,
    required this.onAdLeftApplication,
    required this.onAdOpened,
    required this.onAdClosed,
    required this.onAdClicked,
    required this.onAdImpression,
  });

  final AdEventCallback onAdClosed;
  final AdEventFailCallback onAdFailedToLoad;
  final AdEventCallback onAdLeftApplication;
  final AdEventCallback onAdOpened;
  final AdEventCallback onAdLoaded;
  final AdEventCallback onAdClicked;
  final AdEventCallback onAdImpression;

}

