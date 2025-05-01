import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class GenererRapportScreen extends StatelessWidget {
  Future<pw.Document> generatePdfReport() async {
    final pdf = pw.Document();

    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('historique')
            .orderBy('timestamp', descending: true)
            .get();

    final List<pw.Widget> rows = [];

    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      final nom = data['nom'] ?? '';
      final uid = data['uid'] ?? '';
      final timestamp =
          data['timestamp'] != null
              ? (data['timestamp'] as Timestamp).toDate()
              : DateTime.now();

      final dateFormatted = DateFormat('dd/MM/yyyy HH:mm').format(timestamp);

      rows.add(pw.Text('Nom: $nom | UID: $uid | Date: $dateFormatted'));
      rows.add(pw.SizedBox(height: 5));
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Rapport des Entrées/Sorties',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              ...rows,
            ],
          );
        },
      ),
    );

    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Générer un rapport'),
        backgroundColor: const Color.fromARGB(255, 27, 145, 180),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final pdf = await generatePdfReport();
            await Printing.layoutPdf(
              onLayout: (PdfPageFormat format) async => pdf.save(),
            );
          },
          child: Text('Générer et imprimer le rapport'),
        ),
      ),
    );
  }
}
