import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/chat_conversation/chat_conversation_cubit.dart';
import 'package:flutter_chatgpt_clone/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StopGenerateWidget extends StatelessWidget {
  final bool isRequestProcessing;
  final int type;

  const StopGenerateWidget(
      {required this.isRequestProcessing, required this.type});

  @override
  Widget build(BuildContext context) {
    Widget stopGenerating;
    if (isRequestProcessing) {
      stopGenerating = Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.black45,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24.r)))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
              child: Text(
                S.of(context).stop_generating,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
            onPressed: () {
              BlocProvider.of<ChatConversationCubit>(context)
                  .stopGeneration(type);
            },
          ),
        ),
      );
    } else {
      stopGenerating = SizedBox.shrink();
    }
    return stopGenerating;
  }
}
