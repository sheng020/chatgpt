package com.atom.android.chatgpt

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.util.SparseArray
import com.atom.android.chatgpt.ad.OnShowAdStartListener
import com.atom.billing.YEARLY
import com.atom.billing.findSubscriptionOfferByTag
import com.atom.mediator.MediatorService
import com.atom.mediator.billing.SubscriptionService
import com.atom.mediator.billing.isSubscriptionUser
import com.google.android.gms.ads.rewarded.RewardedAd
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class MainActivity : FlutterActivity(), MethodChannel.MethodCallHandler {

    companion object {
        const val REQUEST_SUBSCRIBE_ACTIVITY = 1003
    }

    private lateinit var mSubscriptionService: SubscriptionService
    private lateinit var mChannel: MethodChannel
    private var sparseArray: SparseArray<MethodChannel.Result> = SparseArray()
    override fun onCreate(savedInstanceState: Bundle?) {
        mSubscriptionService = MediatorService.getService(SubscriptionService::class.java)
        super.onCreate(savedInstanceState)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        mChannel.setMethodCallHandler(null)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        mChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.atom.chatgpt.channel")
        mChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "is_purchased" -> {
                val isPurchase = mSubscriptionService.isPurchased()
                result.success(isPurchase)
            }

            "open_subscription_page" -> {
                val openToken = (call.arguments as? Map<String, Any?>)?.get("openToken") as? String
                mSubscriptionService.openSubscriptionActivity(this, REQUEST_SUBSCRIBE_ACTIVITY, openToken)
                //result.success(null)
                sparseArray.put(REQUEST_SUBSCRIBE_ACTIVITY, result)
            }

            "load_reward_ad" -> {
                (application as App).loadRewardAd()
                result.success(null)
            }
            "navigate_app_store" -> {
                val intent = Intent(Intent.ACTION_VIEW).apply {
                    data = Uri.parse(
                        "https://play.google.com/store/apps/details?id=${packageName}"
                    )
                    setPackage("com.android.vending")
                }
                startActivity(intent)
                result.success(null)
            }

            "show_reward_ad" -> {
                (application as App).showRewardAd(this, object : OnShowAdStartListener {
                    override fun nextStepTrigger(rewarded: Boolean) {
                        result.success(rewarded)
                    }

                    override fun showAtOnce() {
                        //second try
                        (application as App).showRewardAd(
                            this@MainActivity,
                            object : OnShowAdStartListener {
                                override fun nextStepTrigger(rewarded: Boolean) {
                                    result.success(rewarded)
                                }

                                override fun showAtOnce() {
                                    //do nothing
                                }

                            })
                    }

                })
            }

            "get_yearly_price" -> {
                CoroutineScope(Dispatchers.IO).launch {
                    val offerDetails =
                        mSubscriptionService.getProducts()?.findSubscriptionOfferByTag(YEARLY)
                    val priceDetail = offerDetails?.pricingPhases?.pricingPhaseList?.filter {
                        it.priceAmountMicros != 0L
                    }?.firstOrNull()
                    Log.d("cjslog", "price detail:${priceDetail}")
                    if (priceDetail == null) {
                        result.success(null)
                    } else {
                        result.success(
                            mapOf(
                                "priceCurrencyCode" to priceDetail.priceCurrencyCode,
                                "priceAmountMicros" to priceDetail.priceAmountMicros
                            )
                        )

                    }
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            REQUEST_SUBSCRIBE_ACTIVITY -> {
                sparseArray[requestCode]?.success(isSubscriptionUser())
                sparseArray.remove(requestCode)
            }
        }
    }
}
