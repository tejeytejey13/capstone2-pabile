import 'package:capstone_project_pabile/controller/usercontroller.dart';
import 'package:capstone_project_pabile/widgets/loginwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _acceptedTerms = false;
  bool _isChecked = false;
  bool _isPasswordVisible = true;
  String selectedRole = '';

  final controller = Get.put(UserController());
  final formKey = GlobalKey<FormState>();

String error = '';
  void togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  handleSubmit() {
    if (_acceptedTerms) {
      if (formKey.currentState!.validate()) {
        registerUser();
      }
    } else {
      showTermsAndConditionsDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    bool isRegisterButtonEnabled =
        _acceptedTerms && formKey.currentState!.validate();
    return Scaffold(
      backgroundColor: Colors.white,
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
                  'Create\nAccount',
                  style: GoogleFonts.hammersmithOne(
                    fontSize: 32,
                    color: Colors.white,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 380),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: CupertinoFormRow(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            showRolePicker(context);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFF858585),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Selected Role: $selectedRole',
                                  style: GoogleFonts.hammersmithOne(
                                    textStyle: const TextStyle(
                                      color: Color(0xFF858585),
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Container(
                    //   height: 80,
                    //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    //   child: IntlPhoneField(
                    //     keyboardType: TextInputType.phone,
                    //     decoration: const InputDecoration(
                    //       border: OutlineInputBorder(
                    //         borderSide: BorderSide(),
                    //       ),
                    //     ),
                    //     initialCountryCode: 'PH',
                    //     onChanged: (phone) {
                    //       setState(() {
                    //         controller.phoneNo.text = phone.completeNumber;
                    //       });
                    //     },
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please Enter Your Full Name';
                          } else {
                            return null;
                          }
                        },
                        controller: controller.name,
                        decoration: InputDecoration(
                          labelText: 'Full Name *(For Stall Owner: E.g Stall 1)',
                        
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
                            Icons.person,
                            color: Color(0xFF858585),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please Enter Your Umindanao Email';
                          } else {
                            return null;
                          }
                        },
                        controller: controller.email,
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
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Too Short';
                          } else {
                            return null;
                          }
                        },
                        obscureText: _isPasswordVisible,
                        controller: controller.password,
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
                  ],
                ),
              ),
              Positioned(
                top: 620,
                left: 70,
                right: 0,
                child: TermsAndCondition(),
              ),
              Positioned(
                top: 680,
                right: 0,
                left: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed:
                          isRegisterButtonEnabled ? () => handleSubmit() : null,
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
                    ),
                  ],
                ),
              ),
              const Positioned(
                top: 740,
                right: 0,
                left: 0,
                child: Row(
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
                top: 780,
                right: 0,
                left: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
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
                            horizontal: 138, vertical: 15),
                        elevation: 0, // No shadow
                      ),
                      child: Text(
                        "Log in",
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
    );
  }

  // ignore: non_constant_identifier_names
  Widget TermsAndCondition() => Row(
        children: [
          Checkbox(
            value: _isChecked,
            activeColor: const Color(0xFF2C74B3),
            onChanged: (value) {
              setState(() {
                _isChecked = value ?? false;
                if (_isChecked) {
                  showTermsAndConditionsDialog(context);
                }
              });
            },
          ),
          const Text(
            'I accept the terms and conditions',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      );

  Future showTermsAndConditionsDialog(BuildContext context) async {
    if (!_acceptedTerms) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Terms and Conditions"),
            content: const Text("These are the terms and conditions..."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _acceptedTerms = true;
                  });
                },
                child: const Text("Accept"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _acceptedTerms = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("You must accept the terms and conditions."),
                      ),
                    );
                  });
                },
                child: const Text("Decline"),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You have already accepted the terms and conditions."),
        ),
      );
    }
  }

  Future registerUser() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: controller.email.text.trim(),
        password: controller.password.text.trim(),
      );

      setState(() {
        createUser();
        addNewId();
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Account Successfully Created");
        error = "";
      });
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: "The password provided is too weak.",
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
      } else if (e.code == 'email-already-exists') {
        Fluttertoast.showToast(
          msg: "The account already exists for that email.",
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
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> addNewId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final newCustomerID = user.uid;
      DatabaseReference menuItemsRef =
          FirebaseDatabase.instance.ref('menuItems');

      DataSnapshot menuItemsSnapshot = (await menuItemsRef.once()).snapshot;

      if (menuItemsSnapshot.value != null) {
        Map<dynamic, dynamic> menuItemsData =
            menuItemsSnapshot.value as Map<dynamic, dynamic>;

        menuItemsData.forEach((menuItemID, menuItemData) async {
          DatabaseReference ratesRef =
              FirebaseDatabase.instance.ref('menuItems/$menuItemID/rates');

          await ratesRef.child(newCustomerID).set(0);
        });
      }
    }
  }

  Future<void> createUser() async {
    final user = FirebaseAuth.instance.currentUser!;

    final userID = user.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref('users');
    var newUserRef = ref.child(userID);

    String status;

    if (selectedRole == "customer") {
      status = "pending";
    } else if (selectedRole == "stallowner") {
      status = "pending";
    } else {
      status = "unknown";
    }

    await newUserRef.set({
      "id": userID,
      "name": controller.name.text,
      "phoneNo": controller.phoneNo.text,
      "email": controller.email.text,
      "password": controller.password.text,
      "role": selectedRole,
      "status": status,
      "stallbanner": '',
      "form": '',
    });
  }

  void showRolePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Select Your Role'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Customer'),
              onPressed: () {
                setState(() {
                  selectedRole = 'customer';
                });
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Stall Owner'),
              onPressed: () {
                setState(() {
                  selectedRole = 'stallowner';
                });
                Navigator.pop(context);
              },
            ),
            // CupertinoActionSheetAction(
            //   child: const Text('Courier'),
            //   onPressed: () {
            //     setState(() {
            //       selectedRole = 'courier';
            //     });
            //     Navigator.pop(context);
            //   },
            // ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
