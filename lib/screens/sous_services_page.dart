import 'package:flutter/material.dart';
import 'package:galsen_medic/models/sous_service_model.dart';
import 'package:galsen_medic/screens/widgets/custom_bottom_nav.dart';
import 'package:galsen_medic/screens/widgets/service_card.dart';
import 'package:galsen_medic/services/sous_service_api.dart';
import 'package:galsen_medic/services/auth_service.dart';

class SousServicesPage extends StatefulWidget {
  final int serviceId;
  final String serviceName;

  const SousServicesPage({
    super.key,
    required this.serviceId,
    required this.serviceName,
  });

  @override
  State<SousServicesPage> createState() => _SousServicesPageState();
}

class _SousServicesPageState extends State<SousServicesPage> {
  final SousServiceApi _sousServiceApi = SousServiceApi();
  final AuthService _authService = AuthService();
  late Future<List<SousServiceModel>> _futureSousServices;

  @override
  void initState() {
    super.initState();
    _futureSousServices = _loadSousServices();
  }

  Future<List<SousServiceModel>> _loadSousServices() async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception("Utilisateur non connecté.");
    }
    return _sousServiceApi.fetchSousServices(widget.serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.serviceName,
          style: const TextStyle(color: Color(0xFF101623)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: FutureBuilder<List<SousServiceModel>>(
          future: _futureSousServices,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Erreur : ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("Aucun sous-service disponible."),
              );
            }

            final sousServices = snapshot.data!;
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children:
                  sousServices.map((sous) {
                    return ServiceCard(
                      title: sous.libelle,
                      imageUrl: sous.iconUrl,
                      tag: 'Disponible',
                      onTap: () {
                        // Action à définir
                      },
                    );
                  }).toList(),
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(activeIndex: 0),
    );
  }
}
