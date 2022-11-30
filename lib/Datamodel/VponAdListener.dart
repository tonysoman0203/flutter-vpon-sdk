
typedef AdEventCallback = void Function();
typedef AdEventFailCallback = void Function(String error);

class VponAdListener {
  AdEventCallback? onAdClosed;
  AdEventFailCallback? onAdFailedToLoad;
  AdEventCallback? onAdLeftApplication;
  AdEventCallback? onAdOpened;
  AdEventCallback? onAdLoaded;
  AdEventCallback? onAdClicked;

  VponAdListener({
    this.onAdLoaded,
    this.onAdFailedToLoad,
    this.onAdLeftApplication,
    this.onAdOpened,
    this.onAdClosed,
    this.onAdClicked,
  });
}

