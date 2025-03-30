import 'package:flutter/material.dart';
import 'package:galsen_medic/models/utilisateur.dart';
import 'package:galsen_medic/services/utilisateur_service.dart';
import 'package:galsen_medic/screens/widgets/custom_bottom_nav.dart';
import 'package:galsen_medic/screens/user_info_card.dart' as card;
import 'package:galsen_medic/screens/user_detail_page.dart';

class UtilisateurPage extends StatefulWidget {
  const UtilisateurPage({super.key});

  @override
  State<UtilisateurPage> createState() => _UtilisateurPageState();
}

class _UtilisateurPageState extends State<UtilisateurPage> {
  final UtilisateurService _service = UtilisateurService();
  List<Utilisateur> utilisateurs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUtilisateurs();
  }

  Future<void> fetchUtilisateurs() async {
    try {
      final result = await _service.getUsersWithoutAdminAndClient();
      setState(() {
        utilisateurs = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Utilisateur(s)',
          style: TextStyle(color: Color(0xFF101623)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.all(16),
            child: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : utilisateurs.isEmpty
              ? const Center(child: Text('Aucun utilisateur trouvé.'))
              : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                itemCount: utilisateurs.length,
                itemBuilder: (context, index) {
                  final user = utilisateurs[index];

                  return card.UserInfoCard(
                    fullName: "${user.prenom} ${user.nom}",
                    role: user.privilege.libelle,
                    imageUrl: user.profilUrl ?? '',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => UserDetailPage(
                                fullName: "${user.prenom} ${user.nom}",
                                role: user.privilege.libelle,
                                imageUrl: user.profilUrl ?? '',
                                email: user.email,
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
      bottomNavigationBar: const CustomBottomNavBar(activeIndex: 0),
    );
  }
}
