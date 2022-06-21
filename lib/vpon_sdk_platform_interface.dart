import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:vpon_sdk/callback/ad_listener.dart';
import 'vpon_sdk_method_channel.dart';

abstract class VponSdkPlatform extends PlatformInterface {
  /// Constructs a VponSdkPlatform.
  VponSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static VponSdkPlatform _instance = MethodChannelVponSdk();

  /// The default instance of [VponSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelVponSdk].
  static VponSdkPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VponSdkPlatform] when
  /// they register themselves.
  static set instance(VponSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> init() async {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<void> createVponInterstitialAd({required String adKey}) async {
    throw UnimplementedError('showVponInterstitialAd() has not been implemented.');
  }

  Future<void> showVponInterstitialAd() async {
    throw UnimplementedError('showVponInterstitialAd() has not been implemented.');
  }
}
