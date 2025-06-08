import 'package:flutter/material.dart';
import 'package:tester_smart/ConsulterRapportsScreen.dart';
import 'package:tester_smart/GestionUtilisateursScreen.dart';

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 50, bottom: 24),
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
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              "Espace Admin",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildCard(
                  icon: Icons.group,
                  label: "Gestion des utilisateurs",
                  context: context,
                  screen: GestionUtilisateursScreen(),
                ),
                _buildCard(
                  icon: Icons.description,
                  label: "Consulter les rapports",
                  context: context,
                  screen: ConsulterRapportsScreen(),
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
    required Widget screen,
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
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
      ),
    );
  }
}
