import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AdminDashboardScreen.dart';
import 'AgentDashboardScreen.dart';
import 'AutoriseDashboardScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    setState(() => isLoading = true);
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      if (userDoc.exists) {
        String role = userDoc.get('role');

        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
          );
        } else if (role == 'autorise') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AutoriseDashboardScreen(userEmail: email),
            ),
          );
        } else if (role == 'agent') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AgentDashboardScreen()),
          );
        } else {
          _showSnackBar("Rôle inconnu");
        }
      } else {
        _showSnackBar('Utilisateur non trouvé');
      }
    } catch (e) {
      _showSnackBar('Erreur : $e');
    }

    setState(() => isLoading = false);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.blueAccent),
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Image de fond
          Image.asset(
            'assets/images/smartlogin.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
          // ✅ voile sombre
          Container(color: Colors.black.withOpacity(0.2)),

          // ✅ contenu remonté
          Column(
            children: [
              const SizedBox(height: 350), // ajuste la hauteur ici
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Connexion à votre compte',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white70),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: emailController,
                            decoration: _inputDecoration('Email', Icons.email),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: _inputDecoration(
                              'Mot de passe',
                              Icons.lock,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.blueAccent,
                                  Colors.lightBlueAccent,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child:
                                  isLoading
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : Text(
                                        'Se connecter',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
