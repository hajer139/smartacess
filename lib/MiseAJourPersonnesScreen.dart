import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MiseAJourPersonnesScreen extends StatelessWidget {
  const MiseAJourPersonnesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF6FB),
      appBar: AppBar(
        title: const Text(
          'Liste des personnes autorisées',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18, // Taille du titre réduite
          ),
        ),
        backgroundColor: const Color(0xFF2BA9E4),
        centerTitle: true,
        elevation: 3,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('authorized_users')
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          if (users.isEmpty) {
            return const Center(child: Text('Aucune personne autorisée.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final data = user.data() as Map<String, dynamic>;

              final nom =
                  data.containsKey('nom') ? data['nom'] : 'Nom non disponible';
              final uid =
                  data.containsKey('uid') ? data['uid'] : 'UID non disponible';

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF2BA9E4),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    nom,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('UID : $uid'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          _showEditDialog(context, user.id, nom, uid);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('authorized_users')
                              .doc(user.id)
                              .delete();
                        },
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

  void _showEditDialog(
    BuildContext context,
    String docId,
    String currentNom,
    String currentUid,
  ) {
    final nomController = TextEditingController(text: currentNom);
    final uidController = TextEditingController(text: currentUid);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Modifier la personne'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: uidController,
                  decoration: const InputDecoration(labelText: 'UID'),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Annuler'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2BA9E4),
                ),
                child: const Text('Enregistrer'),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('authorized_users')
                      .doc(docId)
                      .update({
                        'nom': nomController.text,
                        'uid': uidController.text,
                      });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }
}
