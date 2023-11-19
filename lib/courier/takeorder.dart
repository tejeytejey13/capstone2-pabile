import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class TakeOrder extends StatefulWidget {
  const TakeOrder({Key? key}) : super(key: key);

  @override
  State<TakeOrder> createState() => _TakeOrderState();
}

class _TakeOrderState extends State<TakeOrder> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('users');
  DatabaseReference dbTake =
      FirebaseDatabase.instance.ref().child('readytopickup');

  final user = FirebaseAuth.instance.currentUser?.uid;
  late var userid = user!;

  // int visibleOrderIndex = 0;

  @override
  Widget build(BuildContext context) {
    double reswidth = MediaQuery.of(context).size.width;
    double resheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),
      body: SafeArea(
        child: Column(
          children: [
            ClipPath(
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
                      return stallName(stallname);
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Orders',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF3876BF),
                fontSize: 20,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w800,
                height: 0,
                letterSpacing: 0.10,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: FirebaseAnimatedList(
                  query: dbTake,
                  itemBuilder: (
                    BuildContext context,
                    DataSnapshot snapshot,
                    Animation<double> animation,
                    int index,
                  ) {
                    Map takeOrder = snapshot.value as Map;
                    takeOrder['key'] = snapshot.key;
                    if (takeOrder.isNotEmpty &&
                        takeOrder['isdelivered'] == false) {
                      return takeOrders(takeOrder);
                    } else {
                      return SizedBox();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}

Widget takeOrders(Map take) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Text(
        take['pickupID'],
      ),
      Text(
        take['orderedID'],
      ),
      GestureDetector(
        onTap: () {
          if (take['takeOrder'] == false) {
            void updateTakeOrder() async {
              DatabaseReference ref = FirebaseDatabase.instance
                  .ref('readytopickup/${take['pickupID']}');
              DatabaseReference placeRef =
                  FirebaseDatabase.instance.ref('place/${take['orderedID']}');

              await ref.update({'takeOrder': true});
            }

            updateTakeOrder();
          } else if (take['takeOrder'] == true) {
            void updatePlaceOrder() async {
              DatabaseReference ref1 = FirebaseDatabase.instance
                  .ref('readytopickup/${take['pickupID']}');
              DatabaseReference placeRef =
                  FirebaseDatabase.instance.ref('place/${take['orderedID']}');

              await ref1.update({
                'takeOrder': true,
                'isdelivered': true,
              });

              await placeRef.update({
                'isdelivered': true,
              });
            }

            updatePlaceOrder();
          }
        },
        child: Container(
          height: 30,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Center(
            child: Text(
              take['takeOrder'] == false ? 'Take Order' : 'Delivered',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),
      )
    ],
  );
}

Widget stallName(stallname) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(28, 30, 0, 5),
        child: Text(
          'Hi, ${stallname['name']}'.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontFamily: 'Hammersmith One',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
        child: Text(
          'Welcome back, ready to deliver the food?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFC1C1C1),
            fontSize: 20,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            height: 0,
            letterSpacing: 0.10,
          ),
        ),
      )
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
