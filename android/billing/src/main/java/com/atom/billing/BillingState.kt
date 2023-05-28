package com.atom.billing

import androidx.annotation.Keep
import com.android.billingclient.api.ProductDetails
import com.android.billingclient.api.Purchase

data class BillingDetails(
  val productDetails: ProductDetails,
  val purchaseList: List<Purchase> = emptyList()
)

sealed class BillingState

object BillingStateFailed : BillingState()

object BillingStateLoading: BillingState()

class BillingStateSuccess(val billingDetails: BillingDetails): BillingState()