import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  // Palette principale
  static const Color bleuStratosphere = Color(0xFF0B1E36);
  static const Color bleuHorizon = Color(0xFF1E3A5F);
  static const Color cyanRadar = Color(0xFF00F0FF);
  static const Color grisNuage = Color(0xFFE2E8F0);
  static const Color ambreCrepuscule = Color(0xFFFF8C00);
  static const Color filtreBleuNuit = Color(0x551A3B68);

  // Alias de compatibilite pour le code existant
  static const Color primaryColor = cyanRadar;
  static const Color secondaryColor = bleuHorizon;
  static const Color textColor = grisNuage;
  static const Color greyColor = Color(0xFF94A3B8);
  static const Color bleuVol = bleuHorizon;
  static const Color vertArrivee = Color(0xFF3E8FA0);
  static const Color orangeEscale = Color(0xFF6E7FA4);
  static const Color fondInfo = Color(0xFF233F63);
  static const Color fondPageHaut = bleuStratosphere;
  static const Color fondPageBas = Color(0xFF102845);
  static const Color surface = bleuHorizon;
  static const Color surfaceAlt = Color(0xFF27466D);
  static const Color texteFonce = grisNuage;
  static const Color texteSecondaire = Color(0xFFB6C3D4);
  static const Color blanc = grisNuage;

  static const TextStyle etiquetteInfo = TextStyle(
    fontSize: 12,
    color: texteSecondaire,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle valeurInfo = TextStyle(
    fontSize: 16,
    color: texteFonce,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle titreCompagnie = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: cyanRadar,
  );

  static const TextStyle titreSection = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: texteSecondaire,
    letterSpacing: 0.2,
  );

  static const TextStyle titreCarteVol = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: cyanRadar,
  );

  static const TextStyle badgeTexte = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: bleuStratosphere,
  );

  static const LinearGradient fondDetailsGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [fondPageHaut, fondPageBas],
  );

  static ThemeData get themeLight {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: cyanRadar,
        brightness: Brightness.dark,
        primary: cyanRadar,
        secondary: ambreCrepuscule,
        surface: surface,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: fondPageHaut,
      textTheme: GoogleFonts.overpassTextTheme(base.textTheme).apply(
        bodyColor: texteFonce,
        displayColor: texteFonce,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bleuHorizon,
        foregroundColor: grisNuage,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: cyanRadar,
        unselectedItemColor: Color(0xFF8FA5BD),
        backgroundColor: bleuHorizon,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static BoxDecoration cartePrincipale = BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [
      BoxShadow(
        color: Color(0x40000000),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
    border: Border.all(color: const Color(0x3300F0FF)),
  );

  static BoxDecoration carteSecondaire = BoxDecoration(
    color: surfaceAlt,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(
        color: Color(0x2B000000),
        blurRadius: 14,
        offset: Offset(0, 4),
      ),
    ],
    border: Border.all(color: const Color(0x2200F0FF)),
  );

  static BoxDecoration badgeFond = BoxDecoration(
    color: cyanRadar,
    borderRadius: BorderRadius.circular(999),
  );

  static const BoxDecoration carteBlanche = BoxDecoration(
    color: surface,
  );

  static TextStyle titleLight = GoogleFonts.overpass(
    fontSize: 28,
    fontWeight: FontWeight.w300,
    color: texteFonce,
  );

  static TextStyle titleBold = GoogleFonts.overpass(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: texteFonce,
  );

  static TextStyle airportCode = GoogleFonts.overpass(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: grisNuage,
  );

  static TextStyle airportShortName = GoogleFonts.overpass(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: texteFonce,
  );

  static TextStyle airportLongName = GoogleFonts.overpass(
    fontSize: 12,
    color: const Color(0xFFA7B7C9),
  );

  static TextStyle stopSelectorText = GoogleFonts.overpass(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static BoxDecoration flightCardDecoration = BoxDecoration(
    color: bleuHorizon,
    borderRadius: BorderRadius.circular(18),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.30),
        offset: const Offset(0, 8),
        blurRadius: 22,
      ),
    ],
    border: Border.all(color: const Color(0x4400F0FF)),
  );
}
