import 'package:capstone_project_pabile/loginpage/emailconfirmation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 35, 0, 0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 110, top: 45),
            child: Text(
              'Forgot Password',
              style: GoogleFonts.belgrano(
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                  fontSize: 20,
                  fontWeight: FontWeight.w200),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 100),
            child: Text(
              'Forgot Password',
              style: GoogleFonts.montserrat(
                textStyle: Theme.of(context).textTheme.titleLarge,
                fontSize: 40,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 145),
            child: Text(
              'Enter your email and we will send you a\nreset instructions.',
              style: GoogleFonts.belgrano(
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                  fontSize: 17,
                  fontWeight: FontWeight.w200),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 220),
            child: const Text(
              'EMAIL ADDRESS',
              style: TextStyle(color: Colors.black38, fontSize: 17),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 230),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: false,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 300, 20, 0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConfirmEmail()));
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                backgroundColor: const Color(0xFF2C74B3),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                'RESET PASSWORD',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
