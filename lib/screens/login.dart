import 'package:flutter/material.dart';
import 'package:galsen_medic/screens/home_admin.dart';
import 'package:galsen_medic/screens/widgets/toastifiee.dart';
import 'package:galsen_medic/services/auth_service.dart';
import 'package:galsen_medic/models/auth_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 64),
              Center(
                child: Image.asset('assets/images/Vector.png', height: 72),
              ),
              const SizedBox(height: 48),
              _buildTextField(
                hintText: 'Enter your email',
                icon: Icons.email_outlined,
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                hintText: 'Enter your password',
                icon: Icons.lock_outline,
                controller: _passwordController,
                obscureText: _obscurePassword,
                suffixIcon:
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                onSuffixTap: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Color(0xFF20D114),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _handleLogin,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF20D114),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Don’t have an account? ",
                        style: TextStyle(
                          color: Color(0xFF707684),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(
                          color: Color(0xFF20D114),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: const [
                  Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Color(0xFFA0A7B0),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                ],
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/google.png', height: 24),
                      const SizedBox(width: 12),
                      const Text(
                        'Sign in with Google',
                        style: TextStyle(
                          color: Color(0xFF101522),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    IconData? suffixIcon,
    bool obscureText = false,
    VoidCallback? onSuffixTap,
    required TextEditingController controller,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9FB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(icon, color: Color(0xFFA0A7B0)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFFA0A7B0),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (suffixIcon != null) ...[
            GestureDetector(
              onTap: onSuffixTap,
              child: Icon(suffixIcon, color: Color(0xFFA0A7B0)),
            ),
            const SizedBox(width: 16),
          ],
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Toastifiee.show(
        context: context,
        message: "Veuillez remplir tous les champs",
        success: false,
      );
      return;
    }

    final authModel = AuthModel(email: email, password: password);
    final success = await auth.login(authModel);

    if (success) {
      Toastifiee.show(
        context: context,
        message: "Connexion réussie",
        success: true,
      );

      final token = await auth.getToken();
      if (token == null) return;

      final payload = auth.decodeJwtPayload(token);
      final privilege = payload['privilege']; // ex: 1 pour Admin

      if (privilege == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeAdminPage()),
        );
      } else {
        // Redirection autre ici si besoin
      }
    } else {
      Toastifiee.show(
        context: context,
        message: "Login ou mot de passe incorrect",
        success: false,
      );
    }
  }
}
