import 'package:flutter/material.dart';

/// Created by Balaji Malathi on 1/25/2025 at 19:29.
class BottomProvider extends ChangeNotifier{
  //Index of the BottomBar
  int index = 0;

  void toggle(int index) {
    this.index = index;
    notifyListeners();
  }

}
