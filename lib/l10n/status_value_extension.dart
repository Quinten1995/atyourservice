import 'app_localizations.dart';

extension StatusValueExtension on AppLocalizations {
  String statusValue(String status) {
    switch (status.toLowerCase()) {
      case 'offen':
      case 'open':
        return statusOffen;
      case 'in bearbeitung':
      case 'in progress':
        return statusInBearbeitung;
      case 'abgeschlossen':
      case 'completed':
        return statusAbgeschlossen;
      default:
        return status;
    }
  }
}
