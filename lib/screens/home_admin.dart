import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({Key? key}) : super(key: key);

  @override
  _HomeAdminPageState createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildQuickActions(),
            Expanded(child: _buildTransactionHistory()),
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              children: const [
                TextSpan(text: 'Galsen', style: TextStyle(color: Colors.black)),
                TextSpan(text: 'Medic', style: TextStyle(color: Colors.teal)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search doctor, drugs, articles...',
          hintStyle: GoogleFonts.inter(),
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final List<Map<String, Object>> actions = [
      {'icon': Icons.person_outline, 'label': 'Utilisateur(s)'},
      {'icon': Icons.medical_services_outlined, 'label': 'Service(s)'},
      {'icon': Icons.attach_money, 'label': 'Tarifs'},
      {'icon': Icons.people_outline, 'label': 'Patient(s)'},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            actions.map((action) {
              return Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    radius: 24,
                    child: Icon(
                      action['icon'] as IconData,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action['label'] as String,
                    style: GoogleFonts.inter(fontSize: 12),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildTransactionHistory() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Historique des transactions',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('See all', style: GoogleFonts.inter()),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) {
                return _buildTransactionItem();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/Rectangle460.png',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paiement Laboratoire/Biochimie',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  '2000 F CFA',
                  style: GoogleFonts.inter(
                    color: Colors.teal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Jun 10, 2021 • 12:59',
                  style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, 'Home', true),
          _buildNavItem(Icons.mail_outline, 'Messages', false),
          _buildNavItem(Icons.calendar_today_outlined, 'Calendar', false),
          _buildNavItem(Icons.person_outline, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? Colors.teal : Colors.grey),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: isActive ? Colors.teal : Colors.grey,
          ),
        ),
      ],
    );
  }
}
