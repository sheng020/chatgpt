import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/conversation_loading_widget.dart';
import 'package:flutter_chatgpt_clone/features/global/const/constants.dart';
import 'package:flutter_chatgpt_clone/features/global/custom_text_field/crop_page.dart';
import 'package:flutter_chatgpt_clone/features/global/theme/style.dart';
import 'package:flutter_chatgpt_clone/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef PromptTrigger = void Function(int type, {String? path});

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final PromptTrigger? onTap;
  final bool isRequestProcessing;
  final ValueNotifier<int> inputMode;
  final ValueNotifier<String> textInputNotifier;
  CustomTextField(
      {Key? key,
      required this.textEditingController,
      this.onTap,
      required this.inputMode,
      required this.isRequestProcessing,
      required this.textInputNotifier})
      : super(key: key);

  List<PopupMenuItem<int>> getDropItems() {
    return [
      PopupMenuItem(
          value: TYPE_CHAT,
          child: getFeatureWidget(Icons.chat, "Chat completions")),
      PopupMenuItem(
          value: TYPE_IMAGE_GENERATION,
          child: getFeatureWidget(Icons.photo, "Image generation")),
      PopupMenuItem(
          value: TYPE_IMAGE_VARIATION,
          child: getFeatureWidget(Icons.generating_tokens, "Image variation"))
    ];
  }

  Widget getFeatureWidget(IconData icon, String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        SizedBox(
          width: 8,
        ),
        Text(title)
      ],
    );
  }

  Widget getIcon(int type) {
    Color color = Color(0xFF1DC338);
    if (type == TYPE_CHAT) {
      return Icon(
        Icons.chat,
        color: color,
      );
    } else if (type == TYPE_IMAGE_GENERATION) {
      return Icon(
        Icons.photo,
        color: color,
      );
    } else if (type == TYPE_IMAGE_VARIATION) {
      return Icon(
        Icons.generating_tokens,
        color: color,
      );
    } else {
      throw FlutterError("Unknown message type");
    }
  }

  Widget getTextField(bool isRequestProcessing) {
    return ValueListenableBuilder(
      valueListenable: inputMode,
      builder: (context, value, child) {
        if (value == TYPE_IMAGE_VARIATION) {
          return InkWell(
            onTap: () async {
              FilePickerResult? result =
                  await FilePicker.platform.pickFiles(type: FileType.image);
              if (result != null) {
                //File file = File(result.files.single.path!);
                //print("result:${result.files.single.path}");
                var image = await Navigator.of(context).push(
                  MaterialPageRoute<String?>(
                    builder: (BuildContext context) =>
                        CropPage(filePath: result.files.single.path!),
                  ),
                );
                onTap?.call(TYPE_IMAGE_VARIATION, path: image);
              }
            },
            child: Text(
              S.of(context).select_picture,
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          return TextField(
            //enabled: !isRequestProcessing,
            style: TextStyle(fontSize: 14.sp, color: Colors.black),
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: S.of(context).input_message,
              border: InputBorder.none,
            ),
            textInputAction: TextInputAction.send,
            onEditingComplete: () {}, // this prevents keyboard from closing
            onSubmitted: (str) {
              onTap?.call(inputMode.value);
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h, left: 16.w, right: 16.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF6D2DF5), width: 2),
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: 90,
                    ),
                    child: getTextField(isRequestProcessing),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  height: 40.h,
                  child: ValueListenableBuilder(
                    valueListenable: inputMode,
                    builder: (context, value, child) {
                      return PopupMenuButton(
                        position: PopupMenuPosition.over,
                        initialValue: value,
                        itemBuilder: (context) {
                          return getDropItems();
                        },
                        onSelected: (value) {
                          inputMode.value = value;
                        },
                        child: getIcon(value),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                isRequestProcessing
                    ? SizedBox(height: 40.h, child: ConversationLoadingWidget())
                    : ValueListenableBuilder(
                        valueListenable: textInputNotifier,
                        builder: ((context, value, child) {
                          return InkWell(
                            onTap: textEditingController.text.isEmpty ||
                                    inputMode.value == TYPE_IMAGE_VARIATION
                                ? null
                                : () {
                                    onTap?.call(inputMode.value);
                                  },
                            child: Icon(
                              Icons.send,
                              color: value.isEmpty
                                  ? Color(0xFF1DC338).withOpacity(.4)
                                  : Color(0xFF1DC338),
                            ),
                          );
                        })),
              ],
            )
          ],
        ),
      ),
    );
  }
}
