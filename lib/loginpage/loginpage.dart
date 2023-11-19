// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:capstone_project_pabile/component/botnavbar.dart';
import 'package:capstone_project_pabile/component/stallbotnavbar.dart';
import 'package:capstone_project_pabile/controller/usercontroller.dart';
import 'package:capstone_project_pabile/loginpage/forgotpw.dart';
import 'package:capstone_project_pabile/loginpage/registerpage.dart';
import 'package:capstone_project_pabile/widgets/loginwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion_toast/motion_toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = true;
  final user = FirebaseAuth.instance.currentUser;
  final controller = Get.put(UserController());
  final formKey = GlobalKey<FormState>();
  String error = '';
  bool _loading = false;

  void togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  handleSubmit() {
    if (formKey.currentState!.validate()) {
      logIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: formKey,
            child: Stack(
              children: [
                const Positioned(
                  top: 0,
                  child: LoginWidget(),
                ),
                Positioned(
                  top: 80,
                  right: 0,
                  left: 20,
                  child: Text(
                    'Welcome\nBack',
                    style: GoogleFonts.hammersmithOne(
                      fontSize: 32,
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Positioned(
                  top: currentHeight * 0.455,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: currentHeight * 0.1,
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                    child: TextFormField(
                      controller: controller.email,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Please Enter Your Registered Email';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: GoogleFonts.hammersmithOne(
                          textStyle: const TextStyle(
                            color: Color(0xFF858585),
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF858585),
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          // Change color when focused
                          borderSide: BorderSide(
                            color: Color(0xFF858585),
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color(0xFF858585),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: currentHeight * .555,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: currentHeight * .1,
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                    child: TextFormField(
                      controller: controller.password,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Too Short';
                        } else {
                          return null;
                        }
                      },
                      obscureText: _isPasswordVisible,
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF858585),
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF858585),
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_open_sharp,
                          color: Color(0xFF858585),
                        ),
                        labelText: 'Password',
                        labelStyle: GoogleFonts.hammersmithOne(
                          textStyle: const TextStyle(
                            color: Color(0xFF858585),
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF858585),
                          ),
                          onPressed: togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: currentHeight * .640,
                  right: 60,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Forgetpassword()));
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Forgot Password",
                            style: GoogleFonts.gurajada(
                              fontSize: 20,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF3876BF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: currentHeight * .700,
                  right: 0,
                  left: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _loading ? null : () => handleSubmit(),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF3876BF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 133,
                            vertical: 15,
                          ),
                          elevation: 0,
                        ),
                        child: _loading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                "Log in",
                                style: GoogleFonts.hammersmithOne(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: currentHeight * 0.780,
                  right: 0,
                  left: 0,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Divider(
                        color: Color(0xFFA3A3A3),
                        height: 5,
                        thickness: 30,
                        indent: 20,
                        endIndent: 10,
                      ),
                      Text(
                        "or",
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFA3A3A3),
                        ),
                      ),
                      Divider(
                        color: Color(0xFFA3A3A3),
                        height: 5,
                        thickness: 30,
                        indent: 10,
                        endIndent: 20,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: currentHeight * .820,
                  right: 0,
                  left: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                            side: const BorderSide(
                                color: Color(0xFF3876BF), width: 2),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 124.5, vertical: 15),
                          elevation: 0, // No shadow
                        ),
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.hammersmithOne(
                            textStyle: const TextStyle(
                                color: Color(0xFF3876BF),
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future logIn() async {
    setState(() {
      _loading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: controller.email.text.trim(),
        password: controller.password.text.trim(),
      );
      route();
      if (mounted) {
        setState(() {
          MotionToast(
            //Duration(seconds: 3),
            primaryColor: Colors.green,
            description: const Text("Account Successfully Login."),
            icon: (Icons.check_circle_outline_outlined),
            enableAnimation: true,
          ).show(context);

          error = "";
        });
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(
            msg: "No user found for that email.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
            timeInSecForIosWeb: 5,
            webPosition: 'center',
            webShowClose: true,
            webBgColor: '#e74c3c',
          );
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(
            msg: "Wrong Password.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
            timeInSecForIosWeb: 5,
            webPosition: 'center',
            webShowClose: true,
            webBgColor: '#e74c3c',
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> route() async {
    User? user = FirebaseAuth.instance.currentUser;
    var userid = user!.uid;
    DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child('users/$userid');

    DataSnapshot snapshot = (await usersRef.once()).snapshot;
    if (snapshot.value != null) {
      Map userData = snapshot.value as Map;
      String? role = userData['role'] as String?;

      if (role == "customer") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BotNavBar(),
          ),
        );
      } else if (role == "stallowner") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const StallBotNavBar(),
          ),
        );
      }
    }
  }
}
