package com.atom.billing

import android.util.Log
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.Card
import androidx.compose.material.Icon
import androidx.compose.material.Scaffold
import androidx.compose.material.Text
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.paint
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.colorResource
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.android.billingclient.api.ProductDetails
import com.atom.billing.utils.Period
import java.math.BigDecimal
import java.math.RoundingMode
import java.util.Currency
import java.util.Locale


@Composable
fun SubscriptionScreen(
    onCloseClick: () -> Unit,
    billingState: BillingState,
    buy: (ProductDetails?, String?) -> Unit,
    selectedOffer: () -> String?,
    offerSelectClick: (String) -> Unit,
) {

    Scaffold { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .padding(horizontal = 24.dp)
                .fillMaxSize()
                .paint(
                    painterResource(id = R.drawable.ic_subscription_bg),
                    contentScale = ContentScale.FillBounds
                ),
        ) {
            Spacer(modifier = Modifier.weight(0.03F))
            Image(
                painter = painterResource(id = R.drawable.ic_back_arrow),
                contentDescription = "Back",
                modifier = Modifier
                    .clickable {
                        onCloseClick()
                    }
            )
            Spacer(modifier = Modifier.weight(0.32F))

            SubscriptionHeader(billingState = billingState, selectedOffer = selectedOffer)
            Spacer(modifier = Modifier.weight(0.03F))
            SubscriptionPlan(
                billingState = billingState,
                selectedOffer,
                offerSelectClick
            )
            Spacer(modifier = Modifier.weight(0.04F))
            SubscribeButton(billingState = billingState, buy = buy, selectedOffer)
            Spacer(modifier = Modifier.weight(0.03F))
        }

    }
}

@Composable
fun PlanOutline(
    modifier: Modifier = Modifier,
    isSelected: Boolean,
    offerDetails: String,
    offerSelectClick: (String) -> Unit,
    content: @Composable () -> Unit
) {
    val borderColor = if (isSelected) {
        colorResource(id = R.color.checkbox_color)
    } else {
        colorResource(id = R.color.color_E6E6E6)
    }
    val contentBackground = if (isSelected) {
        colorResource(id = R.color.checkbox_color)
    } else {
        colorResource(id = R.color.color_F9F9F9)
    }

    Box(
        modifier = modifier
            .height(96.dp)
            .background(color = contentBackground, shape = RoundedCornerShape(16.dp))
            .border(width = 2.dp, color = borderColor, shape = RoundedCornerShape(16.dp))
            .clip(shape = RoundedCornerShape(16.dp))
            .clickable { offerSelectClick(offerDetails) },
        contentAlignment = Alignment.Center
    ) {
        content()
    }

}

@Composable
fun PriceContent(
    count: Int,
    period: String,
    price: String,
    isSelected: Boolean,
) {
    val textColor = if (isSelected) {
        Color.White
    } else {
        Color.Black
    }
    Column(modifier = Modifier, horizontalAlignment = Alignment.CenterHorizontally) {
        Text(
            text = count.toString(),
            fontSize = 24.sp,
            fontWeight = FontWeight.SemiBold,
            color = textColor
        )
        Text(
            text = period,
            color = textColor,
            fontSize = 14.sp,
            fontWeight = FontWeight.SemiBold
        )
        Spacer(modifier = Modifier.height(8.dp))
        Text(
            text = price,
            color = textColor,
            fontSize = 16.sp,
            fontWeight = FontWeight.SemiBold
        )
    }
}

@Composable
fun ProductPlanField(
    modifier: Modifier = Modifier,
    offerDetails: ProductDetails.SubscriptionOfferDetails,
    selectedOffer: () -> String?,
    offerSelectClick: (String) -> Unit,
    tag: String,
) {
    offerDetails.pricingPhases.pricingPhaseList.filterNot { isOfferFree(it) }
        .firstOrNull()?.let { pricingPhase ->
            val isSelected = selectedOffer() == offerDetails.offerToken
            val period = Period.parse(pricingPhase.billingPeriod)

            PlanOutline(
                modifier = modifier,
                isSelected = isSelected,
                offerDetails = offerDetails.offerToken,
                offerSelectClick = offerSelectClick
            ) {
                val count = if (tag == QUARTERLY) {
                    period.months
                } else if (tag == MONTHLY) {
                    period.months
                } else {
                    period.years
                }
                val periodStringId = if (tag == QUARTERLY) {
                    R.string.months
                } else if (tag == MONTHLY) {
                    R.string.month
                } else {
                    R.string.year
                }
                val currency = Currency.getInstance(pricingPhase.priceCurrencyCode)
                val price = BigDecimal.valueOf((pricingPhase.priceAmountMicros / 1_000_000.0))
                    .setScale(2, RoundingMode.HALF_UP)
                    .toString()
                PriceContent(
                    count = count,
                    period = stringResource(
                        id = periodStringId,
                    ),
                    price = "${currency.getSymbol(Locale.getDefault())}${price}",
                    isSelected = isSelected
                )
            }
        }
}

@Composable
fun QuarterlyField(
    modifier: Modifier = Modifier,
    billingState: BillingStateSuccess,
    selectedOffer: () -> String?,
    offerSelectClick: (String) -> Unit
) {
    val quarterlyOffers =
        billingState.billingDetails.productDetails.findSubscriptionOfferByTag(QUARTERLY)
    quarterlyOffers?.let { offerDetails ->
        ProductPlanField(
            modifier = modifier,
            offerDetails = offerDetails,
            selectedOffer = selectedOffer,
            offerSelectClick = offerSelectClick,
            tag = QUARTERLY
        )
    }
}

@Composable
fun MonthlyField(
    modifier: Modifier = Modifier,
    billingState: BillingStateSuccess,
    selectedOffer: () -> String?,
    offerSelectClick: (String) -> Unit
) {
    val monthlyOffers =
        billingState.billingDetails.productDetails.findSubscriptionOfferByTag(MONTHLY)
    monthlyOffers?.let { offerDetails ->
        ProductPlanField(
            modifier = modifier,
            offerDetails = offerDetails,
            selectedOffer = selectedOffer,
            offerSelectClick = offerSelectClick,
            tag = MONTHLY
        )
    }
}

@Composable
fun YearlyCharge(
    modifier: Modifier = Modifier,
    billingState: BillingStateSuccess,
    selectedOffer: () -> String?,
    offerSelectClick: (String) -> Unit
) {
    val yearlyOffers = billingState.billingDetails.productDetails.findSubscriptionOfferByTag(YEARLY)
    yearlyOffers?.let { offerDetails ->
        ProductPlanField(
            modifier = modifier,
            offerDetails = offerDetails,
            selectedOffer = selectedOffer,
            offerSelectClick = offerSelectClick,
            tag = YEARLY
        )
    }
}

@Composable
fun SubscriptionPlan(
    billingState: BillingState,
    selectedOffer: () -> String?,
    offerSelectClick: (String) -> Unit
) {
    when (billingState) {
        is BillingStateSuccess -> {
            Row(verticalAlignment = Alignment.Bottom) {
                MonthlyField(
                    modifier = Modifier.weight(1f),
                    billingState = billingState,
                    selectedOffer,
                    offerSelectClick
                )
                Spacer(modifier = Modifier.width(8.dp))
                QuarterlyField(
                    modifier = Modifier.weight(1f),
                    billingState = billingState,
                    selectedOffer = selectedOffer,
                    offerSelectClick = offerSelectClick
                )
                Spacer(modifier = Modifier.width(8.dp))
                YearlyCharge(
                    modifier = Modifier.weight(1f),
                    billingState = billingState,
                    selectedOffer,
                    offerSelectClick
                )
            }

        }

        is BillingStateLoading -> {
            Text(
                text = stringResource(id = R.string.purchase_price_loading),
                fontSize = 14.sp,
                color = colorResource(id = R.color.color_A8A8A8)
            )
        }

        else -> {
            //failed
            Row {
                PlanOutline(
                    modifier = Modifier.weight(1f),
                    isSelected = selectedOffer() == QUARTERLY,
                    offerDetails = QUARTERLY,
                    offerSelectClick = offerSelectClick
                ) {
                    PriceContent(
                        count = 7,
                        period = stringResource(
                            id = R.string.days,
                        ), price = "US$0.49", isSelected = selectedOffer() == QUARTERLY
                    )
                }
                Spacer(modifier = Modifier.width(8.dp))
                PlanOutline(
                    modifier = Modifier.weight(1f),
                    isSelected = selectedOffer() == MONTHLY,
                    offerDetails = MONTHLY,
                    offerSelectClick = offerSelectClick
                ) {
                    PriceContent(
                        count = 1,
                        period = stringResource(
                            id = R.string.month,
                        ), price = "US$1.99", isSelected = selectedOffer() == MONTHLY
                    )
                }
                Spacer(modifier = Modifier.width(8.dp))
                PlanOutline(
                    modifier = Modifier.weight(1f),
                    isSelected = selectedOffer() == YEARLY,
                    offerDetails = YEARLY,
                    offerSelectClick = offerSelectClick
                ) {
                    PriceContent(
                        count = 1,
                        period = stringResource(
                            id = R.string.year,
                        ), price = "US$6.99", isSelected = selectedOffer() == YEARLY
                    )
                }
            }
        }
    }
}

@Composable
fun SubscriptionHeader(
    modifier: Modifier = Modifier,
    billingState: BillingState,
    selectedOffer: () -> String?,
) {
    Column(modifier = modifier) {
        Text(
            text = stringResource(id = R.string.full_access), fontWeight = FontWeight.SemiBold,
            fontSize = 32.sp, color = colorResource(id = R.color.subscription_title_color)
        )
        Spacer(modifier = Modifier.height(8.dp))
        FullAccessFeature(title = stringResource(id = R.string.no_ads))
        Spacer(modifier = Modifier.height(4.dp))
        FullAccessFeature(title = stringResource(id = R.string.support_gpt4))
        Spacer(modifier = Modifier.height(4.dp))
        FullAccessFeature(title = stringResource(id = R.string.unlimited_video_translation))
        Spacer(modifier = Modifier.height(12.dp))
        PriceDescription(billingState = billingState, selectedOffer = selectedOffer)
    }
}

@Composable
fun PriceDescription(billingState: BillingState, selectedOffer: () -> String?) {
    if (billingState is BillingStateSuccess) {
        val offerDetails =
            billingState.billingDetails.productDetails.subscriptionOfferDetails?.find {
                it.offerToken == selectedOffer()
            }
        val tag = offerDetails?.offerTags ?: emptyList()
        val pricePhase = offerDetails?.pricingPhases?.pricingPhaseList?.filterNot {
            isOfferFree(it)
        }?.firstOrNull()

        pricePhase?.let {
            val period = Period.parse(it.billingPeriod)
            val count = if (tag.contains(QUARTERLY)) {
                period.months
            } else if (tag.contains(MONTHLY)) {
                period.months
            } else {
                period.years
            }
            val periodStringId = if (tag.contains(QUARTERLY)) {
                R.string.months
            } else if (tag.contains(MONTHLY)) {
                R.string.month
            } else {
                R.string.year
            }
            Text(
                text = stringResource(
                    id = R.string.subscription_description_text, it.formattedPrice, "${count}${
                        stringResource(
                            id = periodStringId
                        )
                    }"
                ), style = TextStyle(
                    color = colorResource(
                        id = R.color.color_263140,
                    ), fontSize = 12.sp, fontWeight = FontWeight.SemiBold
                )
            )
        }

    }

}

@Composable
fun FullAccessFeature(title: String) {
    Row(verticalAlignment = Alignment.CenterVertically) {
        Card(
            modifier = Modifier.background(Color.White),
            elevation = 0.dp,
            shape = RoundedCornerShape(2.dp),
        ) {
            Box(
                modifier = Modifier
                    .size(12.dp)
                    .background(color = colorResource(id = R.color.checkbox_color)),
                contentAlignment = Alignment.Center
            ) {
                Icon(Icons.Default.Check, contentDescription = "", tint = Color.White)
            }
        }
        Spacer(modifier = Modifier.width(12.dp))
        Text(
            text = title,
            style = TextStyle(
                color = colorResource(id = R.color.subscription_title_color),
                fontWeight = FontWeight.SemiBold,
                fontSize = 14.sp
            )
        )
    }
}

@Composable
fun SubscribeButton(
    billingState: BillingState,
    buy: (ProductDetails?, String?) -> Unit,
    selectedOffer: () -> String?
) {
    val background = Modifier.background(
        color = colorResource(id = R.color.checkbox_color), shape = RoundedCornerShape(8.dp)
    )
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .heightIn(min = 56.dp, max = 74.dp)
            .then(background)
            .clip(shape = RoundedCornerShape(8.dp))
            .clickable {
                if (billingState is BillingStateSuccess) {
                    buy(billingState.billingDetails.productDetails, selectedOffer())
                } else if (billingState is BillingStateFailed) {
                    buy(null, selectedOffer())
                }
            },
        contentAlignment = Alignment.Center
    ) {
        Column(
            modifier = Modifier.padding(horizontal = 40.dp),
            verticalArrangement = Arrangement.SpaceEvenly,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = stringResource(id = R.string.try_subscribe_for_free),
                fontSize = 18.sp,
                color = Color.White,
                fontWeight = FontWeight.SemiBold,
                textAlign = TextAlign.Center
            )
            /*Text(
                text = stringResource(id = R.string.trail_free_note),
                textAlign = TextAlign.Center,
                fontSize = 12.sp,
                color = colorResource(
                    id = R.color.color_A8A8A8
                )
            )*/
        }

    }
}
