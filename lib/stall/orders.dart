import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('users');
  DatabaseReference dbPlace = FirebaseDatabase.instance.ref().child('place');
  DatabaseReference dbMenu = FirebaseDatabase.instance.ref().child('menuItems');

  final user = FirebaseAuth.instance.currentUser?.uid;
  late var userid = user!;

  // int visibleOrderIndex = 0;

  @override
  Widget build(BuildContext context) {
    Future<List<Map<String, dynamic>>> fetchData() async {
      DataSnapshot cartsSnapshot = (await dbPlace.once()).snapshot;
      DataSnapshot menuItemsSnapshot =
          (await dbMenu.orderByChild('orderedDate').once()).snapshot;

      Map<dynamic, dynamic>? cartsMap =
          cartsSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? menuItemsMap =
          menuItemsSnapshot.value as Map<dynamic, dynamic>?;

      if (cartsMap == null || menuItemsMap == null) {
        return [];
      }

      List<Map<String, dynamic>> combinedData = [];

      cartsMap.forEach((cartKey, cartItem) {
        var matchingMenuItem = menuItemsMap[cartItem['itemID']];
        if (matchingMenuItem != null) {
          Map<String, dynamic> combinedItem = {
            'place': Map<String, dynamic>.from(cartItem),
            'menuItems': Map<String, dynamic>.from(matchingMenuItem),
          };
          combinedData.add(combinedItem);
        }
      });

      return combinedData;
    }

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
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Map<String, dynamic>>? combinedData = snapshot.data;

                    if (combinedData != null && combinedData.isNotEmpty) {
                      combinedData.sort((a, b) {
                        DateTime aDate =
                            DateTime.parse(a['place']['orderedDate']);
                        DateTime bDate =
                            DateTime.parse(b['place']['orderedDate']);
                        return aDate.compareTo(bDate);
                      });

                      return FirebaseAnimatedList(
                        query: dbPlace,
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index) {
                          Map? cartData = snapshot.value as Map?;
                          cartData ??= {};
                          cartData['key'] = snapshot.key;
                          if (cartData['stallID'] == userid &&
                              cartData['isdelivered'] == false) {
                            Map? menustItem = combinedData.firstWhereOrNull(
                                (item) =>
                                    item['place']['itemID'] ==
                                    (cartData?['itemID']));
                            return menustItem != null
                                ? takeOrders(cartData, menustItem, index)
                                : Container();
                          } else {
                            return Container();
                          }
                        },
                      );
                    } else {
                      return Container(); // Handle empty state
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget takeOrders(Map place, Map menusItem, int index) {
  int visibleOrderIndex = 0;
  int ratesLength = (menusItem['menuItems'] ?? {})['rates'] != null
      ? (menusItem['menuItems'] ?? {})['rates'].length
      : 0;
  var rated =
      (menusItem['menuItems'] ?? {})['rates'].values.reduce((a, b) => a + b) /
          ratesLength;

  print('takeOrders: $place, $menusItem');
  if (menusItem['menuItems'] != null) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 40),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(
                  (menusItem['menuItems'] ?? {})['itemImg'] ?? '',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (menusItem['menuItems'] ?? {})['itemName'] ?? '',
                  style: const TextStyle(
                    color: Color(0xFF2E2E2E),
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: 0.10,
                  ),
                ),
                Text(
                  'Ordered by ${place['customerID']}',
                  style: const TextStyle(
                    color: Color(0xFF848484),
                    fontSize: 8,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w300,
                    height: 0,
                    letterSpacing: 0.10,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amberAccent,
                    ),
                    Text(
                      rated.toString(),
                      style: const TextStyle(
                        color: Color(0xFF2E2E2E),
                        fontSize: 8,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        height: 0,
                        letterSpacing: 0.10,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Text(
                '₱ ${place['totalPrice']}',
                style: const TextStyle(
                  color: Color(0xFF848484),
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  height: 0,
                  letterSpacing: 0.10,
                ),
              ),
              GestureDetector(
                onTap: () {
                  visibleOrderIndex = index;
                  void readyToPickUp() async {
                    if (index == visibleOrderIndex) {
                      DatabaseReference ref =
                          FirebaseDatabase.instance.ref('readytopickup');
                      DatabaseReference pickUp = ref.push();
                      await pickUp.set({
                        "pickupID": pickUp.key,
                        "orderedID": place['orderedID'],
                        "isdelivered": false,
                        "takeOrder": false,
                        "customerID": place['customerID'],
                        
                      });
                    }
                  }

                  readyToPickUp();
                },
                child: Container(
                  width: 80,
                  height: 30,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF3876BF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Ready to Pick Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        height: 0,
                        letterSpacing: 0.10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  } else {
    print('takeOrders: Returning an empty container');
    return Container();
  }
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
          'Welcome back, ready serve your food?',
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
