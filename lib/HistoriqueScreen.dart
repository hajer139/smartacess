import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HistoriqueScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF6FB), // Fond bleu très clair
      appBar: AppBar(
        title: const Text(
          "Historique des entrées/sorties",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ), // Taille réduite
        ),
        backgroundColor: const Color(0xFF2BA9E4), // Bleu principal
        centerTitle: true,
        elevation: 3,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('authorized_users')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Erreur de chargement des données"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final historiqueDocs = snapshot.data!.docs;

          if (historiqueDocs.isEmpty) {
            return const Center(child: Text("Aucune entrée trouvée"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: historiqueDocs.length,
            itemBuilder: (context, index) {
              final data = historiqueDocs[index].data() as Map<String, dynamic>;

              final nom = data['nom'] ?? 'Nom inconnu';
              final uid = data['uid']?.toString() ?? 'UID inconnu';

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

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF2BA9E4),
                    child: Icon(Icons.access_time, color: Colors.white),
                  ),
                  title: Text(
                    nom,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2BA9E4),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("UID : $uid"),
                        Text("Heure : $formattedDate"),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
