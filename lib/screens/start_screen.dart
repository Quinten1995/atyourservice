import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import 'login_kunde_screen.dart';
import 'login_dienstleister_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3876BF);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF7FAFC), // oben
              Color(0xFFE7ECEF), // mitte
              Color(0xFFD9E4F5), // unten, ganz leicht bläulich
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Sanfter Kreis oben links
            Positioned(
              top: -60,
              left: -60,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Sanfter Kreis unten rechts
            Positioned(
              bottom: -50,
              right: -50,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.09),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hero Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            'assets/hero_start.png',
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Headline
                        Text(
                          AppLocalizations.of(context)!.appTitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                            color: primaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Subheadline
                        Text(
                          AppLocalizations.of(context)!.hello,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 19,
                            color: Colors.black.withOpacity(0.82),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 36),
                        // Kunden-Button (Primary)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginKundeScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: primaryColor.withOpacity(0.17),
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                              textStyle: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                fontSize: 19,
                                letterSpacing: 0.5,
                              ),
                            ),
                            child: Text(AppLocalizations.of(context)!.kundeButton),
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Dienstleister-Button (Outlined)
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginDienstleisterScreen()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: primaryColor,
                              side: BorderSide(color: primaryColor, width: 1.7),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                              textStyle: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                fontSize: 19,
                                letterSpacing: 0.5,
                              ),
                            ),
                            child: Text(AppLocalizations.of(context)!.dienstleisterButton),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
