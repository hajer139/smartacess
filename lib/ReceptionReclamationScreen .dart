import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReceptionReclamationScreen extends StatelessWidget {
  const ReceptionReclamationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF6FB),
      appBar: AppBar(
        title: const Text(
          "Réclamations reçues",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF2BA9E4),
        centerTitle: true,
        elevation: 3,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('reclamations')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Aucune réclamation pour le moment.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final reclamations = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reclamations.length,
            itemBuilder: (context, index) {
              final data = reclamations[index].data() as Map<String, dynamic>;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.email, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            data['email'] ?? 'Email inconnu',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data['message'] ?? '',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          _formatTimestamp(data['timestamp']),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
