import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:image_picker/image_picker.dart';
import 'package:galsen_medic/screens/onboarding.dart';
import 'package:galsen_medic/screens/login.dart';
import 'package:galsen_medic/screens/widgets/form.dart';
import 'package:galsen_medic/screens/widgets/toastifiee.dart';
import 'package:galsen_medic/services/register_client.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nom = TextEditingController();
  final TextEditingController _prenom = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _telephone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  void _handleRegister() async {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

    if (!emailRegex.hasMatch(_email.text.trim())) {
      Toastifiee.show(
        context: context,
        message: "Email invalide",
        success: false,
      );
      return;
    }

    if (_password.text != _confirmPassword.text) {
      Toastifiee.show(
        context: context,
        message: "Les mots de passe ne correspondent pas",
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

      final response = await RegisterClientService.register(
        nom: _nom.text.trim(),
        prenom: _prenom.text.trim(),
        email: _email.text.trim(),
        telephone: _telephone.text.trim(),
        password: _password.text,
        image: _imageFile,
      );

      Navigator.pop(context);

      if (response.statusCode == 201) {
        Toastifiee.show(
          context: context,
          message: "Inscription réussie 🎉",
          success: true,
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        });
      } else {
        final body = jsonDecode(response.body);
        Toastifiee.show(
          context: context,
          message: body['message'] ?? "Erreur lors de l'inscription",
          success: false,
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Toastifiee.show(
        context: context,
        message: e.toString().replaceAll('Exception: ', ''),
        success: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const OnboardingPage()),
            );
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 8),
              Center(
                child: Column(
                  children: const [
                    Text(
                      'Galsen',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Medic',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF20D114),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomFormField(
                hintText: 'Nom',
                icon: Icons.person_outline,
                controller: _nom,
              ),
              CustomFormField(
                hintText: 'Prénom',
                icon: Icons.person,
                controller: _prenom,
              ),
              CustomFormField(
                hintText: 'Email',
                icon: Icons.email_outlined,
                controller: _email,
                inputType: TextInputType.emailAddress,
              ),
              CustomFormField(
                hintText: 'Téléphone',
                icon: Icons.phone_outlined,
                controller: _telephone,
                inputType: TextInputType.phone,
              ),
              CustomFormField(
                hintText: 'Mot de passe',
                icon: Icons.lock_outline,
                controller: _password,
                obscureText: true,
              ),
              CustomFormField(
                hintText: 'Confirmer le mot de passe',
                icon: Icons.lock,
                controller: _confirmPassword,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              _buildImageUploader(),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _handleRegister,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF20D114),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Center(
                    child: Text(
                      'S’inscrire',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Vous avez déjà un compte ? ",
                        style: TextStyle(
                          color: Color(0xFF707684),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: "Se connecter",
                        style: const TextStyle(
                          color: Color(0xFF20D114),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginPage(),
                                  ),
                                );
                              },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploader() {
    return GestureDetector(
      onTap: _imageFile == null ? _pickImage : null,
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
                  _imageFile == null
                      ? const Icon(
                        Icons.upload_file,
                        size: 40,
                        color: Colors.grey,
                      )
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
            ),
            if (_imageFile != null)
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
