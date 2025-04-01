import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:galsen_medic/models/service_model.dart';
import 'package:galsen_medic/screens/sous_services_page.dart';
import 'package:galsen_medic/screens/widgets/custom_bottom_nav.dart';
import 'package:galsen_medic/screens/widgets/service_card.dart';
import 'package:galsen_medic/screens/add_service_page.dart';
import 'package:galsen_medic/provider/service_provider.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ServiceProvider>(context, listen: false).fetchServices();
    });
  }

  void _showAddServiceForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddServicePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ServiceProvider>(context);
    final services = provider.services;
    final isLoading = provider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Service(s)",
          style: TextStyle(color: Color(0xFF101623)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'add') {
                _showAddServiceForm();
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'add',
                    child: Row(
                      children: [
                        Icon(Icons.add, color: Colors.black),
                        SizedBox(width: 8),
                        Text('Ajouter service'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(14),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : services.isEmpty
                ? const Center(child: Text("Aucun service disponible."))
                : Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children:
                      services.map((service) {
                        return ServiceCard(
                          title: service.libelle,
                          imageUrl: service.iconUrl,
                          tag: 'Covid-19', // 🔁 à personnaliser si besoin
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
                ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(activeIndex: 0),
    );
  }
}
