package man.so.tony.vpon_sdk

import android.app.Activity
import android.content.Context
import com.google.android.gms.ads.identifier.AdvertisingIdClient
import com.vpon.ads.VponAdListener
import com.vpon.ads.VponAdRequest
import com.vpon.ads.VponInterstitialAd
import com.vpon.ads.VponMobileAds
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** VponSdkPlugin */
class VponSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    companion object {
        val TAG = VponSdkPlugin::class.simpleName
    }
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var pluginContext: Context
    private var vponInterstitialAds: MutableMap<Int, VponInterstitialAd> = mutableMapOf<Int, VponInterstitialAd>()

    private val builder: VponAdRequest.Builder = VponAdRequest.Builder()
    private var isShowing = false
    private var activity: Activity? = null
    private var mAdKey: String? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "vpon_sdk")
        pluginContext = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "init" -> {
                initVponSDK(call, result)
            }
            "loadVponInterstitialAd" -> {
                loadInterstitialAd(call, result)
            }

            "showVponInterstitialAd" -> {
                showInterstitialAd(call, result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun initVponSDK(call: MethodCall, result: Result) {
        VponMobileAds.initialize(pluginContext)
        result.success(null)
    }

    private fun loadInterstitialAd(call: MethodCall, result: Result) {
        val adId: Int? = call.argument<Int>("adId")
        val licenseKey: String? = call.argument<String>("licenseKey")
//        val platform: String? = call.argument<String>("platform")
        val testAd: Boolean = call.argument<Boolean>("testAd") == true

        adId?.let {
            if (licenseKey != null) {
                var interstitialAd = VponInterstitialAd(pluginContext, licenseKey);
                var requestBuilder = VponAdRequest.Builder()
                if (testAd) {
                    requestBuilder.addTestDevice(AdvertisingIdClient.getAdvertisingIdInfo(pluginContext).id)
                }
                interstitialAd.setAdListener(object: VponAdListener() {
                    override fun onAdClosed() {
                        channel.invokeMethod("onVponInterstitialClosed", mapOf<String, Any>(
                            Pair("adId", adId)
                        ))
                    }

                    override fun onAdFailedToLoad(errorCode: Int) {
                        val errorMessage: String = when (errorCode) {
                            3 -> "ERROR_CODE_NO_FILL"
                            2 -> "ERROR_CODE_NETWORK_ERROR"
                            1 -> "ERROR_CODE_INVALID_REQUEST"
                            0 -> "ERROR_CODE_INTERNAL_ERROR"
                            else -> "ERROR_CODE_EXCEED_ENDURANCE"
                        }

                        channel.invokeMethod(
                            "onVponInterstitialFailedToLoad", mapOf<String, Any>(
                                Pair("adId", adId),
                                Pair("error", errorMessage)
                            )
                        )
                    }

                    override fun onAdLeftApplication() {
                        channel.invokeMethod(
                            "onVponInterstitialWillLeaveApplication", mapOf<String, Any>(
                                Pair("adId", adId)
                            )
                        )
                    }

                    override fun onAdOpened() {
                        channel.invokeMethod(
                            "onVponInterstitialWillOpen", mapOf<String, Any>(
                                Pair("adId", adId)
                            )
                        )
                    }

                    override fun onAdLoaded() {
                        channel.invokeMethod(
                            "onVponInterstitialLoaded", mapOf<String, Any>(
                                Pair("adId", adId)
                            )
                        )
                    }

                    override fun onAdClicked() {
                        channel.invokeMethod(
                            "onVponInterstitialClicked", mapOf<String, Any>(
                                Pair("adId", adId)
                            )
                        )
                    }
                })
                vponInterstitialAds[adId] = interstitialAd
                interstitialAd.loadAd(builder.build())
                result.success(null)
            } else {
                result.error("1", "adId or licenseKey not provided", null)
            }
        }
    }

    private fun showInterstitialAd(call: MethodCall, result: Result) {
        val adId: Int? = call.argument<Int>("adId")
        adId?.let {
            if (adId == null) {
                result.error("2", "adId did not provide", null)
            }
            if (vponInterstitialAds.keys.contains(adId)) {
                vponInterstitialAds[adId]?.show()
                result.success(null)
            } else {
                result.error("2", "ad not found", null)
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
