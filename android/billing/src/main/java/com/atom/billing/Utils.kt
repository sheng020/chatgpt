package com.atom.billing

import com.android.billingclient.api.ProductDetails
import com.android.billingclient.api.ProductDetails.PricingPhase
import com.atom.base.Constants
import com.atom.base.KeyValue

const val YEARLY = "yearly"
const val MONTHLY = "monthly"
const val QUARTERLY = "quarterly"

fun openMoreThanADay(): Boolean {
    val lastOpenTime = KeyValue.get(Constants.LAST_OPEN_SUBSCRIPTION, 0L)
    return System.currentTimeMillis() - lastOpenTime > 24 * 3600000
}

fun ProductDetails.findSubscriptionOfferByTag(tag: String): ProductDetails.SubscriptionOfferDetails? {
    var details: ProductDetails.SubscriptionOfferDetails? = null
    subscriptionOfferDetails?.run {
        forEach {
            if (it.offerTags.contains(tag)) {
                details = it
                return@run
            }
        }
    }
    return details
}

fun ProductDetails.getPriceByTag(tag: String): String? {
    return findSubscriptionOfferByTag(tag)?.pricingPhases?.pricingPhaseList?.filterNot {
        isOfferFree(
            it
        )
    }?.firstOrNull()?.let {
        it.formattedPrice
    }
}

fun isOfferFree(pricePhase: PricingPhase): Boolean {
    return pricePhase.priceAmountMicros == 0L
}