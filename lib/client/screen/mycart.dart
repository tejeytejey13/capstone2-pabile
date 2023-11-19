import 'package:capstone_project_pabile/client/screen/billing.dart';
import 'package:capstone_project_pabile/widgets/cartwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';

class myCart extends StatefulWidget {
  const myCart({super.key});

  @override
  State<myCart> createState() => _myCartState();
}

class _myCartState extends State<myCart> {
  DatabaseReference userstall = FirebaseDatabase.instance.ref().child('users');
  DatabaseReference dbMenu = FirebaseDatabase.instance.ref().child('menuItems');
  DatabaseReference dbCart = FirebaseDatabase.instance.ref().child('carts');

  final user = FirebaseAuth.instance.currentUser?.uid;

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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const cartWidget(),
                const SizedBox(height: 20),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                SizedBox(
                  height: height / 2,
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<Map<String, dynamic>>? combinedData =
                            snapshot.data;

                        return combinedData != null && combinedData.isNotEmpty
                            ? FirebaseAnimatedList(
                                scrollDirection: Axis.vertical,
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
                                        combinedData.firstWhereOrNull((item) =>
                                            item['carts']['itemID'] ==
                                            cartData?['itemID']);

                                    // ignore: avoid_print
                                    print("Data: $correspondingMenuItem");
                                    return correspondingMenuItem != null
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: cartlists(
                                              cartData,
                                              correspondingMenuItem,
                                              (mycart) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Billing(
                                                      cart: mycart,
                                                      menuItems:
                                                          correspondingMenuItem,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
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
              ],
            );
          },
        ),
      ),
    );
  }

  //mao ni ang tung list
  Widget cartlists(Map mycart, Map correspondingMenuItem, Function callback) {
    int ratesLength =
        (correspondingMenuItem['menuItems'] ?? {})['rates'] != null
            ? (correspondingMenuItem['menuItems'] ?? {})['rates'].length
            : 0;
    var rated = (correspondingMenuItem['menuItems'] ?? {})['rates']
            .values
            .reduce((a, b) => a + b) /
        ratesLength;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 57,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(
                    (correspondingMenuItem['menuItems'] ?? {})['itemImg'] ?? '',
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
                    (correspondingMenuItem['menuItems'] ?? {})['itemName'],
                    style: TextStyle(
                      color: Color(0xFF2E2E2E),
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: 0.10,
                    ),
                  ),
                  Text(
                    (correspondingMenuItem['menuItems'] ??
                        {})['itemDescription'],
                    style: TextStyle(
                      color: Color(0xFF848484),
                      fontSize: 10,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w300,
                      height: 0,
                      letterSpacing: 0.10,
                    ),
                  ),
                  Row(
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
                    ],
                  ),
                  SizedBox(
                    width: 50,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '₱ ${mycart['totalPrice']}',
                  style: TextStyle(
                    color: Color(0xFF2E2E2E),
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: 0.10,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        // if (quantity > 1) {
                        //   setState(() {
                        //     quantity--;
                        //     totalPrice = ((mycorMenu['menuItems'] ??
                        //                 const {})['itemPrice'] ??
                        //             0) *
                        //         quantity;
                        //     print('Quantity: $quantity');
                        //     print('Total Price: $totalPrice');
                        //   });
                        // }
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.minus,
                        size: 10,
                      ),
                      color: Color(0xFF848484),
                    ),
                    Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        color: Color(0xFF3876BF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          mycart['quantity'].toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: 0.10,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // setState(() {
                        //   quantity++;
                        //   totalPrice = ((mycorMenu['menuItems'] ??
                        //               const {})['itemPrice'] ??
                        //           0) *
                        //       quantity;
                        //   print('Quantity: $quantity');
                        //   print('Total Price: $totalPrice');
                        // });
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.add,
                        size: 10,
                      ),
                      color: Color(0xFF848484),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    callback(mycart);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF3876BF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    minimumSize: const Size(158, 29),
                  ),
                  child: const Text(
                    'Proceed To Payment',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(55, 0, 55, 0),
          child: Divider(
            height: 4,
            thickness: 2,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
