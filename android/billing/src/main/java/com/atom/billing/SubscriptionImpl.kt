package com.atom.billing

import android.app.Activity
import android.content.Context
import android.content.Intent
import com.android.billingclient.api.*
import com.atom.base.Constants
import com.atom.base.Constants.Companion.OPEN_TOKEN
import com.atom.base.Constants.Companion.PREMIUM_SUB
import com.atom.base.KeyValue
import com.atom.mediator.billing.SubscriptionService
import com.atom.mediator.report.reportEvent
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine


class SubscriptionImpl(private val context: Context) : SubscriptionService {

    private var mListener: SubscriptionService.PurchaseListener? = null

    override fun setPurchaseListener(listener: SubscriptionService.PurchaseListener?) {
        this.mListener = listener
    }

    private var billingClient: BillingClient = BillingClient.newBuilder(context)
        .enablePendingPurchases()
        .setListener { billingResult, list ->
            if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
                if (list.isNullOrEmpty()) {
                    mPurchaseList.clear()
                    setPurchase(false)
                } else {
                    for (purchase in list) {
                        verifySubPurchase(purchase)
                    }
                }
            }
            logSubscribeEvent(context, billingResult.responseCode)
        }.build()

    private fun logSubscribeEvent(context: Context, responseCode: Int) {
        if (responseCode == BillingClient.BillingResponseCode.OK) {
            reportEvent(context, "PAY_subscription_success")
        } else if (responseCode == BillingClient.BillingResponseCode.USER_CANCELED) {
            // Handle an error caused by a user cancelling the purchase flow.
            reportEvent(context,"PAY_subscription_fail", hashMapOf("errorMsg" to "USER_CANCELED"))
        } else if (responseCode == BillingClient.BillingResponseCode.BILLING_UNAVAILABLE) {
            // Handle any other error codes.
            reportEvent(context,"PAY_subscription_fail", hashMapOf("errorMsg" to "BILLING_UNAVAILABLE"))
        } else if (responseCode == BillingClient.BillingResponseCode.SERVICE_UNAVAILABLE) {
            reportEvent(context,"PAY_subscription_fail", hashMapOf("errorMsg" to "SERVICE_UNAVAILABLE"))
        } else if (responseCode == BillingClient.BillingResponseCode.FEATURE_NOT_SUPPORTED) {
            reportEvent(context,"PAY_subscription_fail", hashMapOf("errorMsg" to "FEATURE_NOT_SUPPORTED"))
        }
    }

    private var lastUpdateTime = 0L

    override fun isPurchased(): Boolean {
        if (isClientReady() && System.currentTimeMillis() - lastUpdateTime > 5 * 60000) {
            CoroutineScope(Dispatchers.IO).launch {
                val purchases = queryPurchases()
                mPurchaseList.clearAndAdd(purchases)
            }
        }
        if (getPurchaseSuccess) {
            return mPurchaseList.hasPurchasedProduct()
        } else {
            return KeyValue.get(Constants.IS_PURCHASE, false)
        }
    }

    private fun verifySubPurchase(purchases: Purchase) {

        if (!purchases.isAcknowledged) {
            val acknowledgePurchaseParams = AcknowledgePurchaseParams
                .newBuilder()
                .setPurchaseToken(purchases.purchaseToken)
                .build()

            billingClient.acknowledgePurchase(acknowledgePurchaseParams) { billingResult ->

                if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
                    reportEvent(context, "PAY_subscription_success")
                    CoroutineScope(Dispatchers.Main).launch {
                        val purchasesDetails = queryPurchases()
                        mPurchaseList.clearAndAdd(purchasesDetails)
                        purchasesDetails.firstOrNull()?.let {
                            mListener?.onPurchaseFinished(it)
                        }

                    }
                }

            }
        } else {
            mPurchaseList.add(purchases)
            mListener?.onPurchaseFinished(purchases)
            setPurchase(true)
        }

    }

    private fun setPurchase(isPurchase: Boolean) {
        KeyValue.put(Constants.IS_PURCHASE, isPurchase)
    }

    private var mRetryCount = 0

    override suspend fun establishConnection() {
        billingClient.startConnection(object : BillingClientStateListener {
            override fun onBillingServiceDisconnected() {
                if (mRetryCount < 5) {
                    mRetryCount ++
                    CoroutineScope(Dispatchers.IO).launch {
                        establishConnection()
                    }
                }
            }

            override fun onBillingSetupFinished(billingResult: BillingResult) {
                //tryCacheProducts()
                mRetryCount = 0
                CoroutineScope(Dispatchers.IO).launch {
                    val purchaseDetailsDeffer = async {
                        queryPurchases()
                    }
                    val productsDeffer = async {
                        getProducts()
                    }

                    mCacheProductDetails = productsDeffer.await()
                    mPurchaseList.clearAndAdd(purchaseDetailsDeffer.await())
                }

            }

        })
    }

    private suspend fun queryProductDetails(): List<ProductDetails> {
        val params = QueryProductDetailsParams.newBuilder()
        val productList = mutableListOf<QueryProductDetailsParams.Product>()
        productList.add(
            QueryProductDetailsParams.Product.newBuilder()
                .setProductId(PREMIUM_SUB)
                .setProductType(BillingClient.ProductType.SUBS)
                .build()
        )
        params.setProductList(productList).let { productDetailsParams ->
            val result = billingClient.queryProductDetails(productDetailsParams.build())
            getProductSuccess =
                result.billingResult.responseCode == BillingClient.BillingResponseCode.OK
            return result.productDetailsList ?: emptyList()
        }
    }

    private var getProductSuccess = false
    private var mCacheProductDetails: ProductDetails? = null

    private var getPurchaseSuccess = false
    private var mPurchaseList = arrayListOf<Purchase>()

    private suspend fun queryPurchases(): List<Purchase> {
        lastUpdateTime = System.currentTimeMillis()
        if (isClientReady()) {
            val result = billingClient.queryPurchasesAsync(
                QueryPurchasesParams.newBuilder().setProductType(BillingClient.ProductType.SUBS)
                    .build()
            )
            getPurchaseSuccess =
                result.billingResult.responseCode == BillingClient.BillingResponseCode.OK
            setPurchase(result.purchasesList.hasPurchasedProduct())
            return result.purchasesList
        } else {
            return mPurchaseList
        }
    }

    private fun isClientReady(): Boolean {
        return billingClient.isReady
    }

    override suspend fun getPurchase(): List<Purchase> {
        if (getPurchaseSuccess) {
            return mPurchaseList
        } else {
            if (isClientReady()) {
                val purchases = queryPurchases()
                if (getPurchaseSuccess) {
                    mPurchaseList.clearAndAdd(purchases)
                    return mPurchaseList
                }
            }
        }
        return emptyList()
    }

    override fun launchBillingFlow(activity: Activity, params: BillingFlowParams) {
        billingClient.launchBillingFlow(activity, params)
    }

    override suspend fun getProducts(): ProductDetails? {
        if (getProductSuccess) {
            return mCacheProductDetails
        } else {

            if (isClientReady()) {
                val productDetails = queryProductDetails()

                if (productDetails.isNotEmpty()) {
                    mCacheProductDetails = productDetails.firstOrNull()
                } else {
                    getProductSuccess = false
                }
                return mCacheProductDetails

            }

        }
        return null
    }

    override fun openSubscriptionActivity(activity: Activity, requestCode: Int, openToken: String?) {
        val intent = Intent(activity, SubscriptionActivity::class.java)
        openToken?.let {
            intent.putExtra(OPEN_TOKEN, openToken)
        }
        activity.startActivityForResult(intent, requestCode)
    }
}

fun <T> MutableList<T>.clearAndAdd(list: List<T>) {
    clear()
    addAll(list)
}

fun List<Purchase>.hasPurchasedProduct(): Boolean {
    return find {
        it.isAcknowledged && it.purchaseState == Purchase.PurchaseState.PURCHASED
    } != null
}