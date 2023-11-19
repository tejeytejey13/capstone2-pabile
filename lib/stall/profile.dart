import 'dart:io';

import 'package:capstone_project_pabile/loginpage/loginpage.dart';
import 'package:capstone_project_pabile/widgets/profilewidget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StallProfile extends StatefulWidget {
  const StallProfile({Key? key}) : super(key: key);

  @override
  State<StallProfile> createState() => _StallProfileState();
}

class _StallProfileState extends State<StallProfile> {
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
      String stallID = user.uid;
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref('users/$stallID');

      try {
        if (selectedFile != null) {
          final storage = FirebaseStorage.instance;
          var fileFileName =
              'item_files/$stallID.${selectedFile!.path.split('/').last.split('.').last}';

          await storage.ref(fileFileName).putFile(selectedFile!);
          String fileUrl = await storage.ref(fileFileName).getDownloadURL();

          await userRef.update({
            "stallbanner": fileUrl,
          });

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Success"),
                content: const Text("Banner has been saved successfully."),
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
                width: width,
                child: Column(
                  children: [
                    buildMenuItem(0, FontAwesomeIcons.userGear, 'My Account',
                        const Color(0xFF7D7D7D)),
                    buildMenuItem(1, FontAwesomeIcons.wpforms, 'Add Banner',
                        const Color(0xFF7D7D7D)),
                    buildMenuItem(2, FontAwesomeIcons.whmcs, 'Settings',
                        const Color(0xFF7D7D7D)),
                    buildMenuItem(3, FontAwesomeIcons.headset,
                        'Customer Support', const Color(0xFF7D7D7D)),
                    buildMenuItem(4, FontAwesomeIcons.signOutAlt, 'Log out',
                        const Color(0xFF7D7D7D)),
                  ],
                ),
              )
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

  Widget buildMenuItem(
      int index, IconData icon, String label, Color textColor) {
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          _showImageAttachmentDialog();
        } else if (index == 4) {
          _signOut();
        } else {
          setState(() {
            selectedIndex = index;
          });
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 25, 0, 0),
            child: Row(
              children: [
                FaIcon(icon,
                    color: selectedIndex == index ? Colors.blue : null),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    color: selectedIndex == index ? Colors.blue : textColor,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: 0.10,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 2.5,
          ),
        ],
      ),
    );
  }

  void _showImageAttachmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Attach Banner Image'),
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
