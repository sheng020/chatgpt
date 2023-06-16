import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_clone/features/global/const/constants.dart';
import 'package:flutter_chatgpt_clone/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(S.of(context).settings),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 16.h,
          ),
          Material(
            type: MaterialType.transparency,
            child: Ink(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed("/webview", arguments: {
                    "title": S.of(context).privacy_policy,
                    "url": PRIVACY_URL
                  });
                },
                child: Container(
                  height: 56.h,
                  child: Row(
                    children: [
                      SizedBox(width: 16.w),
                      SvgPicture.asset("assets/images/ic_privacy.svg"),
                      SizedBox(
                        width: 24.w,
                      ),
                      Text(S.of(context).privacy_policy)
                    ],
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
