// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Change name`
  String get change_name {
    return Intl.message(
      'Change name',
      name: 'change_name',
      desc: '',
      args: [],
    );
  }

  /// `+ New Chat`
  String get new_chat {
    return Intl.message(
      '+ New Chat',
      name: 'new_chat',
      desc: '',
      args: [],
    );
  }

  /// `New conversation`
  String get new_conversation {
    return Intl.message(
      'New conversation',
      name: 'new_conversation',
      desc: '',
      args: [],
    );
  }

  /// `Input message`
  String get input_message {
    return Intl.message(
      'Input message',
      name: 'input_message',
      desc: '',
      args: [],
    );
  }

  /// `Stop generating.`
  String get stop_generating {
    return Intl.message(
      'Stop generating.',
      name: 'stop_generating',
      desc: '',
      args: [],
    );
  }

  /// `{count} chance left. Go subscription for more`
  String left_chance(Object count) {
    return Intl.message(
      '$count chance left. Go subscription for more',
      name: 'left_chance',
      desc: '',
      args: [count],
    );
  }

  /// `Subscription`
  String get subscription {
    return Intl.message(
      'Subscription',
      name: 'subscription',
      desc: '',
      args: [],
    );
  }

  /// `Watch video to gain chances`
  String get watch_video {
    return Intl.message(
      'Watch video to gain chances',
      name: 'watch_video',
      desc: '',
      args: [],
    );
  }

  /// `Select a picture`
  String get select_picture {
    return Intl.message(
      'Select a picture',
      name: 'select_picture',
      desc: '',
      args: [],
    );
  }

  /// `No chance left, watch a video or go to subscribe`
  String get no_chance_left {
    return Intl.message(
      'No chance left, watch a video or go to subscribe',
      name: 'no_chance_left',
      desc: '',
      args: [],
    );
  }

  /// `Explain quantum computing in simple terms`
  String get answer_question_tips {
    return Intl.message(
      'Explain quantum computing in simple terms',
      name: 'answer_question_tips',
      desc: '',
      args: [],
    );
  }

  /// `How do I make an HTTP request in java`
  String get code_helper_tips {
    return Intl.message(
      'How do I make an HTTP request in java',
      name: 'code_helper_tips',
      desc: '',
      args: [],
    );
  }

  /// `How to translate "How are you" into Chinese and Janpanese`
  String get translate_tool_tips {
    return Intl.message(
      'How to translate "How are you" into Chinese and Janpanese',
      name: 'translate_tool_tips',
      desc: '',
      args: [],
    );
  }

  /// `Answer questions`
  String get answer_question_title {
    return Intl.message(
      'Answer questions',
      name: 'answer_question_title',
      desc: '',
      args: [],
    );
  }

  /// `Code assistant`
  String get code_assistant_title {
    return Intl.message(
      'Code assistant',
      name: 'code_assistant_title',
      desc: '',
      args: [],
    );
  }

  /// `Translate tool`
  String get translate_tool_title {
    return Intl.message(
      'Translate tool',
      name: 'translate_tool_title',
      desc: '',
      args: [],
    );
  }

  /// `Chat completions`
  String get mode_completions {
    return Intl.message(
      'Chat completions',
      name: 'mode_completions',
      desc: '',
      args: [],
    );
  }

  /// `Image generation`
  String get mode_image_generation {
    return Intl.message(
      'Image generation',
      name: 'mode_image_generation',
      desc: '',
      args: [],
    );
  }

  /// `Image variation`
  String get mode_image_variation {
    return Intl.message(
      'Image variation',
      name: 'mode_image_variation',
      desc: '',
      args: [],
    );
  }

  /// `Real time translate`
  String get real_time_translate {
    return Intl.message(
      'Real time translate',
      name: 'real_time_translate',
      desc: '',
      args: [],
    );
  }

  /// `Use`
  String get usage {
    return Intl.message(
      'Use',
      name: 'usage',
      desc: '',
      args: [],
    );
  }

  /// `{count} trail opportunities remaining`
  String opportunitie_remaining(Object count) {
    return Intl.message(
      '$count trail opportunities remaining',
      name: 'opportunitie_remaining',
      desc: '',
      args: [count],
    );
  }

  /// `Special offers`
  String get special_offers {
    return Intl.message(
      'Special offers',
      name: 'special_offers',
      desc: '',
      args: [],
    );
  }

  /// `Remove Ads`
  String get remove_ads {
    return Intl.message(
      'Remove Ads',
      name: 'remove_ads',
      desc: '',
      args: [],
    );
  }

  /// `Faster GPT-4 models`
  String get gpt_4_models {
    return Intl.message(
      'Faster GPT-4 models',
      name: 'gpt_4_models',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited quick translation`
  String get unlimited_quick_translation {
    return Intl.message(
      'Unlimited quick translation',
      name: 'unlimited_quick_translation',
      desc: '',
      args: [],
    );
  }

  /// `Support for multilingual GPT`
  String get support_multilingual_gpt {
    return Intl.message(
      'Support for multilingual GPT',
      name: 'support_multilingual_gpt',
      desc: '',
      args: [],
    );
  }

  /// `Yearly`
  String get yearly {
    return Intl.message(
      'Yearly',
      name: 'yearly',
      desc: '',
      args: [],
    );
  }

  /// `As low as`
  String get as_low_as {
    return Intl.message(
      'As low as',
      name: 'as_low_as',
      desc: '',
      args: [],
    );
  }

  /// `daily`
  String get daily {
    return Intl.message(
      'daily',
      name: 'daily',
      desc: '',
      args: [],
    );
  }

  /// `Cancel any time`
  String get cancel_any_time {
    return Intl.message(
      'Cancel any time',
      name: 'cancel_any_time',
      desc: '',
      args: [],
    );
  }

  /// `Start free trial`
  String get start_free_trial {
    return Intl.message(
      'Start free trial',
      name: 'start_free_trial',
      desc: '',
      args: [],
    );
  }

  /// `Privacy policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `No back history item`
  String get no_back_history {
    return Intl.message(
      'No back history item',
      name: 'no_back_history',
      desc: '',
      args: [],
    );
  }

  /// `No forward history item`
  String get no_forward_history {
    return Intl.message(
      'No forward history item',
      name: 'no_forward_history',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'af'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'fa'),
      Locale.fromSubtags(languageCode: 'fil'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'ga'),
      Locale.fromSubtags(languageCode: 'ha'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'in'),
      Locale.fromSubtags(languageCode: 'iw'),
      Locale.fromSubtags(languageCode: 'la'),
      Locale.fromSubtags(languageCode: 'ms'),
      Locale.fromSubtags(languageCode: 'my'),
      Locale.fromSubtags(languageCode: 'om'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'sw'),
      Locale.fromSubtags(languageCode: 'th'),
      Locale.fromSubtags(languageCode: 'tr'),
      Locale.fromSubtags(languageCode: 'ur'),
      Locale.fromSubtags(languageCode: 'vi'),
      Locale.fromSubtags(languageCode: 'zh'),
      Locale.fromSubtags(languageCode: 'zu'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
