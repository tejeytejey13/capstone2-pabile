// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  late TextEditingController itemNameCtrl;
  late TextEditingController itemDesCtrl;
  late TextEditingController itemPriceCtrl;
  File? selectedFile;

  @override
  void initState() {
    super.initState();
    itemNameCtrl = TextEditingController();
    itemDesCtrl = TextEditingController();
    itemPriceCtrl = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    itemNameCtrl.dispose();
    itemDesCtrl.dispose();
    itemPriceCtrl.dispose();
  }

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
  void writeOrder() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String stallID = user.uid;
      DatabaseReference ref = FirebaseDatabase.instance.ref('menuItems');
      var newItemRef = ref.push();
      DatabaseReference userRef = FirebaseDatabase.instance.ref('users');

      try {
        if (selectedFile != null) {
          final storage = FirebaseStorage.instance;
          var fileFileName = 'item_files/${newItemRef.key}.txt';
          await storage.ref(fileFileName).putFile(selectedFile!);
          String fileUrl = await storage.ref(fileFileName).getDownloadURL();

          DataSnapshot usersSnapshot = (await userRef.once()).snapshot;
          Map<dynamic, dynamic> usersData =
              usersSnapshot.value as Map<dynamic, dynamic>;

          var rates  = <String, int>{};

          usersData.forEach((userId, userData) {
            if (userData['role'] == 'customer') {
              rates[userId] = 0;
            }
          });
        
          await newItemRef.set({
            "available": true,
            "itemName": itemNameCtrl.text,
            "itemDescription": itemDesCtrl.text,
            "itemPrice": itemPriceCtrl.text,
            "stallID": stallID,
            "itemID": newItemRef.key,
            "itemImg": fileUrl,
            "rates": rates,
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Success"),
                content: const Text("Item has been saved successfully."),
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
          await newItemRef.set({
            "available": true,
            "itemName": itemNameCtrl.text,
            "itemDescription": itemDesCtrl.text,
            "itemPrice": itemPriceCtrl.text,
            "stallID": stallID,
            "itemID": newItemRef.key,
          });

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Success"),
                content: const Text("Item has been saved successfully."),
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
    double reswidth = MediaQuery.of(context).size.width;
    double resheight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFE6E6E6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: resheight / 3.5,
                  width: reswidth,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3876BF),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Item Dashboard',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          height: 0,
                          letterSpacing: 0.10,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Stall item controller',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF3876BF),
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w800,
                  height: 0,
                  letterSpacing: 0.10,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: SizedBox(
                        width: 304,
                        height: 31,
                        child: TextFormField(
                          controller: itemNameCtrl,
                          cursorHeight: 0,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFCFCFCF),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: FaIcon(
                                FontAwesomeIcons.basketShopping,
                                color: Colors.blue.shade900,
                                size: 20,
                              ),
                            ),
                            labelText: 'Item Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: SizedBox(
                        width: 304,
                        height: 31,
                        child: TextFormField(
                          controller: itemDesCtrl,
                          cursorHeight: 0,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFCFCFCF),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: FaIcon(
                                FontAwesomeIcons.audioDescription,
                                color: Colors.blue.shade900,
                                size: 20,
                              ),
                            ),
                            labelText: 'Item Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: SizedBox(
                        width: 304,
                        height: 31,
                        child: TextFormField(
                          controller: itemPriceCtrl,
                          cursorHeight: 0,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFCFCFCF),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: FaIcon(
                                FontAwesomeIcons.pesoSign,
                                color: Colors.blue.shade900,
                                size: 20,
                              ),
                            ),
                            labelText: 'Item Price',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
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
                                    ? selectedFile!.path.split('/').last
                                    : 'Attach File', 
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: GestureDetector(
                        onTap: () {
                          writeOrder();
                        },
                        child: Container(
                          width: 297,
                          height: 36,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF3876BF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Save Item',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    var firstStart = Offset(size.width / 5, size.height);
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart =
        Offset(size.width - (size.width / 3.24), size.height - 105);
    var secondEnd = Offset(size.width, size.height - 10);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
