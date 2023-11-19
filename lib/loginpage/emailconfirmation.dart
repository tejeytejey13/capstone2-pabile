import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmEmail extends StatefulWidget {
  const ConfirmEmail({super.key});

  @override
  State<ConfirmEmail> createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
          padding: const EdgeInsets.only(left: 110, top: 45),
          child:  Text('Forgot Password', style: GoogleFonts.belgrano(
            textStyle: Theme.of(context).textTheme.headlineMedium,
            fontSize: 20,
            fontWeight: FontWeight.w200),),
        ),
         Container(
          padding:  const EdgeInsets.only(left: 20, top: 100),
          child:  Text('Reset Password Sent', 
           style: GoogleFonts.montserrat(
            textStyle: Theme.of(context).textTheme.titleLarge,
            fontSize: 35,
            fontWeight: FontWeight.w300,),
          ),
        ),
         Container(
          padding: const EdgeInsets.only(left: 20, top: 145),
          child: Text('We have sent an instruction on how to \nreset your password it will arrive shortly.', style: GoogleFonts.belgrano(
            textStyle: Theme.of(context).textTheme.headlineMedium,
            fontSize: 17,
            fontWeight: FontWeight.w200),),
        ),
         Container(
          padding: const EdgeInsets.fromLTRB(20, 200, 20, 0),
          child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))), backgroundColor: const Color(0xFF2C74B3),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      'SEND AGAIN',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
        ),
        Container(
           padding: const EdgeInsets.fromLTRB(110, 250, 20, 0),
          child: TextButton(
           child:  Text('Having Problems?', style: GoogleFonts.belgrano(
            textStyle: Theme.of(context).textTheme.headlineMedium,
            fontSize: 17,
            color: Colors.lightBlue,
            fontWeight: FontWeight.w200),),
           onPressed: () {
           },
          ),
        ),
        ],
      ),
    );
  }
}