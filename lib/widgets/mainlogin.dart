import 'package:capstone_project_pabile/loginpage/loginpage.dart';
import 'package:capstone_project_pabile/loginpage/registerpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainLogin extends StatefulWidget {
  const MainLogin({super.key});

  @override
  State<MainLogin> createState() => _MainLoginState();
}

class _MainLoginState extends State<MainLogin> {
  @override
  Widget build(BuildContext context) {
    double reswidth = MediaQuery.of(context).size.width;
    double resheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        width: reswidth,
        height: resheight,
        color: const Color(0xFF3876BF),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              left: 16,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/pabilelogo.png',
                    height: 60,
                  ),
                  Text(
                    'Pabile',
                    style: GoogleFonts.gurajada(
                      color: Colors.white,
                      fontSize: 50,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: reswidth,
                height: resheight / 2.3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(43, 20, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pabile',
                        style: GoogleFonts.hammersmithOne(
                          textStyle: const TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        'One click away from having your meal \nof the day',
                        style: GoogleFonts.hammersmithOne(
                          textStyle: const TextStyle(
                            color: Color(0xFFD9D9D9),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF3876BF),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 130,
                            vertical: 15,
                          ),
                          elevation: 0, // No shadow
                        ),
                        child: Text(
                          "Log in",
                          style: GoogleFonts.hammersmithOne(
                            textStyle: const TextStyle(
                                color: Color(0xFF2C74B3),
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side:
                                const BorderSide(color: Colors.white, width: 2),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 124.5, vertical: 15),
                          elevation: 0, // No shadow
                        ),
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.hammersmithOne(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
