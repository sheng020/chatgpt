
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_flurry_sdk/flurry.dart';

void reportEvent(String eventId) {
  if (kDebugMode) {
    print("reportEvent:${eventId}");
  }
  Flurry.logEvent(eventId);
  FirebaseAnalytics.instance.logEvent(name: eventId);
}

void reportEventWithParameters(String eventId, Map<String, String> parameters) {
  if (kDebugMode) {
    print("reportEvent:${eventId} ${parameters}");
  }
  Flurry.logEventWithParameters(eventId, parameters);
  FirebaseAnalytics.instance.logEvent(name: eventId, parameters: parameters);
}