import 'package:flutter/services.dart';
import 'package:flutter_chatgpt_clone/api/instance/chat/chat_models.dart';
import 'package:flutter_chatgpt_clone/api/instance/openai.dart';
import 'package:flutter_chatgpt_clone/http/http_client.dart';

class NativeChannel {
  static const CHANNEL_NAME = "com.atom.chatgpt.channel";

  static const _channel = MethodChannel(CHANNEL_NAME);

  static Future<bool> isPurchased() {
    return _channel.invokeMethod("is_purchased").then((value) {
      if (value == null) {
        return false;
      } else {
        setEnv(value);
        return value;
      }
    });
  }

  static void setEnv(bool isPurchase) {
    if (isPurchase) {
      OpenAI.chatModel = ChatModel.GPT_4;
      HttpClient.APP_KEY = APP_KEY_VIP;
      HttpClient.PACKAGE_NAME = PACKAGE_NAME_VIP;
      HttpClient.serverApiKey = serverApiKeyVip;
      HttpClient.serverSecret = serverSecretVip;
    } else {
      OpenAI.chatModel = ChatModel.GPT_3_5_TURBO;
      HttpClient.APP_KEY = APP_KEY_NORMAL;
      HttpClient.PACKAGE_NAME = PACKAGE_NAME_NORMAL;
      HttpClient.serverApiKey = serverApiKeyNormal;
      HttpClient.serverSecret = serverSecretNormal;
    }
  }

  static Future<bool> openSubscriptionPage() {
    return _channel.invokeMethod("open_subscription_page").then((value) {
      bool isPurchase = value ?? true;
      setEnv(isPurchase);
      return isPurchase;
    });
  }

  static Future<void> loadRewardAd() {
    return _channel.invokeMethod("load_reward_ad");
  }

  static Future<bool?> showRewardAd() {
    return _channel.invokeMethod("show_reward_ad");
  }

  static Future<YearlyPrice?> getYearlyPrice() {
    return _channel.invokeMethod("get_yearly_price").then((value) {
      if (value == null) {
        return null;
      } else {
        String currency = value['priceCurrencyCode'];
        int amount = value['priceAmountMicros'];
        return YearlyPrice(currency: currency, amount: amount);
      }
    });
  }

  static Future<void> navigateAppStore() {
    return _channel.invokeMethod("navigate_app_store");
  }
}

class YearlyPrice {
  final String currency;
  final int amount;

  YearlyPrice({required this.currency, required this.amount});
}
