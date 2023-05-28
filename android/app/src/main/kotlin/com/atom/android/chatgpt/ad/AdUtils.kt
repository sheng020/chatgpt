package com.atom.android.chatgpt.ad

import com.atom.android.chatgpt.BuildConfig
import com.atom.base.Constants.Companion.REWARDED_AD_UNIT_DEBUG
import com.atom.base.Constants.Companion.REWARDED_AD_UNIT_RELEASE

fun getRewardUnitId(): String {
    if (BuildConfig.DEBUG) {
        return REWARDED_AD_UNIT_DEBUG
    } else {
        return REWARDED_AD_UNIT_RELEASE
    }
}