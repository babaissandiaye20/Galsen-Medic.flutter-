import 'package:flutter/material.dart';
import 'package:galsen_medic/models/utilisateur.dart';
import 'package:galsen_medic/services/utilisateur_service.dart';
import 'package:galsen_medic/screens/widgets/custom_bottom_nav.dart';
import 'package:galsen_medic/screens/user_info_card.dart' as card;
import 'package:galsen_medic/screens/user_detail_page.dart';

class UtilisateurPatientPage extends StatefulWidget {
  const UtilisateurPatientPage({super.key});

  @override
  State<UtilisateurPatientPage> createState() => _UtilisateurPatientPageState();
}

class _UtilisateurPatientPageState extends State<UtilisateurPatientPage> {
  final UtilisateurService _service = UtilisateurService();
  List<Utilisateur> patients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      final result = await _service.getClients(); // ← appel direct aux clients
      setState(() {
        patients = result;
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
          'Patient(s)',
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
              : patients.isEmpty
              ? const Center(child: Text('Aucun patient trouvé.'))
              : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  return card.UserInfoCard(
                    fullName: "${patient.prenom} ${patient.nom}",
                    role: patient.privilege.libelle,
                    imageUrl: patient.profilUrl ?? '',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => UserDetailPage(
                                fullName: "${patient.prenom} ${patient.nom}",
                                role: patient.privilege.libelle,
                                imageUrl: patient.profilUrl ?? '',
                                email: patient.email,
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
