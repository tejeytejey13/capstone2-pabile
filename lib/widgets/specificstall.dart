import 'package:flutter/material.dart';

class SpecificStall extends StatefulWidget {
  const SpecificStall({super.key, required allstalls});

  @override
  State<SpecificStall> createState() => _SpecificStallState();
}

class _SpecificStallState extends State<SpecificStall> {
  @override
  Widget build(BuildContext context) {
    double reswidth = MediaQuery.of(context).size.width;
    double resheight = MediaQuery.of(context).size.height;
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: resheight / 2,
        width: reswidth,
        decoration: const BoxDecoration(
          color: Color(0xFF3876BF),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    var firstStart = Offset(size.width / 0, size.height);
    var firstEnd = Offset(size.width / 0, size.height);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width, size.height - 30);
    var secondEnd = Offset(size.width - (size.width / 300), size.height - 1);
    path.quadraticBezierTo(
        secondStart.dy, secondStart.dx, secondEnd.dy, secondEnd.dx);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
