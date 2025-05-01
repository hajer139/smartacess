import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: const Color.fromARGB(255, 27, 145, 180),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('notifications')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs;

          if (notifications.isEmpty) {
            return Center(child: Text('Aucune notification disponible.'));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notif = notifications[index];
              var titre = notif['titre'];
              var message = notif['message'];
              var timestamp = notif['timestamp'] as Timestamp;
              var formattedDate = DateFormat(
                'dd/MM/yyyy HH:mm',
              ).format(timestamp.toDate());

              return ListTile(
                leading: Icon(Icons.notifications),
                title: Text(titre), // Corrigé ici
                subtitle: Text('$message\n$formattedDate'),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}
