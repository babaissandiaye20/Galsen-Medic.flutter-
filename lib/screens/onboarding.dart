import 'package:flutter/material.dart';
import 'package:galsen_medic/screens/login.dart';
import 'package:galsen_medic/screens/register.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Positioned(
            top: 219,
            left: 74,
            child: Text(
              'Galsen',
              style: TextStyle(
                fontSize: 64,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Positioned(
            top: 281,
            left: 174,
            child: Text(
              'Medic',
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: Color(0xFF20D114),
              ),
            ),
          ),
          const Positioned(
            top: 352,
            left: 32,
            right: 32,
            child: Text(
              'Let’s get started!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF101522),
              ),
            ),
          ),
          const Positioned(
            top: 391,
            left: 32,
            right: 32,
            child: Text(
              'Login to enjoy the features we’ve provided, and stay healthy!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Color(0xFF707684)),
            ),
          ),
          Positioned(
            top: 506,
            left: 28,
            right: 28,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF20D114),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                minimumSize: const Size.fromHeight(56),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: const Text('Login'),
            ),
          ),
          Positioned(
            top: 578,
            left: 28,
            right: 28,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF20D114)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                minimumSize: const Size.fromHeight(56),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(color: Color(0xFF20D114)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
