import 'dart:io';
import 'package:flutter/material.dart';
import 'package:galsen_medic/services/sous_service_api.dart';
import 'package:galsen_medic/models/sous_service_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:galsen_medic/provider/sous_service_provider.dart';
import 'package:galsen_medic/screens/widgets/toastifiee.dart';

class AddSousServicePage extends StatefulWidget {
  final int serviceId;

  const AddSousServicePage({super.key, required this.serviceId});

  @override
  State<AddSousServicePage> createState() => _AddSousServicePageState();
}

class _AddSousServicePageState extends State<AddSousServicePage> {
  final _libelle = TextEditingController();
  File? _image;
  final _api = SousServiceApi();

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  void _removeImage() => setState(() => _image = null);

  Future<void> _handleSubmit() async {
    if (_libelle.text.trim().isEmpty) {
      Toastifiee.show(
        context: context,
        message: "Libellé requis",
        success: false,
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final sousService = await _api.createSousService(
        libelle: _libelle.text.trim(),
        idService: widget.serviceId,
        icon: _image,
      );

      if (!mounted) return;
      Navigator.pop(context); // Close loading

      Provider.of<SousServiceProvider>(
        context,
        listen: false,
      ).addSousService(sousService);
      Toastifiee.show(
        context: context,
        message: "Sous-service ajouté",
        success: true,
      );
      Navigator.pop(context); // Back to list
    } catch (e) {
      Navigator.pop(context);
      Toastifiee.show(context: context, message: e.toString(), success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un sous-service"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: _libelle,
            decoration: const InputDecoration(
              hintText: 'Nom du sous-service',
              prefixIcon: Icon(Icons.medical_services),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildImageUploader(),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _handleSubmit,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF20D114),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Center(
                child: Text(
                  'Créer',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploader() {
    return GestureDetector(
      onTap: _image == null ? _pickImage : null,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9FB),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Stack(
          children: [
            Center(
              child:
                  _image == null
                      ? const Icon(
                        Icons.upload_file,
                        size: 40,
                        color: Colors.grey,
                      )
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
            ),
            if (_image != null)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: _removeImage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
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
