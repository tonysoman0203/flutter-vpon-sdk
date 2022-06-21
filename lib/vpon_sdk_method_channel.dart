import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'callback/ad_listener.dart';
import 'vpon_sdk_platform_interface.dart';

/// An implementation of [VponSdkPlatform] that uses method channels.
class MethodChannelVponSdk extends VponSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('vpon_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> init() async {
    await methodChannel.invokeMethod('init');
  }

  @override
  Future<void> createVponInterstitialAd({required String adKey}) async {
    await methodChannel.invokeMethod("createInterstitialAd", {
      "adKey": adKey,
    });
  }

  @override
  Future<void> showVponInterstitialAd() async {
    await methodChannel.invokeMethod('showVponInterstitialAd');
  }
}
