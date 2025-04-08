import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int activeIndex;

  const CustomBottomNavBar({Key? key, this.activeIndex = 0}) : super(key: key);

  void _handleTap(BuildContext context, int index) {
    if (index == activeIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/homeAdmin');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cette section n'est pas encore disponible."),
            backgroundColor: Colors.teal,
            duration: Duration(seconds: 2),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.mail_outline, 'label': 'Messages'},
      {'icon': Icons.calendar_today_outlined, 'label': 'Calendar'},
      {'icon': Icons.person_outline, 'label': 'Profile'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final bool isActive = index == activeIndex;

          return GestureDetector(
            onTap: () => _handleTap(context, index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item['icon'] as IconData,
                  color: isActive ? Colors.teal : Colors.grey,
                ),
                const SizedBox(height: 4),
                Text(
                  item['label'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? Colors.teal : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
