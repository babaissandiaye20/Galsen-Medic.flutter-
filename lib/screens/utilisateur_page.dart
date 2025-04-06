import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:galsen_medic/provider/utilisateur_provider.dart';
import 'package:galsen_medic/screens/widgets/custom_bottom_nav.dart';
import 'package:galsen_medic/screens/user_info_card.dart' as card;
import 'package:galsen_medic/screens/user_detail_page.dart';
import 'package:galsen_medic/screens/add_utilisateur_page.dart';

class UtilisateurPage extends StatefulWidget {
  const UtilisateurPage({super.key});

  @override
  State<UtilisateurPage> createState() => _UtilisateurPageState();
}

class _UtilisateurPageState extends State<UtilisateurPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UtilisateurProvider>(context, listen: false)
          .fetchUtilisateurs();
    });
  }

  void _showAddUserForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddUtilisateurPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UtilisateurProvider>(context);
    final utilisateurs = provider.utilisateurs;
    final isLoading = provider.isLoading;

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
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'add') _showAddUserForm();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add',
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Ajouter utilisateur'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : utilisateurs.isEmpty
          ? const Center(child: Text("Aucun utilisateur trouvé."))
          : ListView.builder(
        padding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: utilisateurs.length,
        itemBuilder: (context, index) {
          final user = utilisateurs[index];
          final isMedecin = user.privilege.libelle.toLowerCase() == 'medecin';

          return card.UserInfoCard(
            fullName: "${user.prenom} ${user.nom}",
            role: user.privilege.libelle,
            imageUrl: user.profilUrl ?? '',
            email: user.email,
            phone: user.telephone ?? '',
            subService: '',
            minimal: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserDetailPage(
                    fullName: "${user.prenom} ${user.nom}",
                    role: user.privilege.libelle,
                    imageUrl: user.profilUrl ?? '',
                    email: user.email,
                    phone: user.telephone ?? '',
                    idMedecin: isMedecin ? user.id : 0, // 👈 Important
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
