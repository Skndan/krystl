import 'package:flutter/material.dart';
import 'package:krystl/core/extensions/context_extension.dart';

/// Created by Balaji Malathi on 11/1/2023 at 4:00 PM.

class EmptyStateWidget extends StatelessWidget {
  final String asset;
  final String message;
  final int ratio;
  final Widget? action;

  const EmptyStateWidget(
      {Key? key,
        required this.asset,
        required this.message,
        this.ratio = 2,
        this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(asset, width: context.width / ratio),
          Text(message),
          action == null ? const SizedBox.shrink() : action!
        ],
      ),
    );
  }
}
