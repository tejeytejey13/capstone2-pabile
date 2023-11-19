import 'package:capstone_project_pabile/database/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Clip extends StatefulWidget {
  const Clip({super.key});

  @override
  State<Clip> createState() => _ClipState();
}

class _ClipState extends State<Clip> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser?.uid;

    double reswidth = MediaQuery.of(context).size.width;
    double resheight = MediaQuery.of(context).size.height;
    return ClipPath(
      clipper: TripleSmoothWaveClipper(),
      child: Container(
        height: resheight / 6,
        width: reswidth,
        decoration: const BoxDecoration(
          color: Color(0xFF3876BF),
        ),
        child: read(user),
      ),
    );
  }

  Widget buildName(Users newUser) => Padding(
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
                  newUser.name,
                  style: GoogleFonts.hammersmithOne(
                    color: Colors.white,
                    fontStyle: FontStyle.normal,
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Text(
              'Welcome back, ready to dig in ?',
              style: GoogleFonts.montserrat(
                color: Color(0xFFC1C1C1),
                fontStyle: FontStyle.normal,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                letterSpacing: .1,
              ),
            ),
          ],
        ),
      );

  Widget read(uid) {
    var collection = FirebaseFirestore.instance.collection('users');
    return Column(
      children: [
        SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: collection.doc(uid).snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error = ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final users = snapshot.data?.data();
                  if (users != null) {
                    final newUser = Users(
                      id: users['id'],
                      name: users['fullname'],
                      email: users['email'],
                      phoneNo: users['phoneNo'],
                      password: users['password'],
                      role: users['role'],
                      status: users['status'],
                    );
                    return buildName(newUser);
                  } else {
                    return const Text('User data is null');
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class TripleSmoothWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double waveHeight = 20.0; // Adjust the wave height as needed

    // First Wave
    path.lineTo(0, size.height);
    var firstStart = Offset(size.width / 5, size.height);
    var firstEnd = Offset(size.width / 3, size.height - waveHeight / 2);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    // Second Wave
    var secondStart = Offset(size.width / 3, size.height - waveHeight / 2);
    var secondEnd = Offset(size.width / 1.5, size.height);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    // Third Wave
    var thirdStart = Offset(size.width / 1.5, size.height);
    var thirdEnd = Offset(size.width, size.height - waveHeight / 2);
    path.quadraticBezierTo(
        thirdStart.dx, thirdStart.dy, thirdEnd.dx, thirdEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
