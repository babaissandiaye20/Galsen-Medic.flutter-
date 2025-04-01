import 'dart:io';
import 'package:flutter/material.dart';
import 'package:galsen_medic/services/utilisateur_service.dart';
import 'package:galsen_medic/screens/widgets/form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:galsen_medic/provider/utilisateur_provider.dart';
import 'package:galsen_medic/screens/widgets/toastifiee.dart';

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
  File? _image;
  final _service = UtilisateurService();
  List<Map<String, dynamic>> _privileges = [];

  @override
  void initState() {
    super.initState();
    _loadPrivileges();
  }

  Future<void> _loadPrivileges() async {
    final res = await _service.getPrivileges();
    setState(() {
      _privileges = res;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
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

      if (mounted) {
        Navigator.pop(context); // Close loading
        Toastifiee.show(
          context: context,
          message: "Utilisateur ajouté",
          success: true,
        );
        Provider.of<UtilisateurProvider>(
          context,
          listen: false,
        ).addUtilisateur(user);
        Navigator.pop(context); // Ferme le bottom sheet
      }
    } catch (e) {
      Navigator.pop(context); // Close loading
      Toastifiee.show(context: context, message: e.toString(), success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // important
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Ajouter un utilisateur",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
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
                      return DropdownMenuItem<int>(
                        value: p['id'] as int,
                        child: Text(p['libelle']),
                      );
                    }).toList(),
                onChanged:
                    (value) => setState(() => _selectedPrivilegeId = value),
              ),
              const SizedBox(height: 12),
              _image == null
                  ? ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text("Ajouter une image"),
                  )
                  : Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.file(_image!, height: 200, fit: BoxFit.cover),
                      IconButton(
                        onPressed: _removeImage,
                        icon: const Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF20D114),
                ),
                child: const Text(
                  "Créer",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
