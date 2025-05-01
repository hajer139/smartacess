import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Espace Admin"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Icon(Icons.group),
            title: Text("Gestion des utilisateurs"),
            onTap: () {
              // Naviguer vers l'écran de gestion des utilisateurs
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.description),
            title: Text("Consulter les rapports"),
            onTap: () {
              // Naviguer vers l'écran des rapports
            },
          ),
        ],
      ),
    );
  }
}
