import 'package:capstone_project_pabile/component/botnavbar.dart';
import 'package:capstone_project_pabile/widgets/specificwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecificFoodReco extends StatefulWidget {
  const SpecificFoodReco(
      {super.key, required this.todayMenu, required this.onFavoriteChanged});

  final Map todayMenu;
  final Function(bool) onFavoriteChanged;

  @override
  State<SpecificFoodReco> createState() => _SpecificFoodRecoState();
}

class _SpecificFoodRecoState extends State<SpecificFoodReco> {
  bool isFavorite = false;
  bool addOnOrder = false;
  Set<String> selectedAddOnKeys = Set();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late DatabaseReference faveRef;
  DatabaseReference delRef = FirebaseDatabase.instance.ref().child('fave');
  Query dbAddOns = FirebaseDatabase.instance.ref('menuItems');

  @override
  void initState() {
    super.initState();
    checkIfFaved();
    addOnOrder = true;
  }

  void checkIfFaved() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      faveRef = FirebaseDatabase.instance.ref('fave');
      DataSnapshot snapshot = (await faveRef.once()).snapshot;

      if (snapshot.value != null) {
        Map<dynamic, dynamic> faveItems =
            snapshot.value as Map<dynamic, dynamic>;
        String itemID = widget.todayMenu['menuItems']['itemID'];

        bool alreadyFaved = faveItems.values.any((item) {
          return item['userID'] == user.uid && item['itemID'] == itemID;
        });

        setState(() {
          isFavorite = alreadyFaved;
        });
      }
    }
  }

  void removeFave() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var itemID = widget.todayMenu['menuItems']['itemID'];

      DatabaseReference ref =
          FirebaseDatabase.instance.ref('fave').child(itemID);
      await ref.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
      backgroundColor: const Color(0xFF3876BF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            Map specfood = widget.todayMenu;
            int ratesLength =
                (specfood['menuItems'] ?? {})['rates']?.length ?? 0;
            var rated = ratesLength > 0
                ? (specfood['menuItems'] ?? {})['rates']
                        .values
                        .reduce((a, b) => a + b) /
                    ratesLength
                : 0.0;

            void addToCart() async {
              User? user = _auth.currentUser;
              if (user != null) {
                try {
                  String cusID = user.uid;
                  DatabaseReference ref =
                      FirebaseDatabase.instance.ref('carts');
                  DatabaseReference orderRef = ref.push();
                  String itemID = (specfood['menuItems'] ?? {})['itemID'];
                  String stallID = (specfood['menuItems'] ?? {})['stallID'];
                  String itemPrice = (specfood['menuItems'] ?? {})['itemPrice'];

                  await orderRef.set({
                    "itemID": itemID,
                    "orderedID": orderRef.key,
                    "customerID": cusID,
                    "stallID": stallID,
                    "totalPrice": itemPrice,
                    "quantity": 1.toString(),
                  });

                  Fluttertoast.showToast(
                    msg: 'Item Added to Cart successfully!',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );

                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BotNavBar(),
                    ),
                  );
                } catch (e) {
                  // Handle error, show error toast
                  print("Error adding to cart: $e");
                  Fluttertoast.showToast(
                    msg: 'Failed to place order. Please try again.',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              }
            }

            return Stack(
              children: [
                const Positioned(
                  top: 0,
                  child: SpecificWidget(),
                ),
                Positioned(
                  top: 20,
                  right: 10,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.heart_broken_outlined,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });

                      if (!isFavorite) {
                        removeFave(); // Remove from favorites
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white),
                    onPressed: () {
                      widget.onFavoriteChanged(isFavorite);
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: 140,
                  left: 80,
                  right: 80,
                  child: Container(
                    width: width / 2,
                    height: height / 5,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (specfood['menuItems'] ?? {})['itemName'] ??
                                'Default Item Name',
                            style: const TextStyle(
                              color: Color(0xFF555555),
                              fontSize: 30,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              height: 0,
                              letterSpacing: 0.10,
                            ),
                          ),
                          Text(
                            (specfood['menuItems'] ?? {})['itemDescription'] ??
                                'Default Item Name',
                            style: const TextStyle(
                              color: Color(0xFF909090),
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w300,
                              height: 0,
                              letterSpacing: 0.10,
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 2,
                            color: Color(0xFF848484),
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
                                  color: Color(0xFF848484),
                                  fontSize: 8,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 370,
                  left: 10,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Add ons",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 15,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 400,
                  left: 10,
                  right: 0,
                  child: SizedBox(
                    height: 350,
                    width: double.maxFinite,
                    child: AddOnsQuery((specfood['menuItems'] ?? {})['itemID']),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    color: Colors.white,
                    width: width,
                    height: height / 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Price: ₱ ${(specfood['menuItems'] ?? {})['itemPrice']}',
                              style: const TextStyle(
                                color: Color(0xFF3876BF),
                                fontSize: 15,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                height: 0,
                                letterSpacing: 0.10,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         OrderFood(todayMenu: specfood),
                            //   ),
                            // );
                            addToCart();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF3876BF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            minimumSize: const Size(158, 29),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.receipt_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              Text(
                                'Add To Cart',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget AddOnsQuery(String excludedItemID) {
    return Column(
      children: [
        Expanded(
          child: FirebaseAnimatedList(
            scrollDirection: Axis.vertical,
            query: dbAddOns,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              Map addOns = snapshot.value as Map;
              addOns['key'] = snapshot.key;
              if (addOns.isNotEmpty && addOns['itemID'] != excludedItemID) {
                return AddOns(addOns, selectedAddOnKeys);
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget AddOns(Map addOns, Set<String> selectedAddOnKeys) {
    double itemWidth = MediaQuery.of(context).size.width * 0.5;
    double itemHeight = MediaQuery.of(context).size.height * 0.4;

    int ratesLength = addOns['rates'] != null ? addOns['rates'].length : 0;
    var rated = ratesLength > 0
        ? addOns['rates'].values.reduce((a, b) => a + b) / ratesLength
        : 0.0;

    void addOnToCart() async {
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          String cusID = user.uid;
          DatabaseReference ref = FirebaseDatabase.instance.ref('carts');
          DatabaseReference orderRef = ref.push();

          await orderRef.set({
            "itemID": addOns['itemID'],
            "orderedID": orderRef.key,
            "customerID": cusID,
            "stallID": addOns['stallID'],
            "totalPrice": addOns['itemPrice'],
            "quantity": 1.toString(),
            "isdelivered": false,
          });
        }
      } catch (e) {
        print("Error adding to cart: $e");
      }
    }

    void removeAddOn() async {
      User? user = _auth.currentUser;
      if (user != null) {
        var itemKey = addOns['key'];

        DatabaseReference ref =
            FirebaseDatabase.instance.ref('fave').child(itemKey);
        await ref.remove();
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: itemHeight / 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 10, 0),
              child: Container(
                width: itemWidth / 3,
                height: itemHeight / 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(
                      addOns['itemImg'],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  addOns['itemName'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: 0.10,
                  ),
                ),
                Text(
                  addOns['itemDescription'],
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 10,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 0.10,
                  ),
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
                      rated.toString(),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 8,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        height: 0,
                        letterSpacing: 0.10,
                      ),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFF848484),
                ),
              ],
            ),
            Text(
              '₱ ${addOns['itemPrice']}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 0,
                letterSpacing: 0.10,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (selectedAddOnKeys.contains(addOns['key'])) {
                    selectedAddOnKeys.remove(addOns['key']);
                  } else {
                    selectedAddOnKeys.add(addOns['key']);
                  }
                });

                if (addOnOrder) {
                  print("Button Pressed");

                  addOnToCart();
                } else {
                  removeAddOn();
                }
              },
              icon: selectedAddOnKeys.contains(addOns['key'])
                  ? const Icon(Icons.check_circle_rounded)
                  : const Icon(Icons.add_circle_rounded),
              color: selectedAddOnKeys.contains(addOns['key'])
                  ? Colors.greenAccent
                  : Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
