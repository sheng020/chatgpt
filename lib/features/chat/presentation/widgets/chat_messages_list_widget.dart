import 'package:flutter/widgets.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'chat_message_single_item.dart';

class ChatMessagesListWidget extends StatefulWidget {
  final List<ChatMessageEntity> chatMessages;
  final bool isRequestProcessing;
  var isScrollViewFirstLoad = true;
  AutoScrollController scrollController;

  ChatMessagesListWidget(
      {super.key,
      required this.chatMessages,
      required this.isRequestProcessing,
      required this.scrollController});

  @override
  State<StatefulWidget> createState() {
    return ChatMessagesListState();
  }
}

class ChatMessagesListState extends State<ChatMessagesListWidget> {
  Size? lastItemSize;
  Map<String, GlobalKey> keyMaps = {};

  GlobalKey getCachedKey(String key) {
    if (keyMaps.containsKey(key)) {
      return keyMaps[key]!;
    } else {
      GlobalKey value = GlobalKey();
      keyMaps[key] = value;
      return value;
    }
  }

  int _calculateListItemLength(int length, bool isRequestProcessing) {
    if (!isRequestProcessing) {
      return length;
    } else {
      return length + 1;
    }
  }

  Widget _responsePreparingWidget(bool isRequestProcessing) {
    if (isRequestProcessing) {
      return Container(
        height: 60,
        child: Image.asset("assets/loading_response.gif"),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  void initState() {
    /* if (widget.isScrollViewFirstLoad) {
      print("first scroll");
      widget.isScrollViewFirstLoad = false;
      Future.delayed(Duration(milliseconds: 50), () {
        widget.scrollController.scrollToIndex(widget.chatMessages.length - 1,
            duration: Duration(milliseconds: 500));
      });
    } */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      cacheExtent: 1000,
      reverse: true,
      itemCount: widget.chatMessages.length + 1,
      controller: widget.scrollController,
      itemBuilder: (context, index) {
        if (index == 0) {
          return AutoScrollTag(
            key: ValueKey(index),
            controller: widget.scrollController,
            index: index,
            child: _responsePreparingWidget(widget.isRequestProcessing),
          );
        } else {
          var realIndex = index - 1;
          var chatMessage = widget.chatMessages[realIndex];
          //var itemKey = GlobalKey();

          return AutoScrollTag(
            key: ValueKey(index),
            controller: widget.scrollController,
            index: index,
            child: VisibilityDetector(
              key: ValueKey("index_$realIndex"),
              onVisibilityChanged: (VisibilityInfo visibilityInfo) {
                var visiblePercentage = visibilityInfo.visibleFraction * 100;

                var key = visibilityInfo.key as ValueKey;
                print(
                    "visible:${visiblePercentage}  ${key.value} ${widget.chatMessages.length}");
                if (widget.isRequestProcessing && key.value == "index_0") {
                  var widgetKey =
                      getCachedKey("index_${chatMessage.messageId}_0");
                  //if last widget height has changed.
                  var currentSize = widgetKey.currentContext?.size;
                  if (lastItemSize != currentSize &&
                      !widget.scrollController.isAutoScrolling) {
                    widget.scrollController.position.ensureVisible(
                        widgetKey.currentContext!.findRenderObject()!,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                        alignmentPolicy:
                            ScrollPositionAlignmentPolicy.keepVisibleAtStart);
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
