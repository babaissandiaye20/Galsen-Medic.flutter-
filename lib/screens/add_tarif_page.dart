import 'package:flutter/material.dart';
import '../services/devise_service.dart';
import '../services/tarif_service.dart';
import '../models/devise_model.dart';
import 'widgets/toastifiee.dart';

class AddTarifPage extends StatefulWidget {
  final int idSousService;

  const AddTarifPage({super.key, required this.idSousService});

  @override
  State<AddTarifPage> createState() => _AddTarifPageState();
}

class _AddTarifPageState extends State<AddTarifPage> {
  final _montantController = TextEditingController();
  final _deviseService = DeviseService(baseUrl: 'http://localhost:3000');
  final _tarifService = TarifService(baseUrl: 'http://localhost:3000');

  List<DeviseModel> _devises = [];
  DeviseModel? _selectedDevise;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDevises();
  }

  Future<void> _loadDevises() async {
    try {
      final devises = await _deviseService.fetchDevises();
      setState(() => _devises = devises);
    } catch (e) {
      Toastifiee.show(context: context, message: 'Erreur : $e', success: false);
    }
  }

  Future<void> _handleSubmit() async {
    final montant = double.tryParse(_montantController.text);
    if (montant == null || _selectedDevise == null) {
      Toastifiee.show(context: context, message: 'Tous les champs sont requis.', success: false);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _tarifService.createTarif(
        idSousService: widget.idSousService,
        idDevise: _selectedDevise!.id,
        montant: montant,
      );

      if (!mounted) return;
      Toastifiee.show(context: context, message: 'Tarif ajouté avec succès', success: true);
      Navigator.pop(context);
    } catch (e) {
      Toastifiee.show(context: context, message: e.toString(), success: false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un tarif'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: _montantController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Montant',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<DeviseModel>(
            value: _selectedDevise,
            items: _devises.map((devise) {
              return DropdownMenuItem(
                value: devise,
                child: Text('${devise.libelle} (${devise.symbole})'),
              );
            }).toList(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
              hintText: 'Sélectionner une devise',
            ),
            onChanged: (val) => setState(() => _selectedDevise = val),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF20D114),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Créer', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
