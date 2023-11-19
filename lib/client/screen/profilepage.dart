import 'dart:io';

import 'package:capstone_project_pabile/component/courierbotnavbar.dart';
import 'package:capstone_project_pabile/loginpage/loginpage.dart';
import 'package:capstone_project_pabile/widgets/profilewidget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ClientProfile extends StatefulWidget {
  const ClientProfile({Key? key}) : super(key: key);

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  int selectedIndex = 0;
  File? selectedFile;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFile = File(result.files.first.path!);
      });
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void updateBanner() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userID = user.uid;
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref('users/$userID');

      try {
        if (selectedFile != null) {
          final storage = FirebaseStorage.instance;
          var fileFileName =
              'item_files/$userID.${selectedFile!.path.split('/').last.split('.').last}';

          await storage.ref(fileFileName).putFile(selectedFile!);
          String fileUrl = await storage.ref(fileFileName).getDownloadURL();

          await userRef.update({
            "form": fileUrl,
          });

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Success"),
                content: const Text("Form 1 has been saved successfully."),
                actions: <Widget>[
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Error"),
                content: const Text("Please select a file to upload."),
                actions: <Widget>[
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("An error occurred while saving the item."),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: ((context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final user = FirebaseAuth.instance.currentUser?.uid;
          late var userid = user!;
          DatabaseReference dbRef =
              FirebaseDatabase.instance.ref().child('users');
          return Column(
            children: [
              const ProfileWidget(),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: height / 5,
                width: width / 1.2,
                decoration: ShapeDecoration(
                  color: const Color(0xFF3876BF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 10,
                      offset: Offset(4, 6),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: FirebaseAnimatedList(
                    scrollDirection: Axis.horizontal,
                    query: dbRef,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      Map user = snapshot.value as Map;
                      user['key'] = snapshot.key;
                      if (user['id'] == userid) {
                        return userinfo(user);
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: height / 2.5,
                width: width / 1.2,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: FirebaseAnimatedList(
                    scrollDirection: Axis.horizontal,
                    query: dbRef,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      Map user = snapshot.value as Map;
                      user['key'] = snapshot.key;
                      if (user['id'] == userid) {
                        return buildMenuItem(user);
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget userinfo(user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.userCheck,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Stall Name: ${user['name']}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
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
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.solidEnvelope,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Email: ${user['email']}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
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
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.phone,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Phone Number: ${user['phoneNo']}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: 0.10,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print("Error during sign out: $e");
    }
  }

  Widget buildMenuItem(Map user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.userCog,
                  color: Color(0xFF3876BF),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  'My Account',
                  style: TextStyle(
                    color: Color(0xFF3876BF),
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: 0.10,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (user['status'] == 'pending') {
              _showImageAttachmentDialog();
            } else if (user['status'] == 'approved') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourierBotNavBar(),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.wpforms,
                  color: Color(0xFF7D7D7D),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  user['status'] == 'approved'
                      ? 'Direct to Courier'
                      : 'Apply as Courier',
                  style: TextStyle(
                    color: Color(0xFF7D7D7D),
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: 0.10,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.whmcs,
                  color: Color(0xFF7D7D7D),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  'Settings',
                  style: TextStyle(
                    color: Color(0xFF7D7D7D),
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: 0.10,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.headset,
                  color: Color(0xFF7D7D7D),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  'Customer Support',
                  style: TextStyle(
                    color: Color(0xFF7D7D7D),
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: 0.10,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _signOut();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.signOutAlt,
                  color: Color(0xFF7D7D7D),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  'Log Out',
                  style: TextStyle(
                    color: Color(0xFF7D7D7D),
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: 0.10,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          thickness: 2.5,
        ),
      ],
    );
  }

  void _showImageAttachmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Attach Form 1'),
          content: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: SizedBox(
              width: 304,
              height: 31,
              child: ElevatedButton(
                onPressed: () {
                  pickFile();
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFFCFCFCF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        FontAwesomeIcons.fileImage,
                        color: Colors.blue.shade900,
                        size: 20,
                      ),
                    ),
                    Text(
                      selectedFile != null
                          ? selectedFile!.path.split('/').last.split('.').first
                          : 'Attach File',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                updateBanner();
              },
              child: Text('Upload'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
