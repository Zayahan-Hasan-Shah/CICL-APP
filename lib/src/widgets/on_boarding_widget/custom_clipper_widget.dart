import 'package:flutter/cupertino.dart';

class CustomClipperWidget extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final width = size.width;
    final height = size.height;

    // line 1
    path.lineTo(0, height - 30);


    path.lineTo(0, height - 30); 

    // Curve from left → center
    path.quadraticBezierTo(
      40,
      height,
      width/4,
      height - 60,
    );

    // Deep dip in center
    path.quadraticBezierTo(
      width * 0.5,
      height - 180,
      width * 0.75,
      height - 60,
    );

    // Curve back up to right side
    path.quadraticBezierTo(
      width * 0.9,
      height,
      width,
      height - 70,
    );

    // Close shape
    path.lineTo(width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
