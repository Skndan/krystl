import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:krystl/core/cache/local_manager.dart';
import 'package:krystl/core/extensions/context_extension.dart';
import 'package:krystl/core/extensions/widget_extension.dart';
import 'package:provider/provider.dart';

import '../core/enums/app_theme.dart';
import '../core/enums/pref.dart';
import '../core/navigation/router_service.dart';
import '../core/notifier/theme_notifier.dart';
import '../product/navigation/route_constant.dart';

/// Created by Balaji Malathi on 3/12/2024 at 11:18 AM.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeNotifier>().currentThemeEnum;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
            width: context.width,
            height: context.height,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    theme == AppThemes.light
                        ? "assets/svg/krystl_lite.svg"
                        : "assets/svg/krystl_dark.svg",
                    height: 160,
                  ).pt(56),
                  SvgPicture.asset(
                    "assets/svg/union.svg",
                    height: 200,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [ 
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final GoogleSignInAccount? googleUser =
                            await GoogleSignIn().signIn();
        
                            final GoogleSignInAuthentication? googleAuth =
                            await googleUser?.authentication;
        
                            final credential = GoogleAuthProvider.credential(
                              accessToken: googleAuth?.accessToken,
                              idToken: googleAuth?.idToken,
                            );
        
                            await FirebaseAuth.instance
                                .signInWithCredential(credential);


                            LocalManager.instance
                                .setString(Pref.profile, googleUser?.photoUrl ?? '');

                            LocalManager.instance
                                .setString(Pref.displayName, googleUser?.displayName ?? '');

                            LocalManager.instance.setBool(Pref.isLogged, true);
                            LocalManager.instance.setString(Pref.uid, FirebaseAuth.instance.currentUser?.uid ?? '');

                            setState(() {
                              isLoading = false;
                            });
        
                            RouterService.instance
                                .pushAndClear(RouterConstant.home);
        
                          } on Exception catch (e) {
                            debugPrint('exception->$e');
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 56.0),
                          decoration: BoxDecoration(
                            color: context.colors.primaryContainer,
                            borderRadius: BorderRadius.circular(10.0),
                            // border: Border.all(width: 2, color: primaryDark)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isLoading
                                  ? SizedBox(
                                height: 24.0,
                                width: 24.0,
                                child: Center(
                                    child: CircularProgressIndicator(
                                      color: context.colors.surface,
                                      strokeWidth: 2,
                                    )),
                              ).pr(16)
                                  : SvgPicture.asset(
                                "assets/svg/google.svg",
                                height: 24,
                                width: 24,
                                matchTextDirection: true,
                              ).pr(16),
                              Text(
                                "Sign in with Google",
                                style: context.textTheme.bodyLarge
                                    ?.copyWith(color: context.colors.surface, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "By registering you accept the privacy policy and the terms of conditions",
                        style: context.textTheme.labelLarge,
                        textAlign: TextAlign.center,
                      ).pb(8),
                    ],
                  ).pt(56)
                ],
              ),
            )),
      ),
    );
  }
}
