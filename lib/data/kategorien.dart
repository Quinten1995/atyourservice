// lib/data/kategorien.dart

// (Bestehende kategorieKeys lassen wir zur Abwärtskompatibilität drin,
//  aber für neue Screens NICHT mehr direkt verwenden.)
const List<String> kategorieKeys = [
  'category_babysitter',
  'category_catering',
  'category_dachdecker',
  'category_elektriker',
  'category_ernaehrungsberatung',
  'category_eventplanung',
  'category_fahrdienste',
  'category_fahrlehrer',
  'category_fensterputzer',
  'category_fliesenleger',
  'category_fotografie',
  'category_friseur',
  'category_gartenpflege',
  'category_grafikdesign',
  'category_handy_reparatur',
  'category_haushaltsreinigung',
  'category_hausmeisterservice',
  'category_heizungsbauer',
  'category_hundesitter',
  'category_it_support',
  'category_klempner',
  'category_kosmetik',
  'category_kuenstler',
  'category_kurierdienst',
  'category_maler',
  'category_massagen',
  'category_maurer',
  'category_moebelaufbau',
  'category_musikunterricht',
  'category_nachhilfe',
  'category_nagelstudio',
  'category_pc_reparatur',
  'category_partyservice',
  'category_personal_trainer',
  'category_rasenmaeher_service',
  'category_rechtsberatung',
  'category_reparaturdienste',
  'category_seniorenbetreuung',
  'category_social_media',
  'category_sonstige',
  'category_sprachunterricht',
  'category_steuerberatung',
  'category_tischler',
  'category_transport',
  'category_umzugstransporte',
  'category_umzugshelfer',
  'category_uebersetzungen',
  'category_waescheservice',
  'category_webdesign',
  'category_einkaufsservice',
  'category_haustierbetreuung',
];

enum CategoryStatus { active, beta, comingSoon, hidden }

// Zentrale Status-Zuordnung (GLOBAL gültig)
const Map<String, CategoryStatus> categoryStatus = {
  // -------- ACTIVE (bewerben & auswählbar) --------
  'category_haushaltsreinigung': CategoryStatus.active,
  'category_moebelaufbau': CategoryStatus.active,
  'category_umzugshelfer': CategoryStatus.active,
  'category_transport': CategoryStatus.active,
  'category_fensterputzer': CategoryStatus.active,
  'category_gartenpflege': CategoryStatus.active, // = Gartenpflege / GaLa-Bau
  'category_maler': CategoryStatus.active,
  'category_reparaturdienste': CategoryStatus.active,
  'category_pc_reparatur': CategoryStatus.active,
  'category_elektriker': CategoryStatus.active,

  // -------- BETA (auswählbar, aber nicht aktiv bewerben) --------
  'category_handy_reparatur': CategoryStatus.beta,
  'category_it_support': CategoryStatus.beta,
  'category_tischler': CategoryStatus.beta,
  'category_fliesenleger': CategoryStatus.beta,
  'category_umzugstransporte': CategoryStatus.beta,
  'category_babysitter': CategoryStatus.beta,
  'category_haustierbetreuung': CategoryStatus.beta,

  // -------- COMING SOON (ausgrauen/Lead-Capture; NICHT auswählbar) --------
  'category_klempner': CategoryStatus.comingSoon,
  'category_heizungsbauer': CategoryStatus.comingSoon,
  'category_dachdecker': CategoryStatus.comingSoon,
  'category_maurer': CategoryStatus.comingSoon,
  'category_rechtsberatung': CategoryStatus.comingSoon,
  'category_steuerberatung': CategoryStatus.comingSoon,
  'category_grafikdesign': CategoryStatus.comingSoon,
  'category_webdesign': CategoryStatus.comingSoon,
  'category_fotografie': CategoryStatus.comingSoon,
  'category_eventplanung': CategoryStatus.comingSoon,
  'category_partyservice': CategoryStatus.comingSoon,
  'category_kurierdienst': CategoryStatus.comingSoon,
  'category_einkaufsservice': CategoryStatus.comingSoon,
  'category_massagen': CategoryStatus.comingSoon,
  'category_kosmetik': CategoryStatus.comingSoon,
  'category_friseur': CategoryStatus.comingSoon,
  'category_fahrdienste': CategoryStatus.comingSoon,
  'category_fahrlehrer': CategoryStatus.comingSoon,
  'category_ernaehrungsberatung': CategoryStatus.comingSoon,
  'category_musikunterricht': CategoryStatus.comingSoon,
  'category_nachhilfe': CategoryStatus.comingSoon,
  'category_nagelstudio': CategoryStatus.comingSoon,
  'category_personal_trainer': CategoryStatus.comingSoon,
  'category_rasenmaeher_service': CategoryStatus.comingSoon,
  'category_seniorenbetreuung': CategoryStatus.comingSoon,
  'category_social_media': CategoryStatus.comingSoon,
  'category_sonstige': CategoryStatus.comingSoon,
  'category_sprachunterricht': CategoryStatus.comingSoon,
  'category_uebersetzungen': CategoryStatus.comingSoon,
  'category_waescheservice': CategoryStatus.comingSoon,
  'category_hausmeisterservice': CategoryStatus.comingSoon,
  'category_catering': CategoryStatus.comingSoon,
};

// Helper: nur ACTIVE + BETA (für Dropdowns/Picker)
List<String> selectableCategoryKeys() {
  final list =
      categoryStatus.entries
          .where(
            (e) =>
                e.value == CategoryStatus.active ||
                e.value == CategoryStatus.beta,
          )
          .map((e) => e.key)
          .toList()
        ..sort(); // optional: alphabetisch nach Key
  return list;
}

// Optional: für ausgegraute Kacheln/Lead-Capture
List<String> comingSoonCategoryKeys() {
  final list =
      categoryStatus.entries
          .where((e) => e.value == CategoryStatus.comingSoon)
          .map((e) => e.key)
          .toList()
        ..sort();
  return list;
}
