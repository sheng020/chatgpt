// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static String m0(count) => "剩余${count}次试用。订阅可不限制使用";

  static String m1(count) => "剩余${count}次试用机会";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "answer_question_tips":
            MessageLookupByLibrary.simpleMessage("用简单的术语解释量子计算"),
        "answer_question_title": MessageLookupByLibrary.simpleMessage("回答问题"),
        "as_low_as": MessageLookupByLibrary.simpleMessage("低至"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "cancel_any_time": MessageLookupByLibrary.simpleMessage("随时取消"),
        "change_name": MessageLookupByLibrary.simpleMessage("更改名称"),
        "code_assistant_title": MessageLookupByLibrary.simpleMessage("代码助理"),
        "code_helper_tips":
            MessageLookupByLibrary.simpleMessage("如何在java中发出HTTP请求"),
        "daily": MessageLookupByLibrary.simpleMessage("每日"),
        "gpt_4_models": MessageLookupByLibrary.simpleMessage("更快的GPT-4模型"),
        "input_message": MessageLookupByLibrary.simpleMessage("输入消息"),
        "left_chance": m0,
        "mode_completions": MessageLookupByLibrary.simpleMessage("聊天完成"),
        "mode_image_generation": MessageLookupByLibrary.simpleMessage("图像生成"),
        "mode_image_variation": MessageLookupByLibrary.simpleMessage("图像变化"),
        "new_chat": MessageLookupByLibrary.simpleMessage("+ 新建会话"),
        "new_conversation": MessageLookupByLibrary.simpleMessage("新会话"),
        "no_back_history": MessageLookupByLibrary.simpleMessage("没有后台历史项目"),
        "no_chance_left":
            MessageLookupByLibrary.simpleMessage("没有机会离开，看视频或去订阅"),
        "no_forward_history": MessageLookupByLibrary.simpleMessage("没有前向历史项目"),
        "ok": MessageLookupByLibrary.simpleMessage("确认"),
        "opportunitie_remaining": m1,
        "privacy_policy": MessageLookupByLibrary.simpleMessage("隐私政策"),
        "real_time_translate": MessageLookupByLibrary.simpleMessage("实时翻译"),
        "remove_ads": MessageLookupByLibrary.simpleMessage("移除广告"),
        "select_picture": MessageLookupByLibrary.simpleMessage("选择一个图片"),
        "settings": MessageLookupByLibrary.simpleMessage("设置"),
        "share": MessageLookupByLibrary.simpleMessage("分享"),
        "skip": MessageLookupByLibrary.simpleMessage("跳过"),
        "special_offers": MessageLookupByLibrary.simpleMessage("特别优惠"),
        "start_free_trial": MessageLookupByLibrary.simpleMessage("开始免费试用"),
        "stop_generating": MessageLookupByLibrary.simpleMessage("停止生成。"),
        "subscription": MessageLookupByLibrary.simpleMessage("订阅"),
        "support_multilingual_gpt":
            MessageLookupByLibrary.simpleMessage("支持多语种GPT"),
        "translate_tool_tips":
            MessageLookupByLibrary.simpleMessage("如何将“你好”翻译成中文和日语"),
        "translate_tool_title": MessageLookupByLibrary.simpleMessage("翻译工具"),
        "unlimited_quick_translation":
            MessageLookupByLibrary.simpleMessage("无限快速翻译"),
        "update": MessageLookupByLibrary.simpleMessage("更新"),
        "usage": MessageLookupByLibrary.simpleMessage("使用"),
        "watch_video": MessageLookupByLibrary.simpleMessage("观看广告就有机会使用它"),
        "yearly": MessageLookupByLibrary.simpleMessage("每年")
      };
}
