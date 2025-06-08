import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ConsulterRapportsScreen extends StatelessWidget {
  const ConsulterRapportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '📄 Consulter les Rapports',
          style: TextStyle(fontSize: 18), // Taille réduite du titre
        ),
        backgroundColor: const Color(0xFF2BA9E4),
        elevation: 2,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('rapports')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Aucun rapport trouvé.',
                style: TextStyle(fontSize: 14),
              ),
            );
          }

          final rapports = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: rapports.length,
            itemBuilder: (context, index) {
              final rapport = rapports[index].data() as Map<String, dynamic>;
              final date = (rapport['timestamp'] as Timestamp).toDate();
              final dateFormatted = DateFormat('dd/MM/yyyy HH:mm').format(date);
              final data = List<Map<String, dynamic>>.from(rapport['data']);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: const Icon(
                    Icons.description_outlined,
                    color: Color(0xFF2BA9E4),
                  ),
                  title: Text(
                    'Rapport du $dateFormatted',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  childrenPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  children:
                      data.map((item) {
                        final timestamp =
                            (item['timestamp'] as Timestamp).toDate();
                        final itemDate = DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(timestamp);
                        return ListTile(
                          leading: const Icon(
                            Icons.person_outline,
                            color: Color(0xFF2BA9E4),
                          ),
                          title: Text(
                            item['nom'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            'UID : ${item['uid'] ?? ''}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Text(
                            itemDate,
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
