import 'package:flutter/material.dart';

/// Created by Balaji Malathi on 3/7/2024 at 5:03 AM.
/// Created by Balaji Malathi on 10/15/2023 at 6:12 PM.
class Avatar extends StatelessWidget {
  final double height, width;
  final String image;

  const Avatar(
      {super.key,
        this.height = 40,
        this.width = 40,
        required this.image});

  @override
  Widget build(BuildContext context) {

    return ClipRRect(
      borderRadius: BorderRadius.circular(56),
      child: FadeInImage(
        image: NetworkImage(image),
        imageErrorBuilder: (BuildContext context, Object exception,
            StackTrace? stackTrace) {
          return Image.asset('assets/image/user-lite.png');
        },
        placeholder: const AssetImage("assets/image/user-lite.png"),
        height: height,
        width: width,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
