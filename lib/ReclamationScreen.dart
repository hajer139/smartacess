import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tester_smart/ReceptionReclamationScreen%20.dart';

class ReclamationScreen extends StatefulWidget {
  final String userEmail;

  const ReclamationScreen({super.key, required this.userEmail});

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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Réclamation envoyée avec succès")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2BA9E4),
        centerTitle: true,
        elevation: 3,
        title: const Text(
          "Réclamation",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            tooltip: 'Voir les réclamations reçues',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ReceptionReclamationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Votre message :",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _controller,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: "Écrivez votre réclamation ici...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 25),
            _isSending
                ? const CircularProgressIndicator()
                : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _envoyerReclamation,
                    icon: const Icon(Icons.send),
                    label: const Text("Envoyer"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2BA9E4),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 16),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.mark_email_read),
                label: const Text("Voir les réclamations reçues"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReceptionReclamationScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2BA9E4),
                  side: const BorderSide(color: Color(0xFF2BA9E4)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
