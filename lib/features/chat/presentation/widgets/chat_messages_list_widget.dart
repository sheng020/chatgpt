import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/chat_message_single_item.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ChatMessagesListWidget extends StatelessWidget {
  final List<ChatMessageEntity> chatMessages;
  final bool isRequestProcessing;
  var _isScrollViewFirstLoad = true;
  final AutoScrollController controller;

  ChatMessagesListWidget(
      {required this.chatMessages,
      required this.isRequestProcessing,
      required this.controller});

  int _calculateListItemLength(int length, bool isRequestProcessing) {
    if (!isRequestProcessing) {
      return length;
    } else {
      return length + 1;
    }
  }

  Widget _responsePreparingWidget() {
    return Container(
      height: 60,
      child: Image.asset("assets/loading_response.gif"),
    );
  }

  Map<String, GlobalKey> keyMaps = {};
  Size? lastItemSize;

  GlobalKey getCachedKey(String key) {
    if (keyMaps.containsKey(key)) {
      return keyMaps[key]!;
    } else {
      GlobalKey value = GlobalKey();
      keyMaps[key] = value;
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      cacheExtent: 1000,
      reverse: false,
      itemCount:
          _calculateListItemLength(chatMessages.length, isRequestProcessing),
      controller: controller,
      itemBuilder: (context, index) {
        if (isRequestProcessing && index == chatMessages.length) {
          return AutoScrollTag(
            key: ValueKey(index),
            controller: controller,
            index: index,
            child: _responsePreparingWidget(),
          );
        } else {
          var realIndex = index;
          var chatMessage = chatMessages[realIndex];
          //var itemKey = GlobalKey();

          if (_isScrollViewFirstLoad) {
            _isScrollViewFirstLoad = false;
            Future.delayed(Duration(milliseconds: 50), () {
              controller.scrollToIndex(chatMessages.length - 1,
                  duration: Duration(milliseconds: 500));
            });
          }

          return AutoScrollTag(
            key: ValueKey(index),
            controller: controller,
            index: index,
            child: VisibilityDetector(
              key: ValueKey("index_$realIndex"),
              onVisibilityChanged: (VisibilityInfo visibilityInfo) {
                var visiblePercentage = visibilityInfo.visibleFraction * 100;

                var key = visibilityInfo.key as ValueKey;
                print(
                    "visible:${visiblePercentage}  ${key.value} ${chatMessages.length}");
                if (isRequestProcessing &&
                    key.value == "index_${chatMessages.length - 1}") {
                  var widgetKey = getCachedKey(
                      "index_${chatMessage.messageId}_${chatMessages.length - 1}");
                  //if last widget height has changed.
                  var currentSize = widgetKey.currentContext?.size;
                  print("visible percentage:${visiblePercentage}");

                  if (lastItemSize != currentSize &&
                      !controller.isAutoScrolling) {
                    controller.scrollToIndex(chatMessages.length - 1,
                        preferPosition: AutoScrollPosition.end);
                    /* controller.position.ensureVisible(
                        widgetKey.currentContext!.findRenderObject()!,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                        alignmentPolicy:
                            ScrollPositionAlignmentPolicy.keepVisibleAtEnd); */
                    lastItemSize = currentSize;
                  }
                }
              },
              child: ChatMessageSingleItem(
                key: getCachedKey("index_${chatMessage.messageId}_$realIndex"),
                chatMessage: chatMessage,
              ),
            ),
          );
        }
      },
    );
  }
}
