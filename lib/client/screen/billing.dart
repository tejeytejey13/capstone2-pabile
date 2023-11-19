import 'package:capstone_project_pabile/client/screen/waitingpage.dart';
import 'package:capstone_project_pabile/widgets/historywidget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Billing extends StatefulWidget {
  const Billing({Key? key, required this.cart, required this.menuItems})
      : super(key: key);

  final Map cart;
  final Map menuItems;
  @override
  State<Billing> createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  late TextEditingController locCtrl = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   locCtrl = TextEditingController();
  // }

  @override
  void dispose() {
    super.dispose();
    locCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map cartFood = widget.cart;
    // ignore: unused_local_variable
    Map menuFood = widget.cart;
    int? deliveryfee = 5;

    void placeOrder() async {
      DateTime currentTime = DateTime.now();
      DatabaseReference ref = FirebaseDatabase.instance.ref('place');
      String orderedID = cartFood['orderedID'];
      String totalPrice = cartFood['totalPrice'];

      try {
        await ref.child(orderedID).set({
          "itemID": cartFood['itemID'],
          "orderedID": orderedID,
          "customerID": cartFood['customerID'],
          "stallID": cartFood['stallID'],
          "orderedDate": currentTime.toUtc().toString(),
          "totalPrice": totalPrice.toString() + deliveryfee.toString(),
          "quantity": cartFood['quantity'],
          "location": locCtrl.text,
          "isdelivered": false,
        });

        Fluttertoast.showToast(
          msg: "Order placed successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WaitingPage()),
        );
      } catch (error) {
        Fluttertoast.showToast(
          msg: "Error placing order: $error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Delivery Fee:',
                        style: TextStyle(
                          color: Color(0xFF2E2E2E),
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: 0.10,
                        ),
                      ),
                      Text(
                        '₱ $deliveryfee',
                        style: const TextStyle(
                          color: Color(0xFF2E2E2E),
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: 0.10,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Order Total: ',
                        style: TextStyle(
                          color: Color(0xFF2E2E2E),
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: 0.10,
                        ),
                      ),
                      Text(
                        '₱ ${cartFood['totalPrice'] + deliveryfee.toInt().toString()}',
                        style: const TextStyle(
                          color: Color(0xFF2E2E2E),
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: 0.10,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Deliver To:',
                            style: TextStyle(
                              color: Color(0xFF2E2E2E),
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              height: 0,
                              letterSpacing: 0.10,
                            ),
                          ),
                          Text(
                            'change',
                            style: TextStyle(
                              color: Color(0xFF2E2E2E),
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              height: 0,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                        child: TextFormField(
                          controller: locCtrl,
                          cursorHeight: 0,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFCFCFCF),
                            // prefixIcon: Padding(
                            //   padding: const EdgeInsets.all(5.0),
                            //   child: FaIcon(
                            //     FontAwesomeIcons.basketShopping,
                            //     color: Colors.blue.shade900,
                            //     size: 20,
                            //   ),
                            // ),
                            labelText: 'Room Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
                  child: Divider(
                    height: 4,
                    thickness: 1,
                    color: Color(0xFFC1C1C1),
                  ),
                ),
                const Text(
                  'Billing Method',
                  style: TextStyle(
                    color: Color(0xFF2E2E2E),
                    fontSize: 22,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 0,
                    letterSpacing: 0.10,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 314,
                  height: 42.17,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD4D4D4),
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0x1A868686)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.ccVisa),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Credit Card',
                          style: TextStyle(
                            color: Color(0xFF868686),
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            height: 0,
                            letterSpacing: -0.28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 314,
                  height: 42.17,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD4D4D4),
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0x1A868686)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.ccMastercard),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Gcash',
                          style: TextStyle(
                            color: Color(0xFF868686),
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            height: 0,
                            letterSpacing: -0.28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 314,
                  height: 42.17,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFF3876BF)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.moneyBills),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Cash on Delivery',
                          style: TextStyle(
                            color: Color(0xFF3876BF),
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            height: 0,
                            letterSpacing: -0.28,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        FaIcon(
                          FontAwesomeIcons.check,
                          color: Color(0xFF3876BF),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    placeOrder();
                  },
                  child: Container(
                    width: 318,
                    height: 36,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF3876BF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Place Order',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            height: 0,
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
}
