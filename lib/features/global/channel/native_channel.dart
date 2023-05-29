import 'package:flutter/services.dart';

class NativeChannel {
  static const CHANNEL_NAME = "com.atom.chatgpt.channel";

  static const _channel = MethodChannel(CHANNEL_NAME);

  static Future<bool> isPurchased() {
    return _channel.invokeMethod("is_purchased").then((value) {
      if (value == null) {
        return false;
      } else {
        return value;
      }
    });
  }

  static Future<bool> openSubscriptionPage() {
    return _channel.invokeMethod("open_subscription_page").then((value) {
      return value ?? true;
    });
  }

  static Future<void> loadRewardAd() {
    return _channel.invokeMethod("load_reward_ad");
  }

  static Future<bool?> showRewardAd() {
    return _channel.invokeMethod("show_reward_ad");
  }
}
