import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galsen_medic/screens/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  print("🔥 Main exécuté !");
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Restrict device orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const GalsenMedicApp());
}

class GalsenMedicApp extends StatelessWidget {
  const GalsenMedicApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("✅ HomeAdminPage chargé !");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GalsenMedic',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        platform: TargetPlatform.iOS,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // ✅ Gérer le text scaling global (accessibilité)
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
      home: const SplashScreen(),
    );
  }
}
