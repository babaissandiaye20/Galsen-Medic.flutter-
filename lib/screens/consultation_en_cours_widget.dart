import 'package:flutter/material.dart';

class ConsultationEnCoursWidget extends StatelessWidget {
  const ConsultationEnCoursWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Consultation en cours',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF101623),
          ),
        ),
        const SizedBox(height: 16),
        _infoTile('Date', 'Lundi 31 Mars 2025'),
        _infoTile('Heure', '14:30'),
        _infoTile('Service', 'Cardiologie'),
        _infoTile('Médecin', 'Dr Marcus Horizon'),
      ],
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF717784)),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF101623),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
