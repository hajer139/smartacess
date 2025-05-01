import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReclamationScreen extends StatefulWidget {
  final String userEmail;

  ReclamationScreen({required this.userEmail});

  @override
  _ReclamationScreenState createState() => _ReclamationScreenState();
}

class _ReclamationScreenState extends State<ReclamationScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  Future<void> _envoyerReclamation() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _isSending = true);

    await FirebaseFirestore.instance.collection('reclamations').add({
      'email': widget.userEmail,
      'message': _controller.text.trim(),
      'timestamp': Timestamp.now(),
    });

    setState(() {
      _isSending = false;
      _controller.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Réclamation envoyée avec succès")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Envoyer une réclamation")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Écrivez votre réclamation ici...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _isSending
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _envoyerReclamation,
                  child: Text("Envoyer"),
                ),
          ],
        ),
      ),
    );
  }
}
