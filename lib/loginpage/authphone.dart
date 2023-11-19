import 'package:capstone_project_pabile/controller/usercontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class AuthenticationPhoneNo extends StatefulWidget {
  const AuthenticationPhoneNo({super.key});

  @override
  State<AuthenticationPhoneNo> createState() => _AuthenticationPhoneNoState();
}

class _AuthenticationPhoneNoState extends State<AuthenticationPhoneNo> {
  final controller = Get.put(UserController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xfff7f6fb),
        body: Form(
          key: _formKey,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 230,
                    height: 230,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/sending.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Add your phone number. We'll send you verification code so we know you're real",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.podkova(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  IntlPhoneField(
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    initialCountryCode: 'PH',
                    onChanged: (phone) {
                      setState(() {
                        controller.phoneNo.text = phone.completeNumber;
                      });
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // if (_formKey.currentState!.validate()) {
                        //   UserController.instance.phoneAuthentication(
                        //       controller.phoneNo.text.trim());
                        //   Get.to(() => const OTPScreen());
                        // }
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Text(
                          'Send',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
