import 'package:capstone_project_pabile/database/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StallWidget extends StatefulWidget {
  const StallWidget({super.key});

  @override
  State<StallWidget> createState() => _StallWidgetState();
}

class _StallWidgetState extends State<StallWidget> {
  final user = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    double reswidth = MediaQuery.of(context).size.width;
    double resheight = MediaQuery.of(context).size.height;
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: resheight / 2.5,
        width: reswidth,
        decoration: const BoxDecoration(
          color: Color(0xFF3876BF),
        ),
        child: read(user),
      ),
    );
  }
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
              const SizedBox(
                width: 150,
              ),
              const Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
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

Widget read(uid) {
  var collection = FirebaseFirestore.instance.collection('users');
  return Column(
    children: [
      SingleChildScrollView(
        child: SizedBox(
          // width: MediaQuery.of(context).size.width,
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
