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
import 'package:flutter_svg/svg.dart';

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

  List<PopupMenuItem<int>> getDropItems(BuildContext context) {
    return [
      PopupMenuItem(
          value: TYPE_CHAT,
          child: getFeatureWidget(
              SvgPicture.asset("assets/images/mode_image_generation.svg"),
              S.of(context).mode_completions)),
      PopupMenuItem(
          value: TYPE_IMAGE_GENERATION,
          child: getFeatureWidget(
              SvgPicture.asset("assets/images/mode_image_generation.svg"),
              S.of(context).mode_image_generation)),
      PopupMenuItem(
          value: TYPE_IMAGE_VARIATION,
          child: getFeatureWidget(
              SvgPicture.asset("assets/images/mode_image_variation.svg"),
              S.of(context).mode_image_variation)),
      PopupMenuItem(
          value: TYPE_REAL_TIME_TRANSLATE,
          child: getFeatureWidget(
              SvgPicture.asset("assets/images/real_time_translate.svg"),
              S.of(context).real_time_translate))
    ];
  }

  Widget getFeatureWidget(Widget header, String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        header,
        SizedBox(
          width: 4,
        ),
        Text(
          title,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp),
        )
      ],
    );
  }

  Widget getIcon(int type) {
    if (type == TYPE_CHAT) {
      return SvgPicture.asset(
        "assets/images/mode_image_generation.svg",
        colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
      );
    } else if (type == TYPE_IMAGE_GENERATION) {
      return SvgPicture.asset(
        "assets/images/mode_image_generation.svg",
        colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
      );
    } else if (type == TYPE_IMAGE_VARIATION) {
      return SvgPicture.asset(
        "assets/images/mode_image_variation.svg",
        colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
      );
    } else if (type == TYPE_REAL_TIME_TRANSLATE) {
      return SvgPicture.asset(
        "assets/images/real_time_translate.svg",
        colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
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
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
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
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.r))),
                  color: Color(0xFF2F374C),
                  position: PopupMenuPosition.over,
                  initialValue: value,
                  itemBuilder: (context) {
                    return getDropItems(context);
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
                    return Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: textEditingController.text.isEmpty ||
                                inputMode.value == TYPE_IMAGE_VARIATION
                            ? null
                            : () {
                                onTap?.call(inputMode.value);
                              },
                        child: SvgPicture.asset(
                          "assets/images/ic_send_message.svg",
                          colorFilter: value.isNotEmpty
                              ? ColorFilter.mode(
                                  Color(0xFF298DFF), BlendMode.srcIn)
                              : ColorFilter.mode(
                                  Color(0xFF298DFF).withOpacity(.3),
                                  BlendMode.srcIn),
                        ),
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}
