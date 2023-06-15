// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(count) => "${count} chance left. Go subscription for more";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "answer_question_tips": MessageLookupByLibrary.simpleMessage(
            "Explain quantum computing in simple terms"),
        "answer_question_title":
            MessageLookupByLibrary.simpleMessage("Answer questions"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "change_name": MessageLookupByLibrary.simpleMessage("Change name"),
        "code_assistant_title":
            MessageLookupByLibrary.simpleMessage("Code assistant"),
        "code_helper_tips": MessageLookupByLibrary.simpleMessage(
            "How do I make an HTTP request in java"),
        "input_message": MessageLookupByLibrary.simpleMessage("Input message"),
        "left_chance": m0,
        "mode_completions":
            MessageLookupByLibrary.simpleMessage("Chat completions"),
        "mode_image_generation":
            MessageLookupByLibrary.simpleMessage("Image generation"),
        "mode_image_variation":
            MessageLookupByLibrary.simpleMessage("Image variation"),
        "new_chat": MessageLookupByLibrary.simpleMessage("+ New Chat"),
        "new_conversation":
            MessageLookupByLibrary.simpleMessage("New conversation"),
        "no_chance_left": MessageLookupByLibrary.simpleMessage(
            "No chance left, watch a video or go to subscribe"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "real_time_translate":
            MessageLookupByLibrary.simpleMessage("Real time translate"),
        "select_picture":
            MessageLookupByLibrary.simpleMessage("Select a picture"),
        "stop_generating":
            MessageLookupByLibrary.simpleMessage("Stop generating."),
        "subscription": MessageLookupByLibrary.simpleMessage("Subscription"),
        "translate_tool_tips": MessageLookupByLibrary.simpleMessage(
            "How to translate \"How are you\" into Chinese and Janpanese"),
        "translate_tool_title":
            MessageLookupByLibrary.simpleMessage("Translate tool"),
        "usage": MessageLookupByLibrary.simpleMessage("Use"),
        "watch_video":
            MessageLookupByLibrary.simpleMessage("Watch video to gain chances")
      };
}
