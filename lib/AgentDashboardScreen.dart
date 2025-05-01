import 'package:flutter/material.dart';
import 'package:tester_smart/HistoriqueScreen.dart';
import 'package:tester_smart/NotificationsScreen.dart';
import 'package:tester_smart/GenererRapportScreen.dart';

class AgentDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Espace Agent de Sécurité"),
        backgroundColor: const Color.fromARGB(255, 13, 118, 167),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Icon(Icons.history),
            title: Text("Historique"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HistoriqueScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notifications"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NotificationsScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.picture_as_pdf),
            title: Text("Générer un rapport"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GenererRapportScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.update),
            title: Text("Mise à jour liste personne autorisée"),
            onTap: () {
              // Naviguer vers mise à jour liste
            },
          ),
        ],
      ),
    );
  }
}
