import 'package:flutter/material.dart';
import 'package:krystl/core/extensions/context_extension.dart';

/// Created by Balaji Malathi on 11/18/2023 at 11:05 PM.

class UI {
  static const Color secondaryTextColor = Colors.grey;
  static const Color iconColor = Color(0xFFCECECE);
}

void showSnackBar(
    {required BuildContext context,
      required String content,
      Color color = Colors.green}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(
        content,
        style: context.textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
    ),
  );
}
