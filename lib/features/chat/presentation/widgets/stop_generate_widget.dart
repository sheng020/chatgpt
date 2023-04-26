import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/chat_conversation/chat_conversation_cubit.dart';

class StopGenerateWidget extends StatelessWidget {
  final bool isRequestProcessing;

  const StopGenerateWidget({required this.isRequestProcessing});

  @override
  Widget build(BuildContext context) {
    Widget stopGenerating;
    if (isRequestProcessing) {
      stopGenerating = Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.black45,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "Stop generating.",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            onPressed: () {
              BlocProvider.of<ChatConversationCubit>(context).stopGeneration();
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
