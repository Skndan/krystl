import 'dart:convert';

import 'package:flutter/material.dart';

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

extension Json on dynamic {
  String get toJson {
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(this);
    return prettyprint;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String get toPercentage => "$this%";

  String get toAmount => "₹$this";

  bool equals(String nn) {
    return (nn == this);
  }

  String get toInitials {
    List<String> words = this.split(' ');

    if (words.length == 1) {
      // If there's only one word, return its initial
      return words[0][0].toUpperCase();
    } else if (words.length == 2) {
      // If there are two words, return the initials of both
      return words.map((word) => word[0].toUpperCase()).join();
    } else if (words.length >= 3) {
      // If there are three or more words, return the initials of the first and last words
      return words[0][0].toUpperCase() +
          words[words.length - 1][0].toUpperCase();
    } else {
      return 'XX'; // Handle cases with no name or invalid input
    }
  }
}

extension ColourExtension on String {
  Color get toColor {
    var hexColor = this;
    hexColor = hexColor.replaceAll("#", "");

    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
      return Color(int.parse("0x$hexColor"));
    }

    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }

    return const Color(0xFFFFFFFF);
  }
}
