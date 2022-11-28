package man.so.tony.vpon_sdk

import android.app.Activity
import android.content.Context
import android.nfc.Tag
import android.util.Log
import androidx.annotation.NonNull
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
    private var mVponInterstitialAd: VponInterstitialAd? = null
    private val builder: VponAdRequest.Builder = VponAdRequest.Builder()
    private var isShowing = false
    private var activity: Activity? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "vpon_sdk")
        pluginContext = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "init" -> {
                VponMobileAds.initialize(pluginContext)
                Log.d(TAG, "init Vpon Success")
                result.success(true)
            }
            "createInterstitialAd" -> {
                val key = call.argument("adKey") as String?
                if (mVponInterstitialAd == null) {
                    mVponInterstitialAd = VponInterstitialAd(pluginContext, key)
                }

                mVponInterstitialAd?.setAdListener(object : VponAdListener(){
                    override fun onAdClosed() {
                        super.onAdClosed()
                        isShowing = false
                        result.success("onAdClosed")
                    }

                    override fun onAdFailedToLoad(errorCode: Int) {
                        super.onAdFailedToLoad(errorCode)

                        isShowing = false
                        val errorMessage: String = when (errorCode) {
                            3 -> "ERROR_CODE_NO_FILL"
                            2 -> "ERROR_CODE_NETWORK_ERROR"
                            1 -> "ERROR_CODE_INVALID_REQUEST"
                            0 -> "ERROR_CODE_INTERNAL_ERROR"
                            else -> "ERROR_CODE_EXCEED_ENDURANCE"
                        }
                        Log.d(TAG, "onAdFailedToLoad errorMessage =${errorMessage}")

                        result.error(errorCode.toString(), errorMessage, null)
                    }

                    override fun onAdLeftApplication() {
                        super.onAdLeftApplication()
                        isShowing = false
                        result.success("onAdLeftApplication")
                    }

                    override fun onAdLoaded() {
                        super.onAdLoaded()
                        if (!isShowing) {
                            isShowing = true
                            mVponInterstitialAd?.show()
                            result.success("onAdLoaded")
                        }

                    }

                })
            }

            "showVponInterstitialAd" -> {
                Log.d(TAG, "showVponInterstitialAd! called")
                mVponInterstitialAd?.apply {
                    loadAd(builder.build())
                    result.success("showVponInterstitialAd!")
                }
            }
            else -> {
                result.notImplemented()
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
