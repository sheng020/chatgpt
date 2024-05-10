import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_chatgpt_clone/features/global/custom_text_field/crop_page.dart';
import 'package:flutter_chatgpt_clone/features/global/theme/style.dart';

typedef PromptTrigger = void Function(int type, {String? path});

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final PromptTrigger? onTap;
  final bool isRequestProcessing;
  final ValueNotifier<int> inputMode;
  CustomTextField(
      {Key? key,
      required this.textEditingController,
      this.onTap,
      required this.inputMode,
      required this.isRequestProcessing})
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
    if (type == TYPE_CHAT) {
      return Icon(Icons.chat);
    } else if (type == TYPE_IMAGE_GENERATION) {
      return Icon(Icons.photo);
    } else if (type == TYPE_IMAGE_VARIATION) {
      return Icon(Icons.generating_tokens);
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
              "Select a picture",
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          return TextField(
            enabled: !isRequestProcessing,
            style: TextStyle(fontSize: 14),
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: "Open AI prompt",
              border: InputBorder.none,
            ),
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
      margin: EdgeInsets.only(bottom: 28, left: 150, right: 150),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: colorDarkGray),
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
                      width: 10,
                    ),
                    Container(
                      height: 40,
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
                        ? Container(
                            height: 40,
                            child: Image.asset("assets/loading_response.gif"))
                        : ValueListenableBuilder(
                            valueListenable: inputMode,
                            builder: (context, value, child) {
                              return IconButton(onPressed: () {
                                if (textEditingController.text.isEmpty ||
                                    value == TYPE_IMAGE_VARIATION) {

                                } else {
                                  onTap?.call(inputMode.value);
                                }
                              }, icon: ValueListenableBuilder(
                                valueListenable: textEditingController,
                                builder: (context, value, child) {
                                  return Icon(
                                    Icons.send,
                                    color: value.text.isEmpty
                                        ? Colors.grey.withOpacity(.4)
                                        : Colors.grey,
                                  );
                                },
                              ));
                            }),
                  ],
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}
