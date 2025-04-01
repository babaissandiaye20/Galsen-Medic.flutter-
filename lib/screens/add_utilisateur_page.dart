import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:galsen_medic/screens/widgets/form.dart';
import 'package:galsen_medic/screens/widgets/toastifiee.dart';
import 'package:galsen_medic/services/utilisateur_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:galsen_medic/provider/utilisateur_provider.dart';
import 'package:galsen_medic/screens/utilisateur_page.dart';
import 'package:galsen_medic/screens/utilisateur_patient_page.dart';

class AddUtilisateurPage extends StatefulWidget {
  const AddUtilisateurPage({super.key});

  @override
  State<AddUtilisateurPage> createState() => _AddUtilisateurPageState();
}

class _AddUtilisateurPageState extends State<AddUtilisateurPage> {
  final _nom = TextEditingController();
  final _prenom = TextEditingController();
  final _email = TextEditingController();
  final _telephone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  int? _selectedPrivilegeId;
  List<Map<String, dynamic>> _privileges = [];
  File? _image;

  final _service = UtilisateurService();

  @override
  void initState() {
    super.initState();
    _loadPrivileges();
  }

  Future<void> _loadPrivileges() async {
    final res = await _service.getPrivileges();
    setState(() => _privileges = res);
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  void _removeImage() => setState(() => _image = null);

  void _handleSubmit() async {
    if (_password.text != _confirmPassword.text) {
      Toastifiee.show(
        context: context,
        message: "Mots de passe différents",
        success: false,
      );
      return;
    }

    if (_selectedPrivilegeId == null) {
      Toastifiee.show(
        context: context,
        message: "Sélectionnez un privilège",
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

      final user = await _service.createUtilisateur(
        nom: _nom.text.trim(),
        prenom: _prenom.text.trim(),
        email: _email.text.trim(),
        telephone: _telephone.text.trim(),
        password: _password.text,
        idPrivilege: _selectedPrivilegeId!,
        image: _image,
      );

      print("🧾 Utilisateur créé: ${user.toJson()}");

      if (!mounted) return;
      Navigator.pop(context); // Ferme le loader

      Toastifiee.show(
        context: context,
        message: "Utilisateur ajouté",
        success: true,
      );

      Provider.of<UtilisateurProvider>(
        context,
        listen: false,
      ).addUtilisateur(user);

      // Redirection en fonction du rôle
      if (user.privilege.libelle == 'Client') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UtilisateurPatientPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UtilisateurPage()),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Ferme le loader
      String message = "Une erreur est survenue";

      try {
        final parsed = jsonDecode(e.toString().replaceAll('Exception: ', ''));
        if (parsed is Map && parsed['message'] != null) {
          message = parsed['message'];
        }
      } catch (_) {
        message = e.toString().replaceAll('Exception: ', '');
      }

      Toastifiee.show(context: context, message: message, success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un utilisateur"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            CustomFormField(
              hintText: 'Nom',
              icon: Icons.person,
              controller: _nom,
            ),
            CustomFormField(
              hintText: 'Prénom',
              icon: Icons.person,
              controller: _prenom,
            ),
            CustomFormField(
              hintText: 'Email',
              icon: Icons.email,
              controller: _email,
            ),
            CustomFormField(
              hintText: 'Téléphone',
              icon: Icons.phone,
              controller: _telephone,
            ),
            CustomFormField(
              hintText: 'Mot de passe',
              icon: Icons.lock,
              controller: _password,
              obscureText: true,
            ),
            CustomFormField(
              hintText: 'Confirmer le mot de passe',
              icon: Icons.lock_outline,
              controller: _confirmPassword,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: _selectedPrivilegeId,
              hint: const Text("Choisir un privilège"),
              items:
                  _privileges.map<DropdownMenuItem<int>>((p) {
                    return DropdownMenuItem(
                      value: p['id'],
                      child: Text(p['libelle']),
                    );
                  }).toList(),
              onChanged:
                  (value) => setState(() => _selectedPrivilegeId = value),
            ),
            const SizedBox(height: 16),
            _buildImageUploader(),
            const SizedBox(height: 16),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploader() {
    return GestureDetector(
      onTap: _image == null ? _pickImage : null,
      child: Container(
        height: 250,
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
