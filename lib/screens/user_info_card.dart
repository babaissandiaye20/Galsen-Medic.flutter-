import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  final String imageUrl;
  final String fullName;
  final String role;
  final VoidCallback? onTap;

  const UserInfoCard({
    super.key,
    required this.imageUrl,
    required this.fullName,
    required this.role,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8F3F1)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  imageUrl.isNotEmpty
                      ? FadeInImage.assetNetwork(
                        placeholder:
                            'assets/images/avatar_placeholder.png', // tu peux mettre une image de profil par défaut
                        image: imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        imageErrorBuilder:
                            (_, __, ___) => _buildDefaultAvatar(),
                      )
                      : _buildDefaultAvatar(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF101623),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFADADAD),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 50,
      height: 50,
      color: Colors.grey[300],
      child: const Icon(Icons.person, color: Colors.white),
    );
  }
}
