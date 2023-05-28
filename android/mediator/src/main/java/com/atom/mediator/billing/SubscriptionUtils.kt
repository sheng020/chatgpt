package com.atom.mediator.billing

import com.atom.mediator.MediatorService

fun isSubscriptionUser(): Boolean {
    return MediatorService.getService(SubscriptionService::class.java)
        .isPurchased()
}