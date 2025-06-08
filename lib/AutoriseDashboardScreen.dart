import 'package:flutter/material.dart';
import 'package:tester_smart/AjouterImageScreen.dart';
import 'package:tester_smart/AjouterMatriculeScreen.dart';
import 'package:tester_smart/ReclamationScreen.dart';

class AutoriseDashboardScreen extends StatelessWidget {
  final String userEmail;

  const AutoriseDashboardScreen({Key? key, required this.userEmail})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 50, bottom: 24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 43, 169, 228),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "Espace Personne Autorisée",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildCard(
                  icon: Icons.badge,
                  label: "Ajouter un matricule",
                  context: context,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AjouterMatriculeScreen(),
                        ),
                      ),
                ),
                _buildCard(
                  icon: Icons.image,
                  label: "Ajouter une image",
                  context: context,

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AjouterImageScreen()),
                    );
                  },
                ),
                _buildCard(
                  icon: Icons.report_problem,
                  label: "Réclamation",
                  context: context,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ReclamationScreen(userEmail: userEmail),
                        ),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String label,
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Icon(icon, size: 28, color: Colors.blueAccent),
        title: Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        onTap: onTap,
      ),
    );
  }
}
