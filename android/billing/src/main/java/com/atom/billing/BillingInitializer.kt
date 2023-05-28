package com.atom.billing

import android.content.Context
import androidx.annotation.Keep
import androidx.startup.Initializer
import com.atom.mediator.MediatorService
import com.atom.mediator.billing.SubscriptionService
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

@Keep
class BillingInitializer : Initializer<BillingInitializer> {

    override fun create(context: Context): BillingInitializer {
        val subscriptionService = SubscriptionImpl(context)
        MediatorService.register(SubscriptionService::class.java, subscriptionService)
        CoroutineScope(Dispatchers.IO).launch {
            subscriptionService.establishConnection()
        }
        return this
    }

    override fun dependencies(): MutableList<Class<out Initializer<*>>> {
        return mutableListOf()
    }
}