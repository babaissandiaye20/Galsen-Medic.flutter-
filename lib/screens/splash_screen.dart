import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:galsen_medic/screens/onboarding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:galsen_medic/screens/home_admin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _curveController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool _showCurves = false;

  @override
  void initState() {
    super.initState();

    // 🟢 Animation du texte avec effet pulse répétitif
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 🟡 Bandes animées
    _curveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    Timer(const Duration(milliseconds: 1200), () {
      setState(() => _showCurves = true);
      _curveController.forward();
    });

    /*  Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeAdminPage()),
      );
    }); */
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingPage()),
      );
    });
  }

  @override
  void dispose() {
    _curveController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 🎨 Courbes avec animation
          if (_showCurves)
            AnimatedBuilder(
              animation: _curveController,
              builder:
                  (_, __) => CustomPaint(
                    size: screen,
                    painter: CurvedSplashPainter(
                      progress: _curveController.value,
                    ),
                  ),
            ),

          // ⭐ Étoile bien visible
          if (_showCurves)
            Positioned(
              left: screen.width * 0.34,
              top: screen.height * 0.26,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: _curveController.value > 0.6 ? 1.0 : 0.0,
                child: Image.asset(
                  'assets/icons/star.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ),

          // 📝 Texte animé avec effet pulse
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: ScaleTransition(
                scale: _pulseAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Galsen',
                      style: GoogleFonts.montserrat(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Medic',
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF20D114),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CurvedSplashPainter extends CustomPainter {
  final double progress;
  CurvedSplashPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final paint = Paint()..style = PaintingStyle.fill;

    void drawBand(Color color, double offsetX, double width, bool isFine) {
      final path = Path();
      final double startY = isFine ? h * 0.15 : 0;
      final double bandHeight = isFine ? h * 0.3 : h;

      path.moveTo(offsetX, bandHeight);
      for (double y = bandHeight; y >= startY; y -= 1) {
        double x = offsetX + width * math.sin(y / h * math.pi);
        path.lineTo(x, y);
      }
      for (double y = startY; y <= bandHeight; y += 1) {
        double x = offsetX + width * math.sin(y / h * math.pi) + 18;
        path.lineTo(x, y);
      }
      path.close();

      paint.color = color.withOpacity(progress);
      canvas.drawPath(path, paint);
    }

    final offset = size.width * 0.3;

    // ✅ Bandes larges avec épaisseur augmentée
    drawBand(const Color(0xFF20D114), offset - 75, 45, false); // vert large
    drawBand(const Color(0xFF20D114), offset - 75, 45, true); // vert fine

    drawBand(const Color(0xFFFECB00), offset - 20, 45, false); // jaune large
    drawBand(const Color(0xFFFECB00), offset - 20, 45, true); // jaune fine

    drawBand(const Color(0xFFF70404), offset + 40, 55, false); // rouge large
    drawBand(const Color(0xFFF70404), offset + 40, 55, true); // rouge fine
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
