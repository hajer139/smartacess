import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_active, color: Colors.white),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('notifications')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Erreur de chargement'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs;

          if (notifications.isEmpty) {
            return const Center(
              child: Text("Aucune notification pour le moment"),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final data = notifications[index].data() as Map<String, dynamic>;

              final String nom = data['nom'] ?? '---';
              final String message = data['message'] ?? '';
              final String status = data['status'] ?? '';
              final String uid = data['uid']?.toString() ?? '';
              final DateTime timestamp = DateTime.parse(data['timestamp']);
              final String formattedDate = DateFormat(
                'dd/MM/yyyy – HH:mm',
              ).format(timestamp);

              Color statusColor =
                  status.toLowerCase() == "autorisé"
                      ? Colors.green
                      : Colors.red;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: const Icon(Icons.notifications, color: Colors.blue),
                  ),
                  title: Text(
                    "$nom ($status)",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(message, style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(
                        "UID: $uid",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "Le $formattedDate",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.circle, color: statusColor, size: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
