// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that looks up messages for specific locales by
// delegating to the appropriate library.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:implementation_imports, file_names, unnecessary_new
// ignore_for_file:unnecessary_brace_in_string_interps, directives_ordering
// ignore_for_file:argument_type_not_assignable, invalid_assignment
// ignore_for_file:prefer_single_quotes, prefer_generic_function_type_aliases
// ignore_for_file:comment_references

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';

import 'messages_af.dart' as messages_af;
import 'messages_ar.dart' as messages_ar;
import 'messages_bn.dart' as messages_bn;
import 'messages_en.dart' as messages_en;
import 'messages_fa.dart' as messages_fa;
import 'messages_fil.dart' as messages_fil;
import 'messages_fr.dart' as messages_fr;
import 'messages_ga.dart' as messages_ga;
import 'messages_ha.dart' as messages_ha;
import 'messages_hi.dart' as messages_hi;
import 'messages_in.dart' as messages_in;
import 'messages_iw.dart' as messages_iw;
import 'messages_la.dart' as messages_la;
import 'messages_ms.dart' as messages_ms;
import 'messages_my.dart' as messages_my;
import 'messages_om.dart' as messages_om;
import 'messages_ru.dart' as messages_ru;
import 'messages_sw.dart' as messages_sw;
import 'messages_th.dart' as messages_th;
import 'messages_tr.dart' as messages_tr;
import 'messages_ur.dart' as messages_ur;
import 'messages_vi.dart' as messages_vi;
import 'messages_zh.dart' as messages_zh;
import 'messages_zu.dart' as messages_zu;

typedef Future<dynamic> LibraryLoader();
Map<String, LibraryLoader> _deferredLibraries = {
  'af': () => new SynchronousFuture(null),
  'ar': () => new SynchronousFuture(null),
  'bn': () => new SynchronousFuture(null),
  'en': () => new SynchronousFuture(null),
  'fa': () => new SynchronousFuture(null),
  'fil': () => new SynchronousFuture(null),
  'fr': () => new SynchronousFuture(null),
  'ga': () => new SynchronousFuture(null),
  'ha': () => new SynchronousFuture(null),
  'hi': () => new SynchronousFuture(null),
  'in': () => new SynchronousFuture(null),
  'iw': () => new SynchronousFuture(null),
  'la': () => new SynchronousFuture(null),
  'ms': () => new SynchronousFuture(null),
  'my': () => new SynchronousFuture(null),
  'om': () => new SynchronousFuture(null),
  'ru': () => new SynchronousFuture(null),
  'sw': () => new SynchronousFuture(null),
  'th': () => new SynchronousFuture(null),
  'tr': () => new SynchronousFuture(null),
  'ur': () => new SynchronousFuture(null),
  'vi': () => new SynchronousFuture(null),
  'zh': () => new SynchronousFuture(null),
  'zu': () => new SynchronousFuture(null),
};

MessageLookupByLibrary? _findExact(String localeName) {
  switch (localeName) {
    case 'af':
      return messages_af.messages;
    case 'ar':
      return messages_ar.messages;
    case 'bn':
      return messages_bn.messages;
    case 'en':
      return messages_en.messages;
    case 'fa':
      return messages_fa.messages;
    case 'fil':
      return messages_fil.messages;
    case 'fr':
      return messages_fr.messages;
    case 'ga':
      return messages_ga.messages;
    case 'ha':
      return messages_ha.messages;
    case 'hi':
      return messages_hi.messages;
    case 'in':
      return messages_in.messages;
    case 'iw':
      return messages_iw.messages;
    case 'la':
      return messages_la.messages;
    case 'ms':
      return messages_ms.messages;
    case 'my':
      return messages_my.messages;
    case 'om':
      return messages_om.messages;
    case 'ru':
      return messages_ru.messages;
    case 'sw':
      return messages_sw.messages;
    case 'th':
      return messages_th.messages;
    case 'tr':
      return messages_tr.messages;
    case 'ur':
      return messages_ur.messages;
    case 'vi':
      return messages_vi.messages;
    case 'zh':
      return messages_zh.messages;
    case 'zu':
      return messages_zu.messages;
    default:
      return null;
  }
}

/// User programs should call this before using [localeName] for messages.
Future<bool> initializeMessages(String localeName) {
  var availableLocale = Intl.verifiedLocale(
      localeName, (locale) => _deferredLibraries[locale] != null,
      onFailure: (_) => null);
  if (availableLocale == null) {
    return new SynchronousFuture(false);
  }
  var lib = _deferredLibraries[availableLocale];
  lib == null ? new SynchronousFuture(false) : lib();
  initializeInternalMessageLookup(() => new CompositeMessageLookup());
  messageLookup.addLocale(availableLocale, _findGeneratedMessagesFor);
  return new SynchronousFuture(true);
}

bool _messagesExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    return false;
  }
}

MessageLookupByLibrary? _findGeneratedMessagesFor(String locale) {
  var actualLocale =
      Intl.verifiedLocale(locale, _messagesExistFor, onFailure: (_) => null);
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}
