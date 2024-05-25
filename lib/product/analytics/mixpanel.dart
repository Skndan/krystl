// import 'package:mixpanel_flutter/mixpanel_flutter.dart';
//
// /// Created by Balaji Malathi on 1/30/2024 at 3:16 PM.
// class MixpanelService {
//   static final MixpanelService instance = MixpanelService._init();
//
//   static Mixpanel? mixpanel;
//
//   MixpanelService._init() {
//     if (mixpanel == null) {
//       init();
//     }
//   }
//
//   static init() async {
//     mixpanel = await Mixpanel.init("c4de3d861904b1b70ba231f175f72ab1",
//         trackAutomaticEvents: true);
//   }
//
//   static void flush() {
//     mixpanel?.flush();
//   }
//
//   static void track(
//       {required String key, required Map<String, dynamic> value}) {
//     mixpanel?.track(key, properties: value);
//   }
// }
