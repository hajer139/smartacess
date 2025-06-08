import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class AjouterImageScreen extends StatefulWidget {
  @override
  _AjouterImageScreenState createState() => _AjouterImageScreenState();
}

class _AjouterImageScreenState extends State<AjouterImageScreen> {
  String? uploadedImageUrl;
  bool isLoading = false;

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() => isLoading = true);

    final imageFile = File(pickedFile.path);
    final imageBytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    final apiKey = 'b59a8150127df7b88133ea4102d82be5'; // Remplace avec ta clé
    final url = 'https://api.imgbb.com/1/upload?key=$apiKey';

    final response = await http.post(
      Uri.parse(url),
      body: {'image': base64Image},
    );

    final responseData = json.decode(response.body);

    if (responseData['success'] == true) {
      final imageUrl = responseData['data']['url'];

      await FirebaseFirestore.instance.collection('images').add({
        'url': imageUrl,
        'uploadedAt': Timestamp.now(),
      });

      setState(() {
        uploadedImageUrl = imageUrl;
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("✅ Image envoyée avec succès !")));
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Échec de l’envoi")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Ajouter une image"),
        backgroundColor: Color.fromARGB(255, 43, 169, 228),
        elevation: 0,
      ),
      body: Center(
        child:
            isLoading
                ? CircularProgressIndicator()
                : Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.all(24),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Uploader une Image",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 20),
                        if (uploadedImageUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              uploadedImageUrl!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        if (uploadedImageUrl != null) SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: pickAndUploadImage,
                          icon: Icon(Icons.upload_file),
                          label: Text("Choisir et envoyer"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
