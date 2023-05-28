package com.atom.billing

import android.app.Activity
import android.app.Application
import android.util.Log
import androidx.lifecycle.*
import com.android.billingclient.api.BillingFlowParams
import com.android.billingclient.api.ProductDetails
import com.android.billingclient.api.Purchase
import com.atom.mediator.MediatorService
import com.atom.mediator.billing.SubscriptionService
import kotlinx.coroutines.async
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch


class BillingViewModel(application: Application) : AndroidViewModel(application) {

    private val subscriptionService: SubscriptionService = MediatorService.getService(
        SubscriptionService::class.java)

    private val _products: MutableStateFlow<BillingState> = MutableStateFlow(BillingStateLoading)
    val products: StateFlow<BillingState> = _products

    private val _selectedProduct: MutableStateFlow<String?> =
        MutableStateFlow(null)
    val selectedProduct: StateFlow<String?> = _selectedProduct

    fun setSelectedOffer(offerDetails: String) {
        _selectedProduct.value = offerDetails
    }


    fun getProductsAndPurchase() {
        viewModelScope.launch {
            val productDetailsDeffer = async {
                subscriptionService.getProducts()
            }
            val purchaseListDeffer = async {
                subscriptionService.getPurchase()
            }
            val productDetails = productDetailsDeffer.await()
            if (productDetails == null) {
                _products.value = BillingStateFailed
            } else {
                _products.value = BillingStateSuccess(
                    BillingDetails(
                        productDetails,
                        purchaseListDeffer.await()
                    )
                )
                val productDetail = productDetails.findSubscriptionOfferByTag(MONTHLY)
                if (productDetail != null) {
                    setSelectedOffer(productDetail.offerToken)

                }
            }

        }
    }

    /**
     * Retrieves all eligible base plans and offers using tags from ProductDetails.
     *
     * @param offerDetails offerDetails from a ProductDetails returned by the library.
     * @param tag string representing tags associated with offers and base plans.
     *
     * @return the eligible offers and base plans in a list.
     *
     */
    private fun retrieveEligibleOffers(
        offerDetails: MutableList<ProductDetails.SubscriptionOfferDetails>,
        tag: String
    ): List<ProductDetails.SubscriptionOfferDetails> {
        val eligibleOffers = emptyList<ProductDetails.SubscriptionOfferDetails>().toMutableList()
        offerDetails.forEach { offerDetail ->
            if (offerDetail.offerTags.contains(tag)) {
                eligibleOffers.add(offerDetail)
            }
        }

        return eligibleOffers
    }

    /**
     * Calculates the lowest priced offer amongst all eligible offers.
     * In this implementation the lowest price of all offers' pricing phases is returned.
     * It's possible the logic can be implemented differently.
     * For example, the lowest average price in terms of month could be returned instead.
     *
     * @param offerDetails List of of eligible offers and base plans.
     *
     * @return the offer id token of the lowest priced offer.
     */
    private fun leastPricedOfferToken(
        offerDetails: List<ProductDetails.SubscriptionOfferDetails>
    ): String {
        var offerToken = String()
        var leastPricedOffer: ProductDetails.SubscriptionOfferDetails
        var lowestPrice = Int.MAX_VALUE

        if (offerDetails.isNotEmpty()) {
            for (offer in offerDetails) {
                for (price in offer.pricingPhases.pricingPhaseList) {
                    if (price.priceAmountMicros < lowestPrice) {
                        lowestPrice = price.priceAmountMicros.toInt()
                        leastPricedOffer = offer
                        offerToken = leastPricedOffer.offerToken
                    }
                }
            }
        }
        return offerToken
    }

    /**
     * BillingFlowParams Builder for upgrades and downgrades.
     *
     * @param productDetails ProductDetails object returned by the library.
     * @param offerToken the least priced offer's offer id token returned by
     * [leastPricedOfferToken].
     * @param oldToken the purchase token of the subscription purchase being upgraded or downgraded.
     *
     * @return [BillingFlowParams] builder.
     */
    private fun upDowngradeBillingFlowParamsBuilder(
        productDetails: ProductDetails,
        offerToken: String,
        oldToken: String
    ): BillingFlowParams {
        return BillingFlowParams.newBuilder().setProductDetailsParamsList(
            listOf(
                BillingFlowParams.ProductDetailsParams.newBuilder()
                    .setProductDetails(productDetails)
                    .setOfferToken(offerToken)
                    .build()
            )
        ).setSubscriptionUpdateParams(
            BillingFlowParams.SubscriptionUpdateParams.newBuilder()
                .setOldPurchaseToken(oldToken)
                .setReplaceProrationMode(
                    BillingFlowParams.ProrationMode.IMMEDIATE_AND_CHARGE_FULL_PRICE
                )
                .build()
        ).build()
    }

    /**
     * BillingFlowParams Builder for normal purchases.
     *
     * @param productDetails ProductDetails object returned by the library.
     * @param offerToken the least priced offer's offer id token returned by
     * [leastPricedOfferToken].
     *
     * @return [BillingFlowParams] builder.
     */
    private fun billingFlowParamsBuilder(
        productDetails: ProductDetails,
        offerToken: String
    ): BillingFlowParams.Builder {
        return BillingFlowParams.newBuilder().setProductDetailsParamsList(
            listOf(
                BillingFlowParams.ProductDetailsParams.newBuilder()
                    .setProductDetails(productDetails)
                    .setOfferToken(offerToken)
                    .build()
            )
        )
    }

    fun buy(
        productDetails: ProductDetails,
        offerToken: String,
        activity: Activity,
    ) {
        val billingParams = offerToken.let {
            billingFlowParamsBuilder(
                productDetails = productDetails,
                offerToken = it
            )
        }

        subscriptionService.launchBillingFlow(
            activity,
            billingParams.build()
        )
    }

    /**
     * Use the Google Play Billing Library to make a purchase.
     *
     * @param productDetails ProductDetails object returned by the library.
     * @param currentPurchases List of current [Purchase] objects needed for upgrades or downgrades.
     * @param billingClient Instance of [BillingClientWrapper].
     * @param activity [Activity] instance.
     * @param tag String representing tags associated with offers and base plans.
     */
    fun buy(
        productDetails: ProductDetails,
        currentPurchases: List<Purchase>?,
        activity: Activity,
        tag: String
    ) {
        val offers =
            productDetails.subscriptionOfferDetails?.let {
                retrieveEligibleOffers(
                    offerDetails = it,
                    tag = tag.lowercase()
                )
            }
        val offerToken = offers?.let { leastPricedOfferToken(it) }
        val oldPurchaseToken: String

        // Get current purchase. In this app, a user can only have one current purchase at
        // any given time.
        if (!currentPurchases.isNullOrEmpty() &&
            currentPurchases.size == MAX_CURRENT_PURCHASES_ALLOWED
        ) {
            // This either an upgrade, downgrade, or conversion purchase.
            val currentPurchase = currentPurchases.first()

            // Get the token from current purchase.
            oldPurchaseToken = currentPurchase.purchaseToken

            val billingParams = offerToken?.let {
                upDowngradeBillingFlowParamsBuilder(
                    productDetails = productDetails,
                    offerToken = it,
                    oldToken = oldPurchaseToken
                )
            }

            if (billingParams != null) {
                subscriptionService.launchBillingFlow(
                    activity,
                    billingParams
                )
            }
        } else if (currentPurchases == null || currentPurchases.isEmpty()) {
            // This is a normal purchase.
            val billingParams = offerToken?.let {
                billingFlowParamsBuilder(
                    productDetails = productDetails,
                    offerToken = it
                )
            }

            if (billingParams != null) {
                subscriptionService.launchBillingFlow(
                    activity,
                    billingParams.build()
                )
            }
        } else if (!currentPurchases.isNullOrEmpty() &&
            currentPurchases.size > MAX_CURRENT_PURCHASES_ALLOWED
        ) {
            // The developer has allowed users  to have more than 1 purchase, so they need to
            /// implement a logic to find which one to use.
            Log.d(TAG, "User has more than 1 current purchase.")
        }
    }

    companion object {
        private const val TAG: String = "MainViewModel"

        private const val MAX_CURRENT_PURCHASES_ALLOWED = 1
    }
}