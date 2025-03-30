import 'package:flutter/material.dart';
import 'package:galsen_medic/screens/widgets/custom_bottom_nav.dart';
import 'package:galsen_medic/screens/user_info_card.dart' as card;

class UserDetailPage extends StatelessWidget {
  final String fullName;
  final String role;
  final String imageUrl;
  final String email;

  const UserDetailPage({
    super.key,
    required this.fullName,
    required this.role,
    required this.imageUrl,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Utilisateur(s)',
          style: TextStyle(
            color: Color(0xFF101623),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(16),
            child: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(activeIndex: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        child: ListView(
          children: [
            card.UserInfoCard(
              fullName: fullName,
              role: role,
              imageUrl: imageUrl,
            ),
            const SizedBox(height: 24),
            const Text(
              'À propos',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF101623),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lorem ipsum dolor sit amet...',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF717784),
                height: 1.8,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Informations',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF101623),
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Email', email),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
