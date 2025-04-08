import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:galsen_medic/models/utilisateur.dart';
import 'package:galsen_medic/services/utilisateur_service.dart';
import 'package:galsen_medic/screens/widgets/custom_bottom_nav.dart';
import 'package:galsen_medic/screens/widgets/confirmation_dialog.dart';
import 'package:galsen_medic/screens/login.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  Utilisateur? _utilisateur;
  final UtilisateurService _utilisateurService = UtilisateurService();

  @override
  void initState() {
    super.initState();
    _loadUtilisateur();
  }

  Future<void> _loadUtilisateur() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    final parts = token.split('.');
    if (parts.length != 3) return;

    final payload = parts[1];
    final normalized = base64.normalize(payload);
    final decoded = utf8.decode(base64.decode(normalized));
    final data = json.decode(decoded);

    final email = data['email'];
    if (email == null) return;

    final utilisateur = await _utilisateurService.getUtilisateurByEmail(email);

    setState(() {
      _utilisateur = utilisateur;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF52D1C6),
      body: Stack(
        children: [
          _buildBackground(),
          _buildWhiteContainer(),
          _buildProfileHeader(),
          const Positioned(top: 230, left: 0, right: 0, child: _MetricsSection()),
          Positioned(top: 370, left: 0, right: 0, child: _OptionsList()),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(activeIndex: 3),
    );
  }

  Widget _buildBackground() => Container(
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment(0.5, 0),
        end: Alignment(-0.0, 0.47),
        colors: [Color(0xFF52D1C6), Color(0xFF30ADA2)],
      ),
    ),
  );

  Widget _buildWhiteContainer() => Positioned(
    top: 353,
    left: 0,
    right: 0,
    child: Container(
      height: 459,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
    ),
  );

  Widget _buildProfileHeader() {
    final imageUrl = _utilisateur?.profilUrl ?? "https://placehold.co/80x80";
    final fullName = _utilisateur != null
        ? "${_utilisateur!.prenom} ${_utilisateur!.nom}"
        : "Chargement...";
    final email = _utilisateur?.email ?? "";
    final role = _utilisateur?.privilege.libelle ?? "";

    return Positioned(
      top: 100,
      left: 0,
      right: 0,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(height: 12),
          Text(
            fullName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsSection extends StatelessWidget {
  const _MetricsSection();

  @override
  Widget build(BuildContext context) {
    const metricStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    const labelStyle = TextStyle(
      color: Color(0xFFC0F3EE),
      fontSize: 10,
      fontWeight: FontWeight.w600,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: const [
            Text('215bpm', style: metricStyle),
            SizedBox(height: 4),
            Text('Heart rate', style: labelStyle),
          ],
        ),
        Container(height: 44, width: 1, color: Color(0xFFC0F3EE)),
        Column(
          children: const [
            Text('756cal', style: metricStyle),
            SizedBox(height: 4),
            Text('Calories', style: labelStyle),
          ],
        ),
        Container(height: 44, width: 1, color: Color(0xFFC0F3EE)),
        Column(
          children: const [
            Text('103lbs', style: metricStyle),
            SizedBox(height: 4),
            Text('Weight', style: labelStyle),
          ],
        ),
      ],
    );
  }
}

class _OptionsList extends StatelessWidget {
  const _OptionsList();

  Widget _buildTile(String title, IconData icon,
      {bool isLogout = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE8F3F1),
                  ),
                  child: Icon(icon, color: Colors.black54, size: 24),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color:
                      isLogout ? Color(0xFFFF5C5C) : Color(0xFF101623),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey),
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color(0xFFE8F3F1),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTile('My Saved', Icons.bookmark_border),
        _buildTile('Appointment', Icons.calendar_today_outlined),
        _buildTile('Payment Method', Icons.credit_card),
        _buildTile('FAQs', Icons.help_outline),
        _buildTile('Logout', Icons.logout, isLogout: true, onTap: () {
          showDialog(
            context: context,
            builder: (context) => ConfirmationDialog(
              title: 'Are you sure to log out of your account?',
              icon: Icons.logout,
              confirmText: 'Log Out',
              cancelText: 'Cancel',
              onConfirm: () async {
                Navigator.pop(context); // Ferme le dialog

                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                );
              },
              onCancel: () => Navigator.pop(context),
            ),
          );
        }),
      ],
    );
  }
}
