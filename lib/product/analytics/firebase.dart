import 'package:firebase_analytics/firebase_analytics.dart';

/// Created by Balaji Malathi on 3/6/2024 at 8:17 PM.
class FBAnalytics {
  static init() async {
    await FirebaseAnalytics.instance
        .setDefaultEventParameters({'version': '0.0.1+1'});
    await FirebaseAnalytics.instance.logAppOpen();
  }

  static logEvent({required String name, required dynamic parameters}) async {
    await FirebaseAnalytics.instance
        .logEvent(name: name, parameters: parameters);
  }
}
