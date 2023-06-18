import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/purchase_cubit.dart';
import 'package:flutter_chatgpt_clone/features/global/channel/native_channel.dart';
import 'package:flutter_chatgpt_clone/features/global/const/constants.dart';
import 'package:flutter_chatgpt_clone/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscountsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
          child: Column(children: [
        SizedBox(
          height: 48.h,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Material(
              type: MaterialType.transparency,
              child: Ink(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Color(0xFF298DFF), width: 0.5.r),
                      color: Color(0x4D298DFF),
                      borderRadius: BorderRadius.all(Radius.circular(16.r))),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
                      child: Text(
                        S.of(context).skip,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )),
            ),
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) =>
              LinearGradient(colors: [Color(0xFF03C7D1), Color(0xFF398AFE)])
                  .createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            S.of(context).special_offers,
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "50",
                      style: TextStyle(
                          fontSize: 100.sp,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF21D8E8)),
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "%",
                          style: TextStyle(
                              fontSize: 40.sp,
                              color: Color(0xFF21D8E8),
                              fontWeight: FontWeight.w900),
                        ),
                        Text(
                          "OFF",
                          style: TextStyle(
                              color: Color(0xFF21D8E8),
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w900),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 68.h,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 36.w),
                  decoration: BoxDecoration(
                      color: Color(0x4D4556C1),
                      borderRadius: BorderRadius.all(Radius.circular(20.r))),
                  padding:
                      EdgeInsets.symmetric(vertical: 24.h, horizontal: 18.w),
                  child: Column(
                    children: [
                      getDiscountTips(S.of(context).remove_ads),
                      SizedBox(
                        height: 12.h,
                      ),
                      getDiscountTips(S.of(context).gpt_4_models),
                      SizedBox(
                        height: 12.h,
                      ),
                      getDiscountTips(
                          S.of(context).unlimited_quick_translation),
                      SizedBox(
                        height: 12.h,
                      ),
                      getDiscountTips(S.of(context).support_multilingual_gpt)
                    ],
                  ),
                )
              ],
            ),
            Positioned.fill(
                child: Align(
              alignment: Alignment(0, -.5),
              child: Image.asset("assets/images/ic_discount.png"),
            ))
          ],
        ),
        SizedBox(
          height: 32.h,
        ),
        FutureBuilder<YearlyPrice?>(
            future: NativeChannel.getYearlyPrice(),
            builder: (context, snapshot) {
              print("object has data:${snapshot.hasData}");
              if (snapshot.hasData) {
                var yearlyPrice = snapshot.data!;
                print("yearly :${yearlyPrice.amount} ${yearlyPrice.currency}");
                var oldPrice =
                    (yearlyPrice.amount * 2 / 1000000).toStringAsFixed(2);
                var newPriceAmount = yearlyPrice.amount;
                var dailyPrice =
                    (newPriceAmount / 365 / 1000000).toStringAsFixed(2);
                var newPrice = (newPriceAmount / 1000000).toStringAsFixed(2);
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${yearlyPrice.currency} ${oldPrice}",
                          style: TextStyle(
                              color: Color(0x80FFFFFF),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.lineThrough),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          "${yearlyPrice.currency} ${newPrice}/${S.of(context).yearly}",
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFFB902),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      "${S.of(context).as_low_as} ${yearlyPrice.currency} ${dailyPrice} / ${S.of(context).daily}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            }),
        SizedBox(
          height: 24.h,
        ),
        Text(
          S.of(context).cancel_any_time,
          style: TextStyle(
              color: Color(0xFF4556C1),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 16.h,
        ),
        TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Color(0xFF298DFF),
                minimumSize: Size(312.w, 54.h)),
            onPressed: () async {
              var isPurchase = await BlocProvider.of<PurchaseCubit>(context)
                  .openSubscriptionPage();
              if (isPurchase) {
                Navigator.of(context).pop();
              }
            },
            child: Text(
              S.of(context).start_free_trial,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600),
            )),
        Spacer(),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed("/webview", arguments: {
              "title": S.of(context).privacy_policy,
              "url": PRIVACY_URL
            });
          },
          child: Text(
            S.of(context).privacy_policy,
            style: TextStyle(
                color: Color(0x66FFFFFF),
                fontSize: 10.sp,
                fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 24.h,
        )
      ])),
    );
  }

  Widget getDiscountTips(String title) {
    return Row(
      children: [
        ClipOval(
          child: Container(
            height: 6.r,
            width: 6.r,
            color: Color(0xFF0077FF),
          ),
        ),
        SizedBox(
          width: 6.w,
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}
