import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AjoutUtilisateurScreen extends StatefulWidget {
  final String categorie;

  AjoutUtilisateurScreen({required this.categorie});

  @override
  _AjoutUtilisateurScreenState createState() => _AjoutUtilisateurScreenState();
}

class _AjoutUtilisateurScreenState extends State<AjoutUtilisateurScreen> {
  final _formKey = GlobalKey<FormState>();
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final emailController = TextEditingController();
  final mdpController = TextEditingController();
  final confirmMdpController = TextEditingController();
  bool isLoading = false;

  Future<void> _ajouterUtilisateur() async {
    if (!_formKey.currentState!.validate()) return;

    if (mdpController.text != confirmMdpController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Les mots de passe ne correspondent pas."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('authorized_users').add({
        'nom': nomController.text.trim(),
        'prenom': prenomController.text.trim(),
        'email': emailController.text.trim(),
        'categorie': widget.categorie,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Utilisateur ajouté avec succès."),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      appBar: AppBar(
        title: Text(
          "Ajouter ${widget.categorie}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2BA9E4),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(nomController, "Nom"),
              _buildTextField(prenomController, "Prénom"),
              _buildTextField(
                emailController,
                "Email",
                keyboard: TextInputType.emailAddress,
              ),
              _buildTextField(mdpController, "Mot de passe", isPassword: true),
              _buildTextField(
                confirmMdpController,
                "Confirmer le mot de passe",
                isPassword: true,
              ),
              const SizedBox(height: 30),
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _ajouterUtilisateur,
                      icon: const Icon(Icons.check_circle),
                      label: const Text("Enregistrer"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2BA9E4),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboard,
        validator:
            (value) =>
                value == null || value.isEmpty ? 'Champ obligatoire' : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
