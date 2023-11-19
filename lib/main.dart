import 'package:capstone_project_pabile/client/welcomepage/welcome1.dart';
import 'package:capstone_project_pabile/firebase_options.dart';
import 'package:capstone_project_pabile/widgets/mainlogin.dart';
import 'package:capstone_project_pabile/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String error = "";

  void showErrorPopup() {
    Fluttertoast.showToast(msg: "Wrong Credential!");
  }

  Future<bool> isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('first_time') ?? true;
    return isFirstTime;
  }

  Future<void> setFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: AddItem(),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2C74B3),
              ),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            // If there's an error or the user is not authenticated, redirect to login
            return const MainLogin();
          } else {
            return FutureBuilder<bool>(
              future: isFirstTime(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                } else {
                  final bool isFirstTime = snapshot.data ?? true;
                  if (isFirstTime) {
                    setFirstTime();
                    return const Welcome1();
                  } else {
                    return const MainLogin();
                  }
                }
              },
            );
          }
        },
      ),
    );
  }
}
