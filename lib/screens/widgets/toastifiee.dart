import 'package:flutter/material.dart';

class Toastifiee {
  static void show({
    required BuildContext context,
    required String message,
    required bool success,
  }) {
    final color = success ? Colors.green : Colors.red;

    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(left: BorderSide(width: 6, color: color)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message,
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 3), () {
      entry.remove();
    });
  }
}
