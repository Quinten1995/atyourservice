// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get registerAppBar => 'Kayıt';

  @override
  String get registerTitle => 'Kayıt Ol';

  @override
  String get roleLabel => 'Bir rol seçin';

  @override
  String get roleKunde => 'Müşteri';

  @override
  String get roleDienstleister => 'Hizmet Sağlayıcı';

  @override
  String get categoryLabel => 'Kategori';

  @override
  String get categoryValidator => 'Lütfen kategori seçin';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get emailEmpty => 'Lütfen e-posta girin';

  @override
  String get emailInvalid => 'Lütfen geçerli bir e-posta girin';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get passwordEmpty => 'Lütfen şifre girin';

  @override
  String get passwordTooShort => 'Şifre en az 6 karakter olmalıdır';

  @override
  String get registerButton => 'Kayıt Ol';

  @override
  String get registerSuccess => 'Kayıt başarılı! Lütfen e-postanızı onaylayın.';

  @override
  String get registerExists => 'Bu e-posta zaten kayıtlı. Lütfen giriş yapın veya şifrenizi sıfırlayın.';

  @override
  String get registerInvalidEmail => 'Lütfen geçerli bir e-posta adresi girin.';

  @override
  String get registerPasswordShort => 'Şifre en az 6 karakter olmalıdır.';

  @override
  String registerFailed(Object error) {
    return 'Kayıt başarısız: $error';
  }

  @override
  String registerUnknownError(Object error) {
    return 'Bilinmeyen hata: $error';
  }

  @override
  String get profileAppBar => 'Hizmet Sağlayıcı Profili';

  @override
  String get profileAddressLabel => 'Ev Adresi (örn. Örnek Sokak 12, 12345 Örnek Şehir)';

  @override
  String get profileAddressEmpty => 'Lütfen adres girin';

  @override
  String get profileSaveButton => 'Profili kaydet';

  @override
  String get profileAddressSaved => 'Adres kaydedildi!';

  @override
  String profileLoadError(Object error) {
    return 'Yükleme hatası: $error';
  }

  @override
  String profileSaveError(Object error) {
    return 'Kaydetme hatası: $error';
  }

  @override
  String get notLoggedIn => 'Giriş yapılmadı';

  @override
  String get pleaseLogin => 'Lütfen önce giriş yapın';

  @override
  String get changeNotAllowedTitle => 'Değişiklik izin verilmiyor';

  @override
  String changeNotAllowedContent(Object date) {
    return 'Ücretsiz kullanıcı olarak kategori veya adresi yalnızca 20 günde bir değiştirebilirsiniz.\nBir sonraki değişiklik şu tarihten itibaren mümkün: $date';
  }

  @override
  String get ok => 'Tamam';

  @override
  String get profileSaved => 'Profil başarıyla kaydedildi!';

  @override
  String get changeProfileImage => 'Profil resmini değiştir';

  @override
  String get upgradeToPremium => 'Premiium\'a yükselt';

  @override
  String get noRatingsYet => 'Henüz değerlendirme yok';

  @override
  String get nameLabel => 'İsim';

  @override
  String get nameValidator => 'Lütfen isim girin';

  @override
  String get descriptionLabel => 'Açıklama';

  @override
  String get addressLabel => 'Adres (örn. sokak, posta kodu, şehir)';

  @override
  String get phoneLabel => 'Telefon';

  @override
  String get phoneValidator => 'Lütfen telefon numarası girin';

  @override
  String get emailEmptyValidator => 'Lütfen e-postanızı girin';

  @override
  String get emailInvalidValidator => 'Lütfen geçerli bir e-posta girin';

  @override
  String errorPrefix(Object error) {
    return 'Hata: $error';
  }

  @override
  String changeLimitHint(Object date) {
    return 'Kategori/Adres ancak $date tarihinden itibaren değiştirilebilir.';
  }

  @override
  String get addressNotFound => 'Adres bulunamadı. Lütfen kontrol edin.';

  @override
  String ratingsCount(Object count) {
    return '($count değerlendirme)';
  }

  @override
  String get premiumAppBar => 'Premium\'a yükselt';

  @override
  String get premiumChoosePlan => 'Premium Planınızı seçin';

  @override
  String get premiumCurrentPlan => 'Mevcut abonelik:';

  @override
  String get premiumFreePrice => 'ücretsiz';

  @override
  String get premiumSilverPrice => 'Aylık €4,99';

  @override
  String get premiumGoldPrice => 'Aylık €9,99';

  @override
  String get premiumFreeFeature1 => 'Haftada 1 iş kabul et';

  @override
  String get premiumFreeFeature2 => '5 km çapında işler';

  @override
  String get premiumFreeFeature3 => 'Sadece temel kategoriler';

  @override
  String get premiumFreeFeature4 => 'Kategori değişimi sadece 20 günde bir';

  @override
  String get premiumSilverFeature1 => 'Sınırsız iş kabul et';

  @override
  String get premiumSilverFeature2 => '15 km çapında işler';

  @override
  String get premiumSilverFeature3 => 'Tüm kategorilere erişim';

  @override
  String get premiumGoldFeature1 => 'Sınırsız iş kabul et';

  @override
  String get premiumGoldFeature2 => '40 km çapında işler';

  @override
  String get premiumGoldFeature3 => 'Tüm kategorilere erişim';

  @override
  String get premiumGoldFeature4 => 'Premium kullanıcı rozeti (müşteriler tarafından görünür)';

  @override
  String premiumChooseButton(Object title) {
    return '$title seçin';
  }

  @override
  String get premiumPaymentNote => 'Not: Tüm ödemeler Apple veya Google üzerinden güvenli bir şekilde işlenir. Aboneliğinizi mağazada istediğiniz zaman iptal edebilir veya yönetebilirsiniz.';

  @override
  String get premiumSilverComingSoon => 'Silver yakında geliyor!';

  @override
  String get premiumGoldComingSoon => 'Gold yakında geliyor!';

  @override
  String get auftragHidden => 'İş gizlendi.';

  @override
  String auftragHideError(Object error) {
    return 'İşi gizlerken hata: $error';
  }

  @override
  String get meineAuftraegeAppBar => 'İşlerim';

  @override
  String get refreshTooltip => 'Yenile';

  @override
  String get noAuftraegeFound => 'İş bulunamadı.';

  @override
  String get geplanterAuftrag => 'Planlanan iş';

  @override
  String get auftragAusblenden => 'İşi gizle';

  @override
  String get loginFailedDetails => 'Giriş başarısız. Lütfen bilgilerinizi kontrol edin veya e-postanızı onaylayın.';

  @override
  String get loginSuccess => 'Giriş başarılı!';

  @override
  String loginFailedPrefix(Object error) {
    return 'Giriş başarısız: $error';
  }

  @override
  String loginUnknownError(Object error) {
    return 'Bilinmeyen hata: $error';
  }

  @override
  String get emailValidatorEmpty => 'Lütfen e-posta girin';

  @override
  String get emailValidatorInvalid => 'Lütfen geçerli bir e-posta girin';

  @override
  String get passwordValidatorEmpty => 'Lütfen şifre girin';

  @override
  String get passwordValidatorShort => 'Şifre en az 6 karakter olmalı';

  @override
  String get loginKundeAppBar => 'Müşteri Girişi';

  @override
  String get loginKundeHeadline => 'Giriş Yap';

  @override
  String get loginButton => 'Giriş';

  @override
  String get noAccountYet => 'Henüz hesabınız yok mu? Şimdi kayıt olun';

  @override
  String get loginFailedDetailsDL => 'Giriş başarısız. Lütfen bilgilerinizi kontrol edin veya e-postanızı onaylayın.';

  @override
  String get wrongRoleDL => 'Bu hesap bir hizmet sağlayıcı değil. Lütfen müşteri girişi yapın.';

  @override
  String get loginDLAppBar => 'Hizmet Sağlayıcı Girişi';

  @override
  String get loginDLHeadline => 'Giriş Yap';

  @override
  String get kundenDashboardHeader => 'Paneliniz';

  @override
  String get kundenDashboardAppBar => 'Müşteri Paneli';

  @override
  String get laufendeAuftraege => 'Devam eden işler';

  @override
  String statusPrefix(Object status) {
    return 'Durum: $status';
  }

  @override
  String dienstleisterPrefix(Object dienstleister) {
    return 'Hizmet sağlayıcı: $dienstleister';
  }

  @override
  String get offeneAuftraege => 'Açık işler';

  @override
  String get noOffeneAuftraege => 'Açık iş bulunamadı.';

  @override
  String get abgeschlosseneAuftraege => 'Tamamlanan işler';

  @override
  String get abgeschlossenStatus => 'Tamamlandı';

  @override
  String get neuerAuftrag => 'Yeni iş';

  @override
  String get pleaseCreateProfile => 'Lütfen önce profilini oluştur.';

  @override
  String get profilMissingCategory => 'Profilde kategori eksik.';

  @override
  String get dienstleisterDashboardHeader => 'Paneliniz';

  @override
  String get dienstleisterDashboardAppBar => 'Hizmet Sağlayıcı Paneli';

  @override
  String get meineLaufendenAuftraege => 'Devam eden işlerim';

  @override
  String kundePrefix(Object kunde) {
    return 'Müşteri: $kunde';
  }

  @override
  String get offenePassendeAuftraege => 'Açık, uygun işler';

  @override
  String get noPassendeAuftraege => 'Uygun iş bulunamadı.';

  @override
  String entfernungSuffix(Object dist) {
    return '$dist km uzakta';
  }

  @override
  String get auftragBereitsBewertet => 'Bu işi zaten değerlendirdiniz.';

  @override
  String get bewertungDialogTitle => 'Hizmet sağlayıcıyı değerlendir';

  @override
  String get bewertungKommentarLabel => 'Yorum (isteğe bağlı)';

  @override
  String get abbrechen => 'İptal';

  @override
  String get abschicken => 'Gönder';

  @override
  String get auftragErstellenTitle => 'Yeni iş oluştur';

  @override
  String get auftragEinstellenUeberschrift => 'Şimdi iş ilanı oluştur';

  @override
  String get titelLabel => 'Başlık';

  @override
  String get titelValidator => 'Lütfen başlık girin';

  @override
  String get beschreibungLabel => 'Açıklama';

  @override
  String get kategorieLabel => 'Kategori';

  @override
  String get heimatadresseEinfuegen => 'Ev adresini ekle';

  @override
  String get adresseLabel => 'Adres (örn. Alter Markt 76, 50667 Köln)';

  @override
  String get telefonnummerLabel => 'Telefon numarası';

  @override
  String get telefonnummerValidator => 'Lütfen telefon numarası girin';

  @override
  String get ausfuehrungszeitpunkt => 'Yürütme zamanı';

  @override
  String get soSchnellWieMoeglich => 'Mümkün olan en kısa sürede';

  @override
  String get geplant => 'Planlandı';

  @override
  String get datumWaehlen => 'Tarih seç';

  @override
  String get zeitVon => 'Saat (başlangıç)';

  @override
  String get zeitBis => 'Saat (bitiş)';

  @override
  String get wiederkehrendCheckbox => 'Tekrarlayan iş?';

  @override
  String get intervallLabel => 'Aralık';

  @override
  String get intervallValidator => 'Lütfen aralık seçin';

  @override
  String get wochentagLabel => 'Haftanın günü';

  @override
  String get wochentagValidator => 'Lütfen haftanın gününü seçin';

  @override
  String get anzahlWiederholungenLabel => 'Tekrarlama sayısı (isteğe bağlı)';

  @override
  String get wiederholenBisNichtGesetzt => 'Tekrarlama bitişi: ayarlanmadı';

  @override
  String wiederholenBisLabel(Object date) {
    return 'Tekrarlama bitişi: $date';
  }

  @override
  String get auftragAbschicken => 'İşi gönder';

  @override
  String get auftragGespeichert => 'İş kaydedildi!';

  @override
  String get bitteEinloggen => 'Lütfen önce giriş yapın';

  @override
  String get adresseNichtGefunden => 'Adres bulunamadı.';

  @override
  String unbekannterFehler(Object error) {
    return 'Bilinmeyen hata: $error';
  }

  @override
  String get auftragDetailTitle => 'İş Detayları';

  @override
  String get nichtEingeloggt => 'Giriş yapılmadı';

  @override
  String get rolleNichtErmittelt => 'Rol belirlenemedi';

  @override
  String get auftragNichtGefunden => 'İş bulunamadı';

  @override
  String get bewertungDanke => 'Değerlendirmeniz için teşekkürler!';

  @override
  String get limitErreicht => 'Limit doldu';

  @override
  String get limitFree => 'Freemium hizmet sağlayıcı olarak haftada en fazla 2 iş kabul edebilirsiniz. Daha fazla imkan için Silver veya Gold\'a yükseltin!';

  @override
  String get limitSilver => 'Silver hizmet sağlayıcı olarak haftada en fazla 5 iş kabul edebilirsiniz. Sınırsız iş için Gold\'a yükseltin!';

  @override
  String get auftragAnnehmen => 'İşi kabul et';

  @override
  String get auftragBeenden => 'İşi bitir';

  @override
  String get auftragEntfernenUebersicht => 'İşi görünümden kaldır';

  @override
  String get auftragEntfernen => 'İşi kaldır';

  @override
  String get auftragEntfernenTitel => 'İş kaldırılsın mı?';

  @override
  String get auftragEntfernenText => 'Bu işi görünümünden kaldırmak istiyor musun?';

  @override
  String get entfernen => 'Kaldır';

  @override
  String get keineDatenVerfuegbar => 'Veri yok';

  @override
  String get beschreibung => 'Açıklama:';

  @override
  String get kategorie => 'Kategori:';

  @override
  String get adresse => 'Adres:';

  @override
  String get status => 'Durum:';

  @override
  String jedenWochentag(Object wochentag) {
    return 'Her $wochentag';
  }

  @override
  String bisDatum(Object datum) {
    return '$datum tarihine kadar';
  }

  @override
  String get malSuffix => 'kez';

  @override
  String kontaktZuLabel(Object label) {
    return '$label ile iletişim:';
  }

  @override
  String get nummerKopiert => 'Numara kopyalandı!';

  @override
  String get nummerKopieren => 'Numarayı kopyala';

  @override
  String get anrufen => 'Ara';

  @override
  String fehlerPrefix(Object error) {
    return 'Hata: $error';
  }

  @override
  String get editProfileTooltip => 'Profili düzenle';

  @override
  String get appTitle => 'AtYourService';

  @override
  String get hello => 'Hoş geldiniz!';

  @override
  String get kundeButton => 'Hizmet sağlayıcı arıyorum';

  @override
  String get dienstleisterButton => 'Ben bir hizmet sağlayıcıyım';

  @override
  String get category_babysitter => 'Bebek bakıcısı / Çocuk bakımı';

  @override
  String get category_catering => 'Catering';

  @override
  String get category_dachdecker => 'Çatı ustası';

  @override
  String get category_elektriker => 'Elektrikçi';

  @override
  String get category_ernaehrungsberatung => 'Beslenme danışmanlığı';

  @override
  String get category_eventplanung => 'Etkinlik planlama';

  @override
  String get category_fahrdienste => 'Servis taşımacılığı';

  @override
  String get category_fahrlehrer => 'Sürücü eğitmeni';

  @override
  String get category_fensterputzer => 'Pencere temizleyici';

  @override
  String get category_fliesenleger => 'Fayans ustası';

  @override
  String get category_fotografie => 'Fotoğrafçılık / Videografi';

  @override
  String get category_friseur => 'Kuaför';

  @override
  String get category_gartenpflege => 'Bahçe bakımı / Çim biçme';

  @override
  String get category_grafikdesign => 'Grafik tasarım';

  @override
  String get category_handy_reparatur => 'Cep telefonu / Tablet tamiri';

  @override
  String get category_haushaltsreinigung => 'Ev temizliği';

  @override
  String get category_hausmeisterservice => 'Apartman görevlisi hizmeti';

  @override
  String get category_heizungsbauer => 'Isıtma sistemleri ustası';

  @override
  String get category_hundesitter => 'Köpek gezdirme / Bakım';

  @override
  String get category_it_support => 'IT desteği';

  @override
  String get category_klempner => 'Tesisatçı';

  @override
  String get category_kosmetik => 'Güzellik uzmanı';

  @override
  String get category_kuenstler => 'Sanatçı (örn. etkinlik müzisyeni)';

  @override
  String get category_kurierdienst => 'Kurye servisi';

  @override
  String get category_maler => 'Boya ustası';

  @override
  String get category_massagen => 'Masaj';

  @override
  String get category_maurer => 'Duvar ustası';

  @override
  String get category_moebelaufbau => 'Mobilya montajı';

  @override
  String get category_musikunterricht => 'Müzik dersi';

  @override
  String get category_nachhilfe => 'Özel ders';

  @override
  String get category_nagelstudio => 'Tırnak stüdyosu';

  @override
  String get category_pc_reparatur => 'PC / Laptop tamiri';

  @override
  String get category_partyservice => 'Parti servisi';

  @override
  String get category_personal_trainer => 'Kişisel antrenör';

  @override
  String get category_rasenmaeher_service => 'Çim biçme servisi';

  @override
  String get category_rechtsberatung => 'Hukuk danışmanlığı';

  @override
  String get category_reparaturdienste => 'Tamir hizmetleri';

  @override
  String get category_seniorenbetreuung => 'Yaşlı bakımı';

  @override
  String get category_social_media => 'Sosyal medya yönetimi';

  @override
  String get category_sonstige => 'Diğer hizmetler';

  @override
  String get category_sprachunterricht => 'Dil dersi';

  @override
  String get category_steuerberatung => 'Vergi danışmanlığı';

  @override
  String get category_tischler => 'Marangoz';

  @override
  String get category_transport => 'Taşıma & Mobilite';

  @override
  String get category_umzugstransporte => 'Taşınma taşımacılığı';

  @override
  String get category_umzugshelfer => 'Taşınma yardımcısı';

  @override
  String get category_uebersetzungen => 'Çeviri hizmetleri';

  @override
  String get category_waescheservice => 'Çamaşır servisi';

  @override
  String get category_webdesign => 'Web tasarım';

  @override
  String get category_einkaufsservice => 'Alışveriş servisi';

  @override
  String get category_haustierbetreuung => 'Evcil hayvan bakımı';

  @override
  String get premiumBadgeLabel => 'Premium';
}
