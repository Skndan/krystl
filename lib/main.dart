import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:freerasp/freerasp.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:krystl/core/cache/local_manager.dart';
import 'package:krystl/core/enums/enums.dart';
import 'package:krystl/product/navigation/route_constant.dart';
import 'package:provider/provider.dart';

import 'core/navigation/router_service.dart';
import 'core/notifier/provider_list.dart';
import 'core/notifier/theme_notifier.dart';
import 'core/responsive/size_config.dart';
import 'firebase_options.dart';
import 'locator.dart';
import 'product/navigation/router_generator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Analytics.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Setting up SharedPreferences
  await LocalManager.preferencesInit();

  //DI - GetIt
  setupLocator();

  //Admob
  // MobileAds.instance.initialize();

  // Firebase Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // create configuration for freeRASP
  final config = TalsecConfig(
    /// For Android
    androidConfig: AndroidConfig(
      packageName: 'com.skndan.krystl',
      signingCertHashes: ['tJPHShnVDa5hUyRFqTyvhVyGqbshOu+IcYJ3oSQB5LY='],
      supportedStores: [],
    ),

    watcherMail: '',
    isProd: !kDebugMode,
  );

  // Setting up callbacks
  final callback = ThreatCallback(
      onAppIntegrity: () => exit(0),
      onObfuscationIssues: () => exit(0),
      onDebug: () => exit(0),
      onDeviceBinding: () => exit(0),
      onDeviceID: () => exit(0),
      onHooks: () => exit(0),
      onPasscode: () => exit(0),
      onPrivilegedAccess: () => exit(0),
      onSecureHardwareNotAvailable: () => exit(0),
      onSimulator: () => exit(0),
      onUnofficialStore: () => exit(0));

  // Attaching listener
  Talsec.instance.attachListener(callback);
  await Talsec.instance.start(config);

  runApp(const MarkApp());
}

/*

MultiProvider
- All the base providers such as ThemeNotifier and Orientation providers will be added here

LayoutBuilder & OrientationBuilders
- These are responsible for screen sizes and orientations

SizeConfig
- To know screen size and orientation which was retrieved from LayoutBuilder and OrientationBuilder

*/

class MarkApp extends StatefulWidget {
  const MarkApp({Key? key}) : super(key: key);

  @override
  State<MarkApp> createState() => _MarkAppState();
}

class _MarkAppState extends State<MarkApp> {
  bool isAuthenticated = false, vehicleCreated = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [...ApplicationProvider.instance.dependItems],
        child: LayoutBuilder(builder: (context, constraint) {
          return OrientationBuilder(builder: (context, orientation) {
            SizeConfig().init(constraint, orientation);
            return MaterialApp(
              scrollBehavior: AppScrollBehavior(),
              title: "Krystl",
              localizationsDelegates: const [FormBuilderLocalizations.delegate],
              initialRoute: LocalManager.instance.getBool(Pref.isLogged)
                  ? RouterConstant.home
                  : RouterConstant.root,
              themeMode: ThemeMode.system,
              onGenerateRoute: RouterGenerator.instance.generateRoute,
              theme: Provider.of<ThemeNotifier>(context).currentTheme,
              navigatorKey: RouterService.instance.navigatorKey,
              debugShowCheckedModeBanner: kReleaseMode,
            );
          });
        }));
  }

  // LocalManager.instance.getBool(Pref.isLogged)
  // ? RouterConstant.home
  //     :
  @override
  void initState() {
    super.initState();
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

// Certificate pinning
// //TODO: Change the Url Before Release
// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           ((X509Certificate cert, String host, int port) {
//         final isValidHost =
//             ["192.168.10.4"].contains(host); // <-- allow only hosts in array
//         return isValidHost;
//       });
//   }
// }
