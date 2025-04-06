import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:galsen_medic/screens/widgets/custom_bottom_nav.dart';
import 'package:galsen_medic/screens/user_info_card.dart' as card;
import 'package:galsen_medic/screens/weekly_calendar.dart';
import 'package:galsen_medic/screens/consultation_en_cours_widget.dart';
import 'package:galsen_medic/provider/disponibilite_provider.dart';

class UserDetailPage extends StatelessWidget {
  final String fullName;
  final String role;
  final String imageUrl;
  final String email;
  final String phone;
  final int idMedecin;

  const UserDetailPage({
    super.key,
    required this.fullName,
    required this.role,
    required this.imageUrl,
    required this.email,
    required this.phone,
    required this.idMedecin,
  });

  /// 🔍 Normalisation du rôle pour éviter les bugs d’accent
  String _normalize(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'[éèêë]'), 'e');
  }

  bool get isMedecin {
    final normalizedRole = _normalize(role);
    return normalizedRole.contains('medecin');
  }

  bool get isMedecinValide => isMedecin && idMedecin > 0;

  @override
  Widget build(BuildContext context) {
    print("🧪 Rôle reçu : $role → isMedecin=$isMedecin | idMedecin=$idMedecin");

    return ChangeNotifierProvider(
      create: (_) => DisponibiliteProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(color: Colors.black),
          title: const Text(
            'Utilisateur',
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
                email: email,
                phone: phone,
                subService: isMedecin ? 'Cardiologie' : '',
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
              _buildInfoRow('Téléphone', phone),
              if (isMedecin) _buildInfoRow('Sous-service', 'Cardiologie'),
              const SizedBox(height: 24),

              /// ✅ Affiche le calendrier uniquement pour médecins valides
              isMedecinValide
                  ? WeeklyCalendar(idMedecin: idMedecin)
                  : const ConsultationEnCoursWidget(),

              const SizedBox(height: 24),
              if (!isMedecin)
                const Text(
                  'Dossiers médicaux',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF101623),
                  ),
                ),
              if (!isMedecin) const SizedBox(height: 12),
              if (!isMedecin) _buildInfoRow('Email', email),
              if (!isMedecin) _buildInfoRow('Téléphone', phone),
            ],
          ),
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
