import 'package:flutter/material.dart';
import 'package:galsen_medic/models/service_model.dart';
import 'package:galsen_medic/screens/sous_services_page.dart';
import 'package:galsen_medic/screens/widgets/custom_bottom_nav.dart';
import 'package:galsen_medic/screens/widgets/service_card.dart';
import 'package:galsen_medic/services/service_api.dart';
import 'package:galsen_medic/services/auth_service.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final ServiceApi _serviceApi = ServiceApi();
  final AuthService _authService = AuthService();
  late Future<List<ServiceModel>> _futureServices;

  @override
  void initState() {
    super.initState();
    _futureServices = _loadServices();
  }

  Future<List<ServiceModel>> _loadServices() async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception("Utilisateur non connecté.");
    }
    return _serviceApi.fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Service(s)",
          style: TextStyle(color: Color(0xFF101623)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: FutureBuilder<List<ServiceModel>>(
          future: _futureServices,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Erreur : ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Aucun service disponible."));
            }

            final services = snapshot.data!;
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children:
                  services.map((service) {
                    return ServiceCard(
                      title: service.libelle,
                      imageUrl: service.iconUrl,
                      tag: 'Covid-19',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => SousServicesPage(
                                  serviceId: service.id,
                                  serviceName: service.libelle,
                                ),
                          ),
                        );
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
