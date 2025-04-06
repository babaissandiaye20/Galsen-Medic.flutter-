import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:galsen_medic/provider/disponibilite_provider.dart';
import 'package:galsen_medic/models/disponibilite_model.dart';

class WeeklyCalendar extends StatefulWidget {
  final int idMedecin;

  const WeeklyCalendar({super.key, required this.idMedecin});

  @override
  State<WeeklyCalendar> createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  String selectedDay = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<DisponibiliteProvider>(context, listen: false)
          .fetchDisponibilites(widget.idMedecin);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DisponibiliteProvider>(context);
    final disponibilites = provider.disponibilites;

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (disponibilites.isEmpty) {
      return const Center(child: Text("Aucune disponibilité trouvée."));
    }

    selectedDay = selectedDay.isEmpty
        ? disponibilites.first.jourSemaine
        : selectedDay;

    final jours = disponibilites.map((e) => e.jourSemaine).toList();
    final current = disponibilites.firstWhere(
          (d) => d.jourSemaine == selectedDay,
      orElse: () => disponibilites.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Semaine en cours',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF101623),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: jours.length,
            itemBuilder: (context, index) {
              final jour = jours[index];
              final isSelected = jour == selectedDay;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDay = jour;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF199A8E) : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFFE8F3F1),
                      width: isSelected ? 0 : 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _capitalize(jour),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF101623),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        if (current.horairesDisponibles.isEmpty)
          const Text("Aucun créneau disponible ce jour-là.")
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _buildTimeSlots(current),
          ),
      ],
    );
  }

  List<Widget> _buildTimeSlots(Disponibilite dispo) {
    return dispo.horairesDisponibles.map((slot) {
      return Container(
        width: 103,
        height: 37,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFB3D3CE)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          slot,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF101623),
          ),
        ),
      );
    }).toList();
  }

  String _capitalize(String value) {
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }
}
