import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Logo
              Image.asset('assets/images/logosm.png', height: 220),

              const SizedBox(height: 20),

              // Texte de bienvenue
              const Text(
                'Bienvenue dans',
                style: TextStyle(fontSize: 22, color: Colors.white70),
              ),
              const SizedBox(height: 5),
              const Text(
                'SMART ACCESS',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              // Description en 3 lignes (réduite et en noir clair)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Text(
                      'Un système intelligent de contrôle d’accès',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'basé sur la reconnaissance faciale',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'et l’identification par badge RFID.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),

              // Bouton "Commencer"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF3A7BD5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Commencer'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
