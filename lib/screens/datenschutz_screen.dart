import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart'; // Passe den Pfad ggf. an!

class DatenschutzScreen extends StatelessWidget {
  const DatenschutzScreen({Key? key}) : super(key: key);

  // Sprachabhängiger Text (kannst du ggf. noch anpassen/übersetzen)
  String _getPrivacyText(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'en':
        return '''
Privacy Policy & Legal Notice

Responsible Party
AtYourService – Quinten Hessmann
Meylstraat 33
2540 Hove
Email: kontakt@atyourservice.de

Data Protection
We take the protection of your personal data very seriously. Personal data (such as name, email, address, profile picture) is processed only to the extent necessary for using the app (e.g., registration, job mediation, profile display).

Data Processing
- Data is stored on servers of Supabase Inc. (EU location).
- For push notifications, we may use Firebase Cloud Messaging.
- For payments, Apple/Google In-App Purchase services are used.
- No tracking, advertising, or analytics tools are used.

Your Rights
You have the right to information, correction, deletion, or restriction of processing of your data. For questions, contact us by email.

Imprint Obligation
This offering is a project by Quinten Hessmann. More information: www.atyourservice.de/impressum.

Last updated: June 2025
''';
      case 'fr':
        return '''
Déclaration de confidentialité & Mentions légales

Responsable
AtYourService – Quinten Hessmann
Meylstraat 33
2540 Hove
E-mail : kontakt@atyourservice.de

Protection des données
Nous attachons une grande importance à la protection de vos données personnelles. Les données personnelles (nom, e-mail, adresse, photo de profil) ne sont traitées que dans la mesure nécessaire à l’utilisation de l’application (inscription, mise en relation, affichage du profil).

Traitement des données
- Les données sont stockées sur les serveurs de Supabase Inc. (UE).
- Pour les notifications push, nous utilisons éventuellement Firebase Cloud Messaging.
- Pour les paiements, les services d’achat in-app Apple/Google sont utilisés.
- Aucun outil de suivi, publicité ou analyse n’est utilisé.

Vos droits
Vous avez le droit d’obtenir des informations, de rectifier, de supprimer ou de limiter le traitement de vos données. Pour toute question, contactez-nous par e-mail.

Mentions légales
Ce projet est une initiative de Quinten Hessmann. Plus d’informations sur www.atyourservice.de/impressum.

Mise à jour : juin 2025
''';
      case 'es':
        return '''
Política de privacidad y aviso legal

Responsable
AtYourService – Quinten Hessmann
Meylstraat 33
2540 Hove
Correo electrónico: kontakt@atyourservice.de

Protección de datos
Nos tomamos muy en serio la protección de tus datos personales. Los datos personales (nombre, correo, dirección, foto de perfil) solo se procesan en la medida necesaria para usar la aplicación (registro, intermediación de trabajos, visualización de perfil).

Tratamiento de datos
- Los datos se almacenan en servidores de Supabase Inc. (UE).
- Para notificaciones push usamos Firebase Cloud Messaging.
- Para pagos se utilizan los servicios de compra de Apple/Google.
- No se usan herramientas de rastreo, publicidad ni análisis.

Tus derechos
Tienes derecho a acceder, corregir, eliminar o restringir el tratamiento de tus datos. Para cualquier duda, contáctanos por correo electrónico.

Aviso legal
Esta oferta es un proyecto de Quinten Hessmann. Más información en www.atyourservice.de/impressum.

Fecha: junio de 2025
''';
      case 'tr':
        return '''
Gizlilik Politikası & Yasal Bilgilendirme

Sorumlu Kişi
AtYourService – Quinten Hessmann
Meylstraat 33
2540 Hove
E-posta: kontakt@atyourservice.de

Veri Koruma
Kişisel verilerinizin korunmasına büyük önem veriyoruz. Kişisel veriler (isim, e-posta, adres, profil fotoğrafı), uygulamanın kullanımı için gerektiği ölçüde işlenir (ör. kayıt, iş aracılığı, profil gösterimi).

Veri İşleme
- Veriler Supabase Inc. (AB) sunucularında saklanır.
- Push bildirimleri için Firebase Cloud Messaging kullanılabilir.
- Ödemeler için Apple/Google uygulama içi satın alma servisleri kullanılır.
- Herhangi bir takip, reklam veya analiz aracı kullanılmaz.

Haklarınız
Verilerinizin işlenmesiyle ilgili bilgi edinme, düzeltme, silme veya kısıtlama hakkına sahipsiniz. Sorularınız için bize e-posta ile ulaşabilirsiniz.

Yasal Bilgilendirme
Bu hizmet Quinten Hessmann'ın bir projesidir. Detaylı bilgi: www.atyourservice.de/impressum.

Güncelleme tarihi: Haziran 2025
''';
      case 'de':
      default:
        return '''
Datenschutzerklärung & Impressum

Verantwortlicher
AtYourService – Quinten Hessmann
Meylstraat 33
2540 Hove
E-Mail: kontakt@atyourservice.de

Datenschutz
Wir nehmen den Schutz deiner persönlichen Daten sehr ernst. Personenbezogene Daten (wie Name, E-Mail, Adresse, Profilbild) werden nur verarbeitet, soweit dies für die Nutzung der App erforderlich ist (z. B. Registrierung, Auftragsvermittlung, Profilanzeige).

Datenverarbeitung
- Die Daten werden auf Servern der Supabase Inc. (mit Standort EU) gespeichert.
- Für Push-Benachrichtigungen nutzen wir ggf. Firebase Cloud Messaging.
- Für Zahlungen werden Apple/Google-InApp-Purchase-Dienste genutzt.
- Es werden keine Tracking-, Werbe- oder Analyse-Tools eingesetzt.

Deine Rechte
Du hast das Recht auf Auskunft, Berichtigung, Löschung oder Einschränkung der Verarbeitung deiner Daten. Bei Fragen kontaktiere uns gerne per E-Mail.

Impressumspflicht
Dieses Angebot ist ein Projekt von Quinten Hessmann. Weitere Informationen findest du auf www.atyourservice.de/impressum.

Stand: Juni 2025
''';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final privacyText = _getPrivacyText(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyButton), // <-- Überschrift aus ARB/i18n
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Text(
            privacyText,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
