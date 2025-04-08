import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final IconData icon;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.onConfirm,
    required this.onCancel,
    this.confirmText = "Confirm",
    this.cancelText = "Cancel",
    this.icon = Icons.logout,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Container(
        width: 327,
        height: 434,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
        child: Column(
          children: [
            Container(
              width: 103,
              height: 103,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF4F7FF),
              ),
              child: Icon(icon, size: 48, color: Color(0xFF199A8E)),
            ),
            const SizedBox(height: 40),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF101623),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 183,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF199A8E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                onPressed: onConfirm,
                child: Text(
                  confirmText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: onCancel,
              child: Text(
                cancelText,
                style: const TextStyle(
                  color: Color(0xFF199A8E),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
