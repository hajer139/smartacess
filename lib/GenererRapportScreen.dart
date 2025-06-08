import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class GenererRapportScreen extends StatefulWidget {
  const GenererRapportScreen({super.key});

  @override
  State<GenererRapportScreen> createState() => _GenererRapportScreenState();
}

class _GenererRapportScreenState extends State<GenererRapportScreen> {
  final _nomController = TextEditingController();
  final _uidController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _uidController.dispose();
    super.dispose();
  }

  Future<void> _addHistorique() async {
    if (_nomController.text.isEmpty || _uidController.text.isEmpty) return;

    await FirebaseFirestore.instance.collection('historiques').add({
      'nom': _nomController.text,
      'uid': _uidController.text,
      'timestamp': Timestamp.now(),
    });

    _nomController.clear();
    _uidController.clear();
    setState(() {});
  }

  Future<pw.Document> generatePdfReport(
    List<Map<String, dynamic>> dataList,
  ) async {
    final pdf = pw.Document();

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
              pw.Table.fromTextArray(
                headers: ['Nom', 'UID', 'Date'],
                data:
                    dataList.map((item) {
                      return [
                        item['nom'],
                        item['uid'],
                        DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(item['timestamp']),
                      ];
                    }).toList(),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  Future<void> _genererEtEnvoyerRapport(
    List<Map<String, dynamic>> dataList,
  ) async {
    final pdf = await generatePdfReport(dataList);

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    await FirebaseFirestore.instance.collection('rapports').add({
      'timestamp': Timestamp.now(),
      'data':
          dataList
              .map(
                (item) => {
                  'nom': item['nom'],
                  'uid': item['uid'],
                  'timestamp': Timestamp.fromDate(item['timestamp']),
                },
              )
              .toList(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rapport généré et envoyé à Firestore.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Générer un rapport'),
        backgroundColor: const Color(0xFF2BA9E4),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _nomController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: _uidController,
                  decoration: const InputDecoration(labelText: 'UID'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addHistorique,
                  child: const Text('Ajouter'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('historiques')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Aucune donnée trouvée.'));
                }

                final dataList =
                    snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return {
                        'nom': data['nom'] ?? '',
                        'uid': data['uid'] ?? '',
                        'timestamp': (data['timestamp'] as Timestamp).toDate(),
                      };
                    }).toList();

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          final item = dataList[index];
                          final dateFormatted = DateFormat(
                            'dd/MM/yyyy HH:mm',
                          ).format(item['timestamp']);
                          return ListTile(
                            title: Text(item['nom']),
                            subtitle: Text('UID : ${item['uid']}'),
                            trailing: Text(dateFormatted),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton.icon(
                        onPressed: () => _genererEtEnvoyerRapport(dataList),
                        icon: const Icon(Icons.send),
                        label: const Text('Générer & Envoyer rapport'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2BA9E4),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
