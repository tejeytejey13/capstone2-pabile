import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectPayment {
  static Future<void> showPaymentMethod(BuildContext context) async {
    int type = 1;

    void handleRadio(Object? e) {
      type = e as int;
    }

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final Size size = MediaQuery.of(context).size;

    await showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                width: width,
                height: height / 2,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                      child: Text(
                        'Select preferred payment method.',
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 17,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width,
                      height: 55,
                      margin: const EdgeInsets.only(),
                      decoration: BoxDecoration(
                        border: type == 1
                            ? Border.all(width: 1, color: Colors.black)
                            : Border.all(width: 0.3, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            Radio(
                                value: 1,
                                groupValue: type,
                                onChanged: (e) =>
                                    setState(() => handleRadio(e))),
                            Text(
                              'Gcash',
                              style: type == 1
                                  ? const TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w500)
                                  : const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: size.width,
                      height: 55,
                      margin: const EdgeInsets.only(),
                      decoration: BoxDecoration(
                        border: type == 2
                            ? Border.all(width: 1, color: Colors.black)
                            : Border.all(width: 0.3, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            Radio(
                                value: 2,
                                groupValue: type,
                                onChanged: (e) =>
                                    setState(() => handleRadio(e))),
                            Text(
                              'Cash on Delivery',
                              style: type == 1
                                  ? const TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w500)
                                  : const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          backgroundColor: const Color(0xFF2C74B3),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text(
                          'PROCEED',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
