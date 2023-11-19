import 'package:capstone_project_pabile/client/welcomepage/welcome1.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      width: 437,
      height: 437,
      child: Stack(
        children: [
          Positioned(
            left: -101,
            top: -49,
            child: Container(
              width: 437,
              height: 437,
              decoration: BoxDecoration(
                // ignore: use_full_hex_values_for_flutter_colors
                color: const Color(0x2C74B3).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 10, 20),
                    child: Text(
                      "PABILE \nFoodService",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                          fontSize: 37,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(0, 0, 70.5, 0),
              //   child: SvgPicture.asset('assets/images/illustration.svg'),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 20.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.titleMedium,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 15, 50, 0),
                      child: Text(
                        "It’s a pleasure to meet you. We are excited that you’re here so let’s get started!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.labelMedium,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 38.5),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(_createRoute());
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))), backgroundColor: const Color(0xFF2C74B3),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    'GET STARTED',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Welcome1(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
