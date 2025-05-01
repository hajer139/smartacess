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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Veuillez entrer un matricule.")));
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('matricules').add({
        'matricule': matricule,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Matricule ajouté avec succès !")));
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
      appBar: AppBar(title: Text("Ajouter un matricule")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: matriculeController,
              decoration: InputDecoration(
                labelText: "Matricule",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _ajouterMatricule,
                  child: Text("Ajouter"),
                ),
          ],
        ),
      ),
    );
  }
}
