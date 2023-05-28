package com.atom.android.chatgpt.ad

import android.app.Activity
import android.content.Context
import android.util.Log
import com.atom.mediator.report.reportEvent
import com.google.android.gms.ads.AdError
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.FullScreenContentCallback
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.OnUserEarnedRewardListener
import com.google.android.gms.ads.rewarded.RewardItem
import com.google.android.gms.ads.rewarded.RewardedAd
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback
import java.util.*

interface OnShowAdStartListener {
    fun nextStepTrigger(rewarded: Boolean)
}

class RewardAdManager(private val mContext: Context) {

    companion object {
        const val TAG = "RewardAdManager"
    }

    private var rewardedAd: RewardedAd? = null
    private var adIsLoading: Boolean = false
    private var loadTime: Long = 0
    private var isShowingAd = false

    fun loadAd(
        showAtOnce: Boolean = false,
        activity: Activity? = null,
        onShowAdStartListener: OnShowAdStartListener? = null
    ) {
        check(showAtOnce && activity != null)
        if (adIsLoading) {
            return
        }
        if (isOnlineAdAvailable()) {
            return
        }
        adIsLoading = true
        val adRequest = AdRequest.Builder().build()

        reportEvent(mContext, "Ad_interstitial_ad_start_load")
        RewardedAd.load(
            mContext,
            getRewardUnitId(),
            adRequest,
            object : RewardedAdLoadCallback() {
                override fun onAdFailedToLoad(adError: LoadAdError) {
                    rewardedAd = null
                    adIsLoading = false
                    reportEvent(
                        mContext,
                        "Ad_reward_ad_failed_to_load",
                        hashMapOf("reason" to adError.message)
                    )
                }

                override fun onAdLoaded(ad: RewardedAd) {
                    rewardedAd = ad
                    adIsLoading = false
                    loadTime = Date().time
                    reportEvent(mContext, "Ad_reward_ad_loaded")
                    if (showAtOnce) {
                        showRewarded()
                    }
                }
            }
        )
    }

    /** Check if ad exists and can be shown. */
    private fun isOnlineAdAvailable(): Boolean {
        // Ad references in the app open beta will time out after four hours, but this time limit
        // may change in future beta versions. For details, see:
        // https://support.google.com/admob/answer/9341964?hl=en
        return rewardedAd != null && wasLoadTimeLessThanNHoursAgo(4, loadTime)
    }

    //private var onShowAdStartListener: OnShowAdStartListener? = null

    fun showRewarded(activity: Activity, onShowAdStartListener: OnShowAdStartListener) {
        if (isShowingAd) {
            Log.d(TAG, "The interstitial ad is already showing.")
            return
        }

        if (!isOnlineAdAvailable()) {
            //如果广告没加载成功，等广告成功
            //onShowAdStartListener.nextStepTrigger(false)
            //this.onShowAdStartListener = onShowAdStartListener
            loadAd(showAtOnce = true, activity, onShowAdStartListener)
            return
        }
        rewardedAd?.let {
            it.fullScreenContentCallback = object : FullScreenContentCallback() {

                override fun onAdDismissedFullScreenContent() {
                    rewardedAd = null
                    isShowingAd = false
                    loadAd()
                    reportEvent(activity, "ad_rewarded_dismissed_fullscreen")
                }

                override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                    rewardedAd = null
                    isShowingAd = false
                    reportEvent(
                        activity,
                        "ad_rewarded_failed_to_show",
                        hashMapOf("reason" to adError.message)
                    )

                    onShowAdStartListener.nextStepTrigger(false)
                }

                override fun onAdShowedFullScreenContent() {
                    reportEvent(activity, "ad_rewarded_showed_fullscreen")
                }

                override fun onAdImpression() {
                    reportEvent(activity, "ad_rewarded_impression")
                }

                override fun onAdClicked() {
                    reportEvent(activity, "ad_rewarded_clicked")
                }
            }
            isShowingAd = true
            reportEvent(activity, "ad_rewarded_call_show")
            it.show(
                activity
            ) { rewardItem -> onShowAdStartListener.nextStepTrigger(rewardItem.amount > 0) }
        } ?: run {
            onShowAdStartListener.nextStepTrigger(false)
        }
    }
}

/** Check if ad was loaded more than n hours ago. */
fun wasLoadTimeLessThanNHoursAgo(numHours: Long, loadTime: Long): Boolean {
    val dateDifference: Long = Date().time - loadTime
    val numMilliSecondsPerHour: Long = 3600000
    return dateDifference < numMilliSecondsPerHour * numHours
}