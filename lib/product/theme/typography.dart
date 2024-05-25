import 'package:flutter/material.dart';

class Typography  {
  static Typography? _instance;
  static Typography? get instance {
    _instance ??= Typography._init();
    return _instance;
  }

  Typography._init();

  final headline1 =
      const TextStyle(fontSize: 93, fontWeight: FontWeight.w300, letterSpacing: -1.5);
  final headline2 =
      const TextStyle(fontSize: 58, fontWeight: FontWeight.w300, letterSpacing: -0.5);
  final headline3 = const TextStyle(fontSize: 46, fontWeight: FontWeight.w400);
  final headline4 =
      const TextStyle(fontSize: 33, fontWeight: FontWeight.w400, letterSpacing: 0.25);
  final headline5 = const TextStyle(fontSize: 23, fontWeight: FontWeight.w400);
  final headline6 =
      const TextStyle(fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15);
  final overline =
      const TextStyle(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5);
}
