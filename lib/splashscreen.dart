import 'package:capstone_project_pabile/main.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    aftersplash();
  }

  aftersplash() {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(PageTransition(
          duration: const Duration(milliseconds: 900),
          child: const MainPage(),
          type: PageTransitionType.rightToLeft));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C74B3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset('assets/images/pabilelogo.png'),
            ),
          ],
        ),
      ),
    );
  }
}
