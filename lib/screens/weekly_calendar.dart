import 'package:flutter/material.dart';

class WeeklyCalendar extends StatelessWidget {
  const WeeklyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
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

        // === Jours de la semaine ===
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(7, (index) {
              final isToday =
                  index == 2; // Ex : mercredi sélectionné par défaut
              final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              final numbers = ['21', '22', '23', '24', '25', '26', '27'];

              return Container(
                margin: const EdgeInsets.only(right: 8),
                width: 46,
                height: 64,
                decoration: ShapeDecoration(
                  color: isToday ? const Color(0xFF199A8E) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: const Color(0xFFE8F3F1),
                      width: isToday ? 0 : 1,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      days[index],
                      style: TextStyle(
                        color: isToday ? Colors.white : const Color(0xFFA0A7B0),
                        fontSize: 10,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      numbers[index],
                      style: TextStyle(
                        color: isToday ? Colors.white : const Color(0xFF101623),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 24),

        // === Créneaux horaires ===
        Wrap(spacing: 12, runSpacing: 12, children: _buildTimeSlots()),
      ],
    );
  }

  List<Widget> _buildTimeSlots() {
    final List<Map<String, dynamic>> slots = [
      {'time': '09:00 AM', 'active': false},
      {'time': '10:00 AM', 'active': true},
      {'time': '11:00 AM', 'active': false},
      {'time': '01:00 PM', 'active': false},
      {'time': '02:00 PM', 'active': true},
      {'time': '03:00 PM', 'active': false},
      {'time': '04:00 PM', 'active': true},
      {'time': '07:00 PM', 'active': true},
      {'time': '08:00 PM', 'active': false},
    ];

    return slots.map((slot) {
      final isSelected = slot['active'] as bool;
      return Container(
        width: 103,
        height: 37,
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF199A8E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: isSelected ? Colors.transparent : const Color(0xFFB3D3CE),
              width: 1,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          slot['time'],
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF101623),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontFamily: 'Inter',
          ),
        ),
      );
    }).toList();
  }
}
