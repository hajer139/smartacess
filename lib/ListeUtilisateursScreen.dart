import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListeUtilisateursScreen extends StatelessWidget {
  final String categorie;

  ListeUtilisateursScreen({required this.categorie});

  void _supprimerUtilisateur(BuildContext context, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('authorized_users')
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Utilisateur supprimé avec succès."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      appBar: AppBar(
        title: Text(
          "Liste des ${categorie.toLowerCase()}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14, // Taille du titre réduite
          ),
        ),
        backgroundColor: const Color(0xFF2BA9E4),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('authorized_users')
                .where('categorie', isEqualTo: categorie)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Aucun utilisateur trouvé."));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final doc = users[index];
              final data = doc.data() as Map<String, dynamic>;
              final nom = data['nom'] ?? '';
              final prenom = data['prenom'] ?? '';
              final email = data['email'] ?? '';

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF2BA9E4).withOpacity(0.1),
                    child: Text(
                      prenom.isNotEmpty ? prenom[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    "$prenom $nom",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    email,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed:
                        () => showDialog(
                          context: context,
                          builder:
                              (ctx) => AlertDialog(
                                title: const Text("Confirmation"),
                                content: const Text(
                                  "Souhaitez-vous supprimer cet utilisateur ?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text("Annuler"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                      _supprimerUtilisateur(context, doc.id);
                                    },
                                    child: const Text(
                                      "Supprimer",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
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
