package com.atom.mediator.billing

import android.app.Activity
import com.android.billingclient.api.BillingFlowParams
import com.android.billingclient.api.ProductDetails
import com.android.billingclient.api.Purchase
import com.atom.mediator.IService

interface SubscriptionService : IService {

    interface PurchaseListener {
        fun onPurchaseFinished(purchase: Purchase)
    }

    suspend fun establishConnection()

    suspend fun getProducts(): ProductDetails?

    suspend fun getPurchase(): List<Purchase>

    fun openSubscriptionActivity(activity: Activity, requestCode: Int, openToken: String? = null)

    fun launchBillingFlow(activity: Activity, params: BillingFlowParams)

    fun isPurchased(): Boolean

    fun setPurchaseListener(listener: PurchaseListener?)
}