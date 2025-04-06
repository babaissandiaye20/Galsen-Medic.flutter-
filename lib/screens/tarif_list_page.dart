import 'package:flutter/material.dart';
import 'package:galsen_medic/models/tarif_model.dart';
import 'package:galsen_medic/services/tarif_service.dart';
import 'package:galsen_medic/screens/add_tarif_page.dart';

class TarifListPage extends StatefulWidget {
  final int idSousService;
  final String sousServiceName;

  const TarifListPage({
    super.key,
    required this.idSousService,
    required this.sousServiceName,
  });

  @override
  State<TarifListPage> createState() => _TarifListPageState();
}

class _TarifListPageState extends State<TarifListPage> {
  final TarifService _service = TarifService(baseUrl: 'http://localhost:3000');
  List<TarifModel> tarifs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTarifs();
  }

  Future<void> _loadTarifs() async {
    setState(() => isLoading = true);
    try {
      final data = await _service.fetchTarifsBySousService(widget.idSousService);
      setState(() {
        tarifs = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  Future<void> _toggleTarif(TarifModel tarif) async {
    try {
      if (tarif.actif) {
        await _service.deactivateTarif(tarif.id);
      } else {
        await _service.activateTarif(tarif.id);
      }
      _loadTarifs();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur d'action: $e")),
      );
    }
  }

  void _showAddTarifForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTarifPage(idSousService: widget.idSousService),
      ),
    );
    if (result != null) {
      _loadTarifs(); // refresh after add
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tarifs - ${widget.sousServiceName}"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'add') _showAddTarifForm();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add',
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Ajouter tarif'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tarifs.isEmpty
          ? const Center(child: Text("Aucun tarif disponible."))
          : ListView.builder(
        itemCount: tarifs.length,
        itemBuilder: (context, index) {
          final tarif = tarifs[index];
          return ListTile(
            title: Text(
              "${tarif.montant.toStringAsFixed(0)} ${tarif.deviseCode}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Checkbox(
              value: tarif.actif,
              onChanged: (_) => _toggleTarif(tarif),
            ),
          );
        },
      ),
    );
  }
}
