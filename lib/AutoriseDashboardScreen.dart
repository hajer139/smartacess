import 'package:flutter/material.dart';
import 'package:tester_smart/AjouterMatriculeScreen.dart';
import 'package:tester_smart/ReclamationScreen.dart';

class AutoriseDashboardScreen extends StatelessWidget {
  final String userEmail;

  const AutoriseDashboardScreen({Key? key, required this.userEmail})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Espace Personne Autorisée"),
        backgroundColor: const Color.fromARGB(255, 44, 149, 180),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Icon(Icons.badge),
            title: Text("Ajouter un matricule"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AjouterMatriculeScreen(),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.image),
            title: Text("Ajouter une image"),
            onTap: () {
              // À implémenter
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.report_problem),
            title: Text("Réclamation"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReclamationScreen(userEmail: userEmail),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
