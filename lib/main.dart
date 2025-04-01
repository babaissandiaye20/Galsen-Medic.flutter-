import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:galsen_medic/screens/splash_screen.dart';
import 'package:galsen_medic/provider/utilisateur_provider.dart'; // ✅ ← import du provider

void main() {
  print("🔥 Main exécuté !");
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UtilisateurProvider(),
        ), // ✅ Ajout du provider ici
      ],
      child: MaterialApp(
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
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(1.0)),
            child: child!,
          );
        },
        home: const SplashScreen(),
      ),
    );
  }
}
