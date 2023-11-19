import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser?.uid;
  late var userid = user!;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('users');
  DatabaseReference dbItem = FirebaseDatabase.instance.ref().child('menuItems');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 1,
              right: 0,
              left: 0,
              child: SizedBox(
                height: 200,
                child: FirebaseAnimatedList(
                  query: dbRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map user = snapshot.value as Map;
                    user['key'] = snapshot.key;
                    if (user['id'] == userid) {
                      return wave(user, context);
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ),
            Positioned(
              top: 220,
              left: 50,
              right: 0,
              child: Text(
                'My Featured Food',
                style: TextStyle(
                  color: Color(0xFF3876BF),
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: 0.10,
                ),
              ),
            ),
            Positioned(
              top: 240,
              right: 0,
              left: 30,
              child: SizedBox(
                width: double.maxFinite,
                height: 200,
                child: FirebaseAnimatedList(
                  scrollDirection: Axis.horizontal,
                  query: dbItem,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map item = snapshot.value as Map;
                    item['key'] = snapshot.key;
                    if (item['stallID'] == userid) {
                      return products(item);
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget products(item) {
  int ratesLength = item['rates'] != null ? item['rates'].length : 0;
  var rated = item['rates'].values.reduce((a, b) => a + b) / ratesLength;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: 207,
      height: 124,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(
            item['itemImg'] ?? '',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 120, 30, 10),
        child: Container(
          width: 177,
          height: 51,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item['itemName'] ?? '',
                style: TextStyle(
                  color: Color(0xFF2E2E2E),
                  fontSize: 15,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: 0.10,
                ),
              ),
              Text(
                item['itemDescription'] ?? '',
                style: TextStyle(
                  color: Color(0xFF848484),
                  fontSize: 10,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: 0.10,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Divider(
                  height: 2,
                  thickness: 2,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amberAccent,
                    size: 8,
                  ),
                  Text(
                    rated.toString(),
                    style: TextStyle(
                      color: Color(0xFF848484),
                      fontSize: 8,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: 0.10,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '₱ ${item['itemPrice']}',
                    style: TextStyle(
                      color: Color(0xFF848484),
                      fontSize: 8,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: 0.10,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget wave(
  user,
  BuildContext context,
) {
  double reswidth = MediaQuery.of(context).size.width;
  double resheight = MediaQuery.of(context).size.height;
  return ClipPath(
    clipper: WaveClipper(),
    child: Container(
      height: resheight / 4,
      width: reswidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(
            user['stallbanner'] ?? 'No Banner Attach, Update Your Banner',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, ${user['name']}',
              style: TextStyle(
                color: Color(0xFF3876BF),
                fontSize: 24,
                fontFamily: 'Hammersmith One',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            Text(
              'Welcome back, ready serve your food?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF3876BF),
                fontSize: 10,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 0,
                letterSpacing: 0.10,
              ),
            )
          ],
        ),
      ),
    ),
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
