import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AjouterMatriculeScreen extends StatefulWidget {
  @override
  _AjouterMatriculeScreenState createState() => _AjouterMatriculeScreenState();
}

class _AjouterMatriculeScreenState extends State<AjouterMatriculeScreen> {
  final TextEditingController matriculeController = TextEditingController();
  bool isLoading = false;

  Future<void> _ajouterMatricule() async {
    String matricule = matriculeController.text.trim();

    if (matricule.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un matricule.")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('matricules').add({
        'matricule': matricule,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Matricule ajouté avec succès !")),
      );
      matriculeController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur lors de l'ajout : $e")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF6FB),
      appBar: AppBar(
        title: const Text("Ajouter un matricule"),
        backgroundColor: const Color(0xFF2BA9E4),
        centerTitle: true,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: matriculeController,
              decoration: InputDecoration(
                labelText: "Matricule",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.badge),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _ajouterMatricule,
                    icon: const Icon(Icons.add),
                    label: const Text("Ajouter"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2BA9E4),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
