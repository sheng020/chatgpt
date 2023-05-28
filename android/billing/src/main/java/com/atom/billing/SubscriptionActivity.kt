package com.atom.billing

import android.app.Activity
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.material.MaterialTheme
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.graphics.Color
import androidx.core.view.WindowCompat
import com.android.billingclient.api.Purchase
import com.atom.base.Constants
import com.atom.base.KeyValue
import com.atom.base.showToast
import com.atom.mediator.MediatorService
import com.atom.mediator.billing.SubscriptionService
import com.atom.mediator.report.reportEvent
import com.google.accompanist.systemuicontroller.rememberSystemUiController


class SubscriptionActivity : ComponentActivity(), SubscriptionService.PurchaseListener {

    private val billingViewModel: BillingViewModel by viewModels()
    private val subscriptionService: SubscriptionService = MediatorService.getService(
        SubscriptionService::class.java
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        WindowCompat.setDecorFitsSystemWindows(window, true)

        setContent {

            rememberSystemUiController().run {
                val color = Color.White
                val darkIcons = MaterialTheme.colors.isLight
                // 设置状态栏颜色
                setStatusBarColor(
                    color = color,
                    darkIcons = darkIcons
                )
                // 将状态栏和导航栏设置为color
                setSystemBarsColor(color = color, darkIcons = darkIcons)
                // 设置导航栏颜色
                setNavigationBarColor(color = color, darkIcons = darkIcons)
            }

            val billingState by billingViewModel.products.collectAsState()
            val selectedProduct by billingViewModel.selectedProduct.collectAsState()

            LaunchedEffect(key1 = Unit, block = {
                billingViewModel.getProductsAndPurchase()
                subscriptionService.setPurchaseListener(this@SubscriptionActivity)
            })
            SubscriptionScreen(
                billingState = billingState,
                onCloseClick = {
                    finish()
                    reportEvent(this, "PAY_subscription_page_back_click")
                },
                buy = { details, offerToken ->
                    if (details != null && offerToken != null) {
                        reportEvent(this, "SU_click_subscription")
                        billingViewModel.buy(
                            details,
                            offerToken,
                            this
                        )
                    } else {
                        reportEvent(this, "SU_click_subscription_failed")
                        showToast(R.string.purchase_obtain_fail)
                    }
                },
                selectedOffer = {
                    selectedProduct
                },
                offerSelectClick = {
                    billingViewModel.setSelectedOffer(it)
                }
            )
        }
        reportEvent(this, "PAY_subscription_page_enter")
    }

    override fun onDestroy() {
        super.onDestroy()
        subscriptionService.setPurchaseListener(null)
        KeyValue.put(Constants.LAST_OPEN_SUBSCRIPTION, System.currentTimeMillis())
    }

    override fun finish() {
        setResult(Activity.RESULT_OK)
        super.finish()
    }

    override fun onPurchaseFinished(purchase: Purchase) {
        if (purchase.isAcknowledged && purchase.purchaseState == Purchase.PurchaseState.PURCHASED) {
            finish()
        }
    }
}