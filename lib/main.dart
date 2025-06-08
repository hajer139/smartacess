import 'package:flutter/material.dart';
import 'package:tester_smart/LoginScreen.dart';
import 'package:tester_smart/welcome_page.dart'; // <-- Ajoute cette ligne
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SmartParkingApp());
}

class SmartParkingApp extends StatelessWidget {
  const SmartParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(), // <-- Écran de bienvenue
        '/login': (context) => LoginScreen(), // <-- Page login
      },
    );
  }
}
