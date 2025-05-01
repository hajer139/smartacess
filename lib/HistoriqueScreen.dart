import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HistoriqueScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historique des entrées/sorties"),
        backgroundColor: const Color.fromARGB(255, 71, 154, 196),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('authorized_users')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Erreur de chargement des données"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final historiqueDocs = snapshot.data!.docs;

          if (historiqueDocs.isEmpty) {
            return Center(child: Text("Aucune entrée trouvée"));
          }

          return ListView.builder(
            itemCount: historiqueDocs.length,
            itemBuilder: (context, index) {
              final data = historiqueDocs[index].data() as Map<String, dynamic>;

              final nom = data['nom'] ?? 'Nom inconnu';
              final uid = data['uid'] ?? 'UID inconnu';

              DateTime? timestamp;

              if (data['timestamp'] != null) {
                try {
                  if (data['timestamp'] is Timestamp) {
                    timestamp = (data['timestamp'] as Timestamp).toDate();
                  } else if (data['timestamp'] is String) {
                    timestamp = DateTime.parse(data['timestamp']);
                  }
                } catch (e) {
                  timestamp = null;
                }
              }

              final formattedDate =
                  timestamp != null
                      ? DateFormat('dd/MM/yyyy HH:mm:ss').format(timestamp)
                      : 'Date inconnue';

              return ListTile(
                leading: Icon(Icons.access_time),
                title: Text(nom),
                subtitle: Text("UID: $uid\nHeure: $formattedDate"),
              );
            },
          );
        },
      ),
    );
  }
}
