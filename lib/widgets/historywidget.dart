import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({super.key});

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  final user = FirebaseAuth.instance.currentUser?.uid;
  late var userid = user!;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('users');

  @override
  Widget build(BuildContext context) {
    double reswidth = MediaQuery.of(context).size.width;
    double resheight = MediaQuery.of(context).size.height;
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: resheight / 4,
        width: reswidth,
        decoration: const BoxDecoration(
          color: Color(0xFF3876BF),
        ),
        child: FirebaseAnimatedList(
          scrollDirection: Axis.horizontal,
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map stallname = snapshot.value as Map;
            stallname['key'] = snapshot.key;
            if (stallname['id'] == userid) {
              return buildName(stallname);
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

Widget buildName(newUser) => Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Hi",
                style: GoogleFonts.hammersmithOne(
                  color: Colors.white,
                  fontStyle: FontStyle.normal,
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                ', ',
                style: GoogleFonts.hammersmithOne(
                  color: Colors.white,
                  fontStyle: FontStyle.normal,
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                newUser['name'],
                style: GoogleFonts.hammersmithOne(
                  color: Colors.white,
                  fontStyle: FontStyle.normal,
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 150,
              ),
              // const Align(
              //   alignment: Alignment.topRight,
              //   child: Icon(
              //     Icons.search,
              //     color: Colors.white,
              //   ),
              // ),
            ],
          ),
          Text(
            'Welcome back, ready to dig in ?',
            style: GoogleFonts.montserrat(
              color: const Color(0xFFC1C1C1),
              fontStyle: FontStyle.normal,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: .1,
            ),
          ),
        ],
      ),
    );

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    var firstStart = Offset(size.width / 5, size.height);
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart =
        Offset(size.width - (size.width / 3.24), size.height - 105);
    var secondEnd = Offset(size.width, size.height - 10);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
