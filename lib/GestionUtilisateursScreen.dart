import 'package:flutter/material.dart';
import 'package:tester_smart/AjouterUtilisateurScreen.dart';
import 'package:tester_smart/ListeUtilisateursScreen.dart';

class GestionUtilisateursScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {
      'label': 'Agents de sécurité',
      'icon': Icons.security,
      'color': Colors.blue,
    },
    {'label': 'Enseignants', 'icon': Icons.school, 'color': Colors.green},
    {'label': 'Administratifs', 'icon': Icons.business, 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      appBar: AppBar(
        title: const Text(
          "Gestion des utilisateurs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2BA9E4),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];

            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ListeUtilisateursScreen(
                            categorie: category['label'],
                          ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: category['color'].withOpacity(0.2),
                        child: Icon(category['icon'], color: category['color']),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          category['label'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => AjoutUtilisateurScreen(
                                    categorie: category['label'],
                                  ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: category['color'],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text("Ajouter"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
