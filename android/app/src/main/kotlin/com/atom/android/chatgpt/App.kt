package com.atom.android.chatgpt

import android.app.Activity
import com.atom.android.chatgpt.ad.OnShowAdStartListener
import com.atom.android.chatgpt.ad.RewardAdManager
import com.google.android.gms.ads.MobileAds
import io.flutter.app.FlutterApplication

class App : FlutterApplication() {

    private lateinit var rewardedAdManager: RewardAdManager

    override fun onCreate() {
        super.onCreate()
        MobileAds.initialize(this) {}
        rewardedAdManager = RewardAdManager(this)
    }

    fun loadRewardAd() {
        rewardedAdManager.loadAd()
    }

    fun showRewardAd(activity: Activity, onShowAdStartListener: OnShowAdStartListener) {
        rewardedAdManager.showRewarded(activity, onShowAdStartListener)
    }
}