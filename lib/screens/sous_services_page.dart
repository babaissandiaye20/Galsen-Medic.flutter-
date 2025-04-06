import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:galsen_medic/models/sous_service_model.dart';
import 'package:galsen_medic/provider/sous_service_provider.dart';
import 'package:galsen_medic/screens/widgets/custom_bottom_nav.dart';
import 'package:galsen_medic/screens/add_sous_service_page.dart';
import 'package:galsen_medic/screens/tarif_list_page.dart'; // ✅ IMPORT AJOUTÉ

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
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SousServiceProvider>(
        context,
        listen: false,
      ).fetchSousServices(widget.serviceId);
    });
  }

  void _showAddSousServiceForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddSousServicePage(serviceId: widget.serviceId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SousServiceProvider>(context);
    final sousServices = provider.sousServices;
    final isLoading = provider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sous-services - ${widget.serviceName}',
          style: const TextStyle(color: Color(0xFF101623)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'add') _showAddSousServiceForm();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add',
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Ajouter sous-service'),
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : sousServices.isEmpty
            ? const Center(child: Text("Aucun sous-service disponible."))
            : Wrap(
          spacing: 20,
          runSpacing: 20,
          children: sousServices.map((ss) {
            return _SousServiceCard(
              title: ss.libelle,
              imageUrl: ss.iconUrl,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TarifListPage(
                      idSousService: ss.id,
                      sousServiceName: ss.libelle,
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

class _SousServiceCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final VoidCallback onTap;

  const _SousServiceCard({
    required this.title,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9FB),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageUrl != null && imageUrl!.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl!,
                height: 64,
                width: 64,
                fit: BoxFit.cover,
              ),
            )
                : const Icon(
              Icons.medical_services_outlined,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF101623),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
