import 'package:capstone_project_pabile/client/screen/billing.dart';
import 'package:capstone_project_pabile/client/screen/mycart.dart';
import 'package:capstone_project_pabile/widgets/historywidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool isRatingBarVisible = true;

  DatabaseReference userstall = FirebaseDatabase.instance.ref().child('users');
  DatabaseReference dbMenu = FirebaseDatabase.instance.ref().child('menuItems');
  DatabaseReference dbCart = FirebaseDatabase.instance.ref().child('carts');
  DatabaseReference dbPlace = FirebaseDatabase.instance.ref().child('place');

  final user = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    Future<List<Map<String, dynamic>>> fetchData() async {
      DataSnapshot cartsSnapshot = (await dbCart.once()).snapshot;
      DataSnapshot menuItemsSnapshot = (await dbMenu.once()).snapshot;

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
            'carts': Map<String, dynamic>.from(cartItem),
            'menuItems': Map<String, dynamic>.from(matchingMenuItem),
          };
          combinedData.add(combinedItem);
          print('Debugs: ${matchingMenuItem}');
        }
      });

      return combinedData;
    }

    Future<List<Map<String, dynamic>>> fetchData1() async {
      DataSnapshot placeSnapshot = (await dbPlace.once()).snapshot;
      DataSnapshot menuItemsSnapshot = (await dbMenu.once()).snapshot;

      Map<dynamic, dynamic>? placeMap =
          placeSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? menuItemsMap =
          menuItemsSnapshot.value as Map<dynamic, dynamic>?;

      if (placeMap == null || menuItemsMap == null) {
        return [];
      }

      List<Map<String, dynamic>> combinedData = [];

      placeMap.forEach((placeKey, placeItem) {
        var matchingMenuItem = menuItemsMap[placeItem?['itemID']];
        if (matchingMenuItem != null) {
          Map<String, dynamic> combinedItem = {
            'place': Map<String, dynamic>.from(placeItem),
            'menuItems': Map<String, dynamic>.from(matchingMenuItem),
          };
          combinedData.add(combinedItem);
          print('Debugs: ${combinedItem}');
        }
      });

      return combinedData;
    }

    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const HistoryWidget(),
                const SizedBox(height: 20),
                SizedBox(
                  height: height / 1.8,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "My Cart",
                              style: GoogleFonts.montserrat(
                                color: const Color(0xFF3876BF),
                                fontSize: 15,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.1,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => myCart()));
                              },
                              child: Text(
                                "See All",
                                style: GoogleFonts.montserrat(
                                  color: const Color(0xFF858585),
                                  fontSize: 15,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 280,
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: fetchData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              List<Map<String, dynamic>>? combinedData =
                                  snapshot.data;

                              return combinedData != null &&
                                      combinedData.isNotEmpty
                                  ? FirebaseAnimatedList(
                                      scrollDirection: Axis.horizontal,
                                      query: dbCart,
                                      itemBuilder: (BuildContext context,
                                          DataSnapshot snapshot,
                                          Animation<double> animation,
                                          int index) {
                                        Map? cartData = snapshot.value as Map?;
                                        cartData ??= {};
                                        cartData['key'] = snapshot.key;
                                        if (cartData['customerID'] == user) {
                                          Map? correspondingMenuItem =
                                              combinedData.firstWhereOrNull(
                                                  (item) =>
                                                      item['carts']['itemID'] ==
                                                      cartData?['itemID']);

                                          // ignore: avoid_print
                                          print("Data: $correspondingMenuItem");
                                          return correspondingMenuItem != null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: cart(cartData,
                                                      correspondingMenuItem),
                                                )
                                              : Container();
                                        } else {
                                          return Container();
                                        }
                                      },
                                    )
                                  : Container(); // Handle empty state
                            }
                          },
                        ),
                      ),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Previous Orders',
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
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          height: 280,
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: fetchData1(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                List<Map<String, dynamic>>? combinedData =
                                    snapshot.data;

                                return combinedData != null &&
                                        combinedData.isNotEmpty
                                    ? FirebaseAnimatedList(
                                        scrollDirection: Axis.vertical,
                                        query: dbPlace,
                                        itemBuilder: (BuildContext context,
                                            DataSnapshot snapshot,
                                            Animation<double> animation,
                                            int index) {
                                          Map? placeData =
                                              snapshot.value as Map?;
                                          placeData ??= {};
                                          placeData['key'] = snapshot.key;
                                          if (placeData['customerID'] == user &&
                                              placeData['isdelivered'] ==
                                                  true) {
                                            Map? correspondingMenuItem =
                                                combinedData.firstWhereOrNull(
                                                    (item) =>
                                                        item['place']
                                                            ['itemID'] ==
                                                        placeData?['itemID']);

                                            return correspondingMenuItem != null
                                                ? place(placeData,
                                                    correspondingMenuItem)
                                                : const SizedBox();
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      )
                                    : const SizedBox(); // Handle empty state
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget cart(Map mycart, Map correspondingMenuItem) {
    double itemWidth = MediaQuery.of(context).size.width * 0.8;
    double itemHeight = MediaQuery.of(context).size.height * 0.24;
    // ignore: unused_local_variable
    int ratesLength = mycart['rates'] != null ? mycart['rates'].length : 0;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => Billing(
            //       cart: mycart,
            //       menuItems: correspondingMenuItem,
            //     ),
            //   ),
            // );
          },
          child: Container(
            width: itemWidth,
            height: itemHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(
                  (correspondingMenuItem['menuItems'] ?? {})['itemImg'] ?? '',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 5),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white.withOpacity(.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (correspondingMenuItem['menuItems'] ??
                                {})['itemName'] ??
                            'No item name',
                        style: const TextStyle(
                          color: Color(0xFF2E2E2E),
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: 0.10,
                        ),
                      ),
                      Text(
                        (correspondingMenuItem['menuItems'] ??
                                {})['itemDescription'] ??
                            '',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 234, 232, 232),
                          fontSize: 10,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          height: 0,
                          letterSpacing: 0.10,
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFF848484),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amberAccent,
                            size: 10,
                          ),
                          Text(
                            ((correspondingMenuItem['menuItems'] ??
                                        {})['rates'] !=
                                    null
                                ? (correspondingMenuItem['menuItems'] ??
                                        {})['rates']!
                                    .values
                                    .reduce((a, b) => a + b)
                                    .toString()
                                : '0.0'),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 234, 232, 232),
                              fontSize: 8,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: 0.10,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '₱ ${mycart['totalPrice'] ?? 0.0}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 234, 232, 232),
                              fontSize: 8,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: 0.10,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Quantity: ${mycart['quantity'] ?? 0.0}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 234, 232, 232),
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
          ),
        ),
      ],
    );
  }

  Widget place(Map mycart, Map correspondingMenuItem) {
    double itemWidth = MediaQuery.of(context).size.width * 0.8;
    double itemHeight = MediaQuery.of(context).size.height * 0.24;
    // ignore: unused_local_variable
    int ratesLength = mycart['rates'] != null ? mycart['rates'].length : 0;
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            width: itemWidth,
            height: itemHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(
                  (correspondingMenuItem['menuItems'] ?? {})['itemImg'] ?? '',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 5),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white.withOpacity(.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (correspondingMenuItem['menuItems'] ??
                                {})['itemName'] ??
                            'No item name',
                        style: const TextStyle(
                          color: Color(0xFF2E2E2E),
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: 0.10,
                        ),
                      ),
                      Text(
                        (correspondingMenuItem['menuItems'] ??
                                {})['itemDescription'] ??
                            '',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 234, 232, 232),
                          fontSize: 10,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          height: 0,
                          letterSpacing: 0.10,
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFF848484),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amberAccent,
                            size: 10,
                          ),
                          Text(
                            ((correspondingMenuItem['menuItems'] ??
                                        {})['rates'] !=
                                    null
                                ? (correspondingMenuItem['menuItems'] ??
                                        {})['rates']!
                                    .values
                                    .reduce((a, b) => a + b)
                                    .toString()
                                : '0.0'),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 234, 232, 232),
                              fontSize: 8,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: 0.10,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '₱ ${mycart['totalPrice'] ?? 0.0}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 234, 232, 232),
                              fontSize: 8,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: 0.10,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Quantity: ${mycart['quantity'] ?? 0.0}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 234, 232, 232),
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
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        isRatingBarVisible
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tap Rates',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 109, 106, 106),
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: 0.10,
                    ),
                  ),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amberAccent,
                    ),
                    onRatingUpdate: (rating) async {
                      DatabaseReference ref = FirebaseDatabase.instance
                          .ref('menuItems/${mycart['itemID']}/rates');

                      await ref.update({'$user': rating});
                      await Future.delayed(Duration(seconds: 3));

                      setState(() {
                        isRatingBarVisible = false;
                      });
                    },
                  ),
                ],
              )
            : SizedBox(),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
          child: Divider(
            height: 2.5,
            thickness: 1,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
