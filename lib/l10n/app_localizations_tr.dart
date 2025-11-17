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
  String get passwordTooShort => 'Şifre en az 8 karakter olmalıdır.';

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
  String get descriptionLabel => 'Hizmet açıklaması:';

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
  String get premiumSilverFeature1 => 'Haftada 2 iş kabul et';

  @override
  String get premiumSilverFeature2 => '15 km çapında işler';

  @override
  String get premiumSilverFeature3 => 'Tüm kategorilere erişim';

  @override
  String get premiumGoldFeature1 => 'Sınırsız iş kabul et';

  @override
  String get premiumGoldFeature2 => '30 km çapında işler';

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
  String get category_rasenmaeher_service => 'Bahçe Bakımı / Peyzaj';

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

  @override
  String get statusOffen => 'Açık';

  @override
  String get statusInBearbeitung => 'Devam ediyor';

  @override
  String get statusAbgeschlossen => 'Tamamlandı';

  @override
  String get privacyButton => 'Gizlilik';

  @override
  String get interval_weekly => 'Haftalık';

  @override
  String get interval_biweekly => 'İki haftada bir';

  @override
  String get interval_monthly => 'Aylık';

  @override
  String get weekday_monday => 'Pazartesi';

  @override
  String get weekday_tuesday => 'Salı';

  @override
  String get weekday_wednesday => 'Çarşamba';

  @override
  String get weekday_thursday => 'Perşembe';

  @override
  String get weekday_friday => 'Cuma';

  @override
  String get weekday_saturday => 'Cumartesi';

  @override
  String get weekday_sunday => 'Pazar';

  @override
  String get kundenInfoBanner => 'Müşteri olarak giriş yaptınız. Lütfen burada ihtiyacınız olan hizmeti açıklayın. Hizmet sağlayıcıları size teklif gönderecektir.';

  @override
  String get titelHint => 'ör. dairem temizlensin';

  @override
  String get beschreibungHint => 'Ne yapılması gerektiğini açıklayın – ör. 3 oda, mutfak ve banyo temizliği ...';

  @override
  String get invoiceSectionTitle => 'Fatura bilgileri (sadece Gold için)';

  @override
  String get invoiceNameLabel => 'Fatura adı (ör. şirket adı)';

  @override
  String get invoiceAddressLabel => 'Fatura adresi:';

  @override
  String get invoiceTaxNumberLabel => 'Vergi numarası (isteğe bağlı)';

  @override
  String get invoiceIbanLabel => 'IBAN (isteğe bağlı)';

  @override
  String get invoiceLogoUrlLabel => 'Logo URL\'si (isteğe bağlı)';

  @override
  String get invoiceGoldInfo => 'Fatura verileri yalnızca GOLD aboneliğinde düzenlenebilir.';

  @override
  String get rechnungGenerierenButtonLabel => 'Fatura oluştur';

  @override
  String get meineAbgeschlossenenAuftraege => 'Tamamlanan siparişlerim';

  @override
  String get verbergenButtonLabel => 'Gizle';

  @override
  String get rechnungGenerierenAppBar => 'Fatura oluştur';

  @override
  String get rechnungAlsPdfAnzeigenLabel => 'PDF olarak faturayı göster';

  @override
  String get invoiceLabel => 'Fatura';

  @override
  String get fromLabel => 'Kimden:';

  @override
  String get taxNumberLabel => 'Vergi numarası:';

  @override
  String get ibanLabel => 'IBAN:';

  @override
  String get toLabel => 'Kime:';

  @override
  String get amountLabel => 'Tutar:';

  @override
  String get dateLabel => 'Tarih:';

  @override
  String get generatedByText => 'Bu fatura AtYourService tarafından otomatik olarak oluşturulmuştur.';

  @override
  String get currencyLabel => 'Para birimi';

  @override
  String get amountRequired => 'Lütfen geçerli bir tutar girin.';

  @override
  String get premiumGoldInvoiceFeature => 'PDF olarak fatura oluşturma';

  @override
  String get onlyForGoldTooltip => 'Bu özellik yalnızca Gold aboneleri için geçerlidir.';

  @override
  String get deleteJobTooltip => 'Görevi listeden kaldır';

  @override
  String get invoiceNumberLabel => 'Fatura Numarası';

  @override
  String get invoiceProfileHint => 'Lütfen fatura bilgilerinizi profilinizde doldurun. Bu bilgiler PDF faturasında otomatik olarak yer alacaktır.';

  @override
  String get auftragErneutPosten => 'İşi tekrar yayımla';

  @override
  String get auftragErneutPostenTitle => 'Bu işi tekrar yayımlamak istiyor musun?';

  @override
  String get auftragErneutPostenText => 'Mevcut hizmet sağlayıcı kaldırılacak. İş tekrar diğerlerine görünür olacak. Devam etmek istiyor musun?';

  @override
  String get auftragErneutGepostet => 'İş yeniden yayımlandı.';

  @override
  String get premiumActivated => 'Abonelik başarıyla etkinleştirildi!';

  @override
  String premiumPurchaseFailed(Object error) {
    return 'Satın alma başarısız: $error';
  }

  @override
  String get premiumProductNotFound => 'Ürün bulunamadı!';

  @override
  String get premiumStoreNotLoaded => 'Mağaza ürünleri yüklenemedi.';

  @override
  String premiumYearlySuffix(Object price) {
    return 'Yıllık: $price';
  }

  @override
  String premiumYearlyButton(Object plan) {
    return '$plan (Yıllık)';
  }

  @override
  String get deleteAccountTitle => 'Hesabı Sil';

  @override
  String get deleteAccountWarning => 'Hesabınızı kalıcı olarak silmek istediğinizden emin misiniz? Tüm verileriniz geri alınamaz şekilde silinecek.';

  @override
  String get deleteAccountButton => 'Hesabı Sil';

  @override
  String get accountDeleted => 'Hesabınız silindi.';

  @override
  String get cancel => 'İptal';

  @override
  String get premiumDeactivated => 'Premium devre dışı bırakıldı.';

  @override
  String acceptedByLabel(Object name) {
    return '$name tarafından kabul edildi';
  }

  @override
  String get adresseValidator => 'Lütfen bir adres girin.';

  @override
  String get abgeschlosseneAuftraegeHinweis => 'Buradan tamamlanan işleri silebilir ve hizmet sağlayıcını değerlendirebilirsin.';

  @override
  String get goldBadgeLabel => 'Altın Abonelik';

  @override
  String get silverBadgeLabel => 'Gümüş Abonelik';

  @override
  String get topBewertetBadgeLabel => 'En yüksek puanlı';

  @override
  String get badgeCertified => 'Sertifikalı';

  @override
  String get badgeExperienced => 'Deneyimli';

  @override
  String get badgeExpert => 'Uzman';

  @override
  String get badgeMaster => 'Usta';

  @override
  String badgeCertifiedCounter(Object count) {
    return '$count iş tamamlandı';
  }

  @override
  String badgeExperiencedCounter(Object count) {
    return '$count iş tamamlandı';
  }

  @override
  String badgeExpertCounter(Object count) {
    return '$count iş tamamlandı';
  }

  @override
  String badgeMasterCounter(Object count) {
    return '$count iş tamamlandı';
  }

  @override
  String get achievementTitle => 'Başarılar & Rozetler';

  @override
  String get goldBadgeDesc => 'Altın aboneliğiniz var ve sınırsız iş kabul edebilirsiniz.';

  @override
  String get silverBadgeDesc => 'Gümüş aboneliğiniz var ve haftada 3 iş kabul edebilirsiniz.';

  @override
  String get topBewertetBadgeDesc => 'En az 5 değerlendirmeden ortalama en az 4,5 yıldız alın.';

  @override
  String badgeCertifiedProgress(Object count) {
    return 'Sertifikalı ($count/1)';
  }

  @override
  String get badgeCertifiedDesc => '3 işi tamamla.';

  @override
  String badgeExperiencedProgress(Object count) {
    return 'Deneyimli ($count/2)';
  }

  @override
  String get badgeExperiencedDesc => 'Toplam 10 işi tamamla.';

  @override
  String badgeExpertProgress(Object count) {
    return 'Uzman ($count/3)';
  }

  @override
  String get badgeExpertDesc => 'Toplam 25 işi tamamla.';

  @override
  String badgeMasterProgress(Object count) {
    return 'Usta ($count/4)';
  }

  @override
  String get badgeMasterDesc => 'Toplam 50 işi tamamla.';

  @override
  String get trafficScreenInfoText => 'Burada, bulunduğunuz bölgede her kategoride kaç hizmet sağlayıcının aktif olduğunu görebilirsiniz. Ne kadar çok sağlayıcı varsa, talebiniz genellikle o kadar hızlı kabul edilir.';

  @override
  String get filterAbgeschlossen => 'Tamamlandı';

  @override
  String get auftraege => 'İşler';

  @override
  String get profil => 'Profil';

  @override
  String get filterAlle => 'Tümü';

  @override
  String get filterOffen => 'Açık';

  @override
  String get filterLaufend => 'Devam eden';

  @override
  String get forgotPasswordButton => 'Şifrenizi mi unuttunuz?';

  @override
  String get forgotPasswordInfo => 'Kayıtlı e-posta adresinizi girin. Şifrenizi sıfırlamak için bir bağlantı alacaksınız.';

  @override
  String get sendResetLinkButton => 'Sıfırlama bağlantısı gönder';

  @override
  String get resetMailSent => 'Bağlantı gönderildi. Lütfen e-posta kutunuzu kontrol edin!';

  @override
  String get keineDienstleisterInRegion => 'Bölgenizde henüz bir hizmet sağlayıcı bulunamadı.';

  @override
  String get trafficScreenKeineAdresse => 'Profilinizde bir adres bulunamadı.';

  @override
  String get trafficScreenAdresseFehler => 'Adresiniz koordinatlara dönüştürülemedi.';

  @override
  String get auftragWiederkehrendAppBar => 'Tekrarlayan Görev';

  @override
  String get auftragWiederkehrendHeadline => 'Bu görev düzenli olarak tekrar edilsin mi?';

  @override
  String get auftragWiederkehrendInfo => 'Görevin otomatik olarak ne sıklıkta gerçekleştirileceğini seçin.';

  @override
  String get auftragReviewAppBar => 'Gözden geçir ve gönder';

  @override
  String get auftragReviewHeadline => 'Her şey doğru mu?';

  @override
  String get auftragReviewInfo => 'Görevi göndermeden önce bilgilerinizi gözden geçirin.';

  @override
  String get absendenButton => 'Gönder';

  @override
  String get ja => 'Evet';

  @override
  String get nein => 'Hayır';

  @override
  String get wiederholenBisLabelPlain => 'Şu tarihe kadar tekrarla';

  @override
  String get auftragAdresseAppBar => 'Adres ve iletişim';

  @override
  String get auftragAdresseHeadline => 'Görev nerede yapılmalı?';

  @override
  String get auftragAdresseInfo => 'Hizmet sağlayıcının sizinle iletişime geçebilmesi için adres ve telefon numaranızı girin.';

  @override
  String get adresseHint => 'örn. Örnek Sokak 12, 12345 İstanbul';

  @override
  String get telefonnummerHint => 'örn. 0532 123 45 67';

  @override
  String get zurueckButton => 'Geri';

  @override
  String get weiterButton => 'İleri';

  @override
  String get auftragKategorieAppBar => 'Kategori seç';

  @override
  String get auftragKategorieHeadline => 'Hangi kategori için yardım arıyorsunuz?';

  @override
  String get auftragKategorieInfo => 'Doğru hizmeti seçin. Daha sonra ayrıntıları belirtebilirsiniz.';

  @override
  String get kategorieValidator => 'Lütfen bir kategori seçin.';

  @override
  String get auftragDetailsAppBar => 'Görev ayrıntıları';

  @override
  String get auftragDetailsHeadline => 'Görevi açıklayın';

  @override
  String get auftragDetailsInfo => 'Ne yapılmalı? Ne kadar ayrıntılı, o kadar iyi!';

  @override
  String get auftragTerminAppBar => 'Tarih ve saat';

  @override
  String get auftragTerminHeadline => 'Görev ne zaman yapılmalı?';

  @override
  String get auftragTerminInfo => 'Tarih ve saati ayarlayın veya \'en kısa sürede\'yi seçin.';

  @override
  String get terminLabel => 'Tarih';

  @override
  String get preisLabel => 'Fiyat (€) veya \'pazarlık yapılabilir\'';

  @override
  String get preisHint => 'örn. 60 veya \'pazarlık yapılabilir\'';

  @override
  String get preisValidator => 'Lütfen geçerli bir fiyat girin veya \'pazarlık yapılabilir\' yazın.';

  @override
  String get preisHinweisLabel => 'Fiyat notu (isteğe bağlı)';

  @override
  String get preisHinweisHint => 'örn. saatlik ücret, malzeme maliyeti, pazarlık yapılabilir vb.';

  @override
  String get preisTypLabel => 'Fiyat seçeneği seçin';

  @override
  String get preisTypGesamt => 'Toplam fiyat';

  @override
  String get preisTypStunden => 'Saatlik ücret';

  @override
  String get preisTypVerhandelbar => 'Karşılıklı anlaşma / pazarlık yapılabilir';

  @override
  String get preisLabelGesamt => 'Toplam fiyat (€)';

  @override
  String get preisHintGesamt => 'örn. 120';

  @override
  String get preisLabelStunden => 'Saatlik ücret (€ / saat)';

  @override
  String get preisHintStunden => 'örn. 20';

  @override
  String get preisHinweisVerhandelbar => 'Fiyat karşılıklı anlaşmayla / tekliflere açık';

  @override
  String get preisTypGesamtDesc => 'İş için toplam fiyatı belirtiyorsunuz.';

  @override
  String get preisTypStundenDesc => 'İş için saatlik bir ücret belirtiyorsunuz.';

  @override
  String get preisTypVerhandelbarDesc => 'Fiyat, hizmet sağlayıcı ile doğrudan görüşülerek belirlenir.';

  @override
  String get heimatadresseButtonInfo => 'Kayıtlı ev adresini otomatik doldurmak için buraya tıkla.';

  @override
  String get verhandelbarLabel => 'Pazarlık edilebilir';

  @override
  String get terminValidierungFehler => 'Lütfen bir tarih ve her iki saati seçin.';

  @override
  String get wiederkehrendValidierungFehler => 'Lütfen yinelenen işler için aralığı, haftanın gününü ve tekrar sayısını doğru şekilde seçin.';

  @override
  String priceTotal(Object amount) {
    return '$amount €';
  }

  @override
  String pricePerHour(Object amount, Object hourShort) {
    return '$amount € / $hourShort';
  }

  @override
  String get priceNegotiable => 'Pazarlıklı';

  @override
  String get hourShort => 'sa';

  @override
  String get setNewPasswordTitle => 'Yeni şifreyi belirle';

  @override
  String get setNewPasswordInfo => 'Onaylamak için yeni şifreni iki kez gir.';

  @override
  String get newPasswordLabel => 'Yeni şifre';

  @override
  String get confirmNewPasswordLabel => 'Yeni şifreyi onayla';

  @override
  String get saveNewPasswordButton => 'Yeni şifreyi kaydet';

  @override
  String get passwordEmptyError => 'Şifre boş olamaz.';

  @override
  String get passwordsDontMatch => 'Şifreler eşleşmiyor.';

  @override
  String get passwordResetSuccess => 'Şifre başarıyla sıfırlandı. Şimdi giriş yapabilirsiniz.';

  @override
  String get premiumRestorePurchases => 'Satın alımları geri yükle';

  @override
  String get premiumRetry => 'Tekrar dene';

  @override
  String get wrongRoleCustomer => 'Bu hesap hizmet sağlayıcı olarak kayıtlıdır ve müşteri girişi için kullanılamaz.';

  @override
  String get accountNotRegistered => 'Bu e-posta ile kayıtlı bir hesap bulunamadı. Lütfen önce kayıt olun.';

  @override
  String get wrongCredentials => 'Yanlış e-posta veya şifre.';

  @override
  String get premiumPushDelayFree => 'Push bildirimleri: 1 saat gecikme';

  @override
  String get premiumPushDelaySilver => 'Push bildirimleri: 30 dk gecikme';

  @override
  String get premiumPushDelayGold => 'Push bildirimleri: yeni işlerde anında';

  @override
  String get companyNameOptional => 'Şirket adı (opsiyonel)';

  @override
  String get vatIdOptional => 'KDV Numarası (opsiyonel)';

  @override
  String get bicOptional => 'BIC (opsiyonel)';

  @override
  String get smallBusinessLabel => 'Küçük işletme §19 UStG’ye göre';

  @override
  String get defaultVatRateLabel => 'Standart KDV oranı (%)';

  @override
  String get invalidVatRate => 'Geçersiz KDV oranı';

  @override
  String get profileNameLabel => 'Tam ad';

  @override
  String get invoiceNoShort => 'No:';

  @override
  String get netAmountLabel => 'Net';

  @override
  String vatLabelWithPercent(Object percent) {
    return 'KDV ($percent%)';
  }

  @override
  String get totalLabel => 'Toplam';

  @override
  String get dueOnLabel => 'Vade tarihi:';

  @override
  String get vatIdLabel => 'KDV No:';

  @override
  String get bicLabel => 'BIC:';

  @override
  String paymentTermsDefault(Object days) {
    return '$days gün içinde kesinti olmadan ödenir.';
  }

  @override
  String get badgeInfoText => 'Bu rozetler yalnızca hizmet sağlayıcılar tarafından kazanılabilir ve sağlayıcı işi kabul ettiğinde görünür.';

  @override
  String get noAuftraegeKundeHint => 'İlk işini oluşturmak için artı (+) düğmesine dokun.';

  @override
  String get upsellCardTitle => 'Yakınında bir iş';

  @override
  String upsellCategoryLabel(String category) {
    return 'Kategori: $category';
  }

  @override
  String upsellUpgradeButton(String plan) {
    return 'Bu işi görmek için $plan’a yükselt';
  }

  @override
  String get planFree => 'Ücretsiz';

  @override
  String get planSilver => 'Gümüş';

  @override
  String get planGold => 'Altın';

  @override
  String get filterNeu => 'Yeni';

  @override
  String onlyNewWindowInfo(int hours) {
    return 'Son $hours saat içindeki işleri gösteriyor.';
  }

  @override
  String get cancelLabel => 'İptal';

  @override
  String get editProfileCta => 'Profili tamamla';

  @override
  String get update_required_title => 'Güncelleme gerekli';

  @override
  String get update_required_message => 'Devam etmek için lütfen uygulamayı güncelle.';

  @override
  String get update_available_title => 'Güncelleme mevcut';

  @override
  String get update_available_message => 'Yeni bir sürüm mevcut. Şimdi güncellemek ister misiniz?';

  @override
  String get update_action_update_now => 'Şimdi güncelle';

  @override
  String get update_action_later => 'Daha sonra';

  @override
  String get invoiceSectionSubtitle => 'İsteğe bağlı: otomatik faturalandırma için şirket ve vergi bilgileri';

  @override
  String get marketplaceTitle => 'İş al/sat';

  @override
  String get marketplaceTabSell => 'Sat';

  @override
  String get marketplaceTabBuy => 'Satın al';

  @override
  String get marketplaceOfferCreateCta => 'Bir işi devret';

  @override
  String get marketplaceFilter => 'Filtrele';

  @override
  String get marketplaceSort => 'Sırala';

  @override
  String get marketplaceBuyNow => 'Hemen başvur';

  @override
  String get marketplaceSnackOpenForm => 'Teklif formu açılıyor…';

  @override
  String get marketplaceSnackStartCheckout => 'Ödeme başlatılıyor…';

  @override
  String marketplaceOfferTitle(int index) {
    return 'Teklif #$index';
  }

  @override
  String marketplaceOfferSubtitle(String category, String price, Object distanceKm) {
    return '$category • $distanceKm km';
  }

  @override
  String marketplaceBuyTitle(int index) {
    return '$index. İlan · Küçük onarım';
  }

  @override
  String marketplaceBuySubtitle(String category, String price, String distance) {
    return 'Kategori: $category · $price/saat · $distance km';
  }

  @override
  String get marketplaceEmptyList => 'Uygun teklif bulunamadı.';

  @override
  String get marketplaceErrorLoading => 'Liste yüklenemedi.';

  @override
  String get marketplaceAppliedSuccess => 'Başvuruldu — satıcı başvurunu görebilir.';

  @override
  String get marketplaceAlreadyApplied => 'Zaten başvurdun.';

  @override
  String marketplaceProvisionPercent(Object value) {
    return '$value %';
  }

  @override
  String marketplaceProvisionFixed(Object value) {
    return '$value';
  }

  @override
  String marketplaceChipTargetPrice(Object price) {
    return 'Hedef fiyat: $price';
  }

  @override
  String marketplaceChipProvision(Object value) {
    return 'Komisyon: $value';
  }

  @override
  String get s0Title => 'İşi devret (S0)';

  @override
  String get sectionBasics => 'Temel bilgiler';

  @override
  String get fieldTitle => 'Başlık';

  @override
  String get hintTitleExample => 'ör. Çatı yenileme, 120 m²';

  @override
  String get fieldDescription => 'Açıklama';

  @override
  String get hintDescription => 'Kısa açıklama, özellikler, malzeme dâhil/haric.';

  @override
  String get fieldLocation => 'Konum/yarıçap (şimdilik metin)';

  @override
  String get hintLocation => 'ör. Köln, 15 km';

  @override
  String get pickStartDate => 'Başlangıç tarihi seç';

  @override
  String get pickDeadline => 'Son tarih seç';

  @override
  String get labelStart => 'Başlangıç';

  @override
  String get labelDeadline => 'Son tarih';

  @override
  String get sectionS0PriceProvision => 'S0 – Fiyat & Komisyon';

  @override
  String get tooltipS0PriceProvision => 'Hedef fiyat = işin toplam fiyatı.\nKomisyon = devretme ücreti.';

  @override
  String get fieldTargetPriceEur => 'Hedef fiyat (EUR)';

  @override
  String get hintTargetPriceExample => 'ör. 12.500';

  @override
  String get helpTargetPrice => 'Alıcı tarafından üstlenilecek toplam iş bedeli.';

  @override
  String get fieldProvisionType => 'Komisyon türü';

  @override
  String get provisionTypePercent => 'Yüzde';

  @override
  String get provisionTypeFixed => 'Sabit';

  @override
  String get fieldProvisionValuePercent => 'Komisyon değeri (%)';

  @override
  String get fieldProvisionValueFixed => 'Komisyon değeri (€)';

  @override
  String get helpProvisionPercent => 'Yaygın: %5–12 (üst sınır mümkün).';

  @override
  String get helpProvisionFixed => 'Sabit komisyon tutarı.';

  @override
  String get fieldProvisionDue => 'Komisyon ne zaman ödenir?';

  @override
  String get provisionDueAward => 'ihale verildiğinde';

  @override
  String get provisionDueHandover => 'teslimde';

  @override
  String get provisionDueFinalInvoice => 'nihai faturada';

  @override
  String get provisionDueAwardHelp => 'İhale verildiğinde: komisyon, ihalenin verilmesinin hemen ardından tahakkuk eder.';

  @override
  String get provisionDueHandoverHelp => 'Teslimde: müşteri onayı ve teslimden sonra ödenir.';

  @override
  String get provisionDueFinalInvoiceHelp => 'Nihai faturada: alıcı işi tamamladığında ödenir.';

  @override
  String get sectionEvidencePlaceholder => 'Kanıtlar (yer tutucu)';

  @override
  String get btnUploadEvidence => 'Teklif/Müşteri onayı yükle';

  @override
  String get btnCreateDraft => 'Taslak oluştur';

  @override
  String get btnSaving => 'Kaydediliyor…';

  @override
  String get noteSupabaseActive => 'Not: Supabase kaydı aktif. Ödemeler ve yüklemeler daha sonra eklenecek.';

  @override
  String get formErrorRequired => 'Zorunlu alan';

  @override
  String get formErrorInvalidAmount => 'Geçersiz tutar';

  @override
  String get formErrorGreaterZero => '0\'dan büyük olmalı';

  @override
  String get formErrorRealistic => 'Lütfen gerçekçi olun';

  @override
  String get formErrorInvalidValue => 'Geçersiz değer';

  @override
  String get formErrorPercentRange => 'İzin verilen aralık: %0–30';

  @override
  String get errPickStartDate => 'Lütfen başlangıç tarihi seçin';

  @override
  String get errPickDeadline => 'Lütfen son tarih seçin';

  @override
  String get draftSaved => 'S0 taslağı kaydedildi.';

  @override
  String get genericError => 'Bir şeyler ters gitti.';

  @override
  String get btnMyDeals => 'İşlerim';

  @override
  String get myDealsTitle => 'İşlerim';

  @override
  String get myDealsEmpty => 'Henüz iş yok.';

  @override
  String get myDealsErrorLoading => 'İşlerin yüklenemedi.';

  @override
  String get filterAll => 'Tümü';

  @override
  String get filterDraft => 'Taslaklar';

  @override
  String get filterLive => 'Yayında';

  @override
  String get filterAwarded => 'Verildi';

  @override
  String get manageTitle => 'İşi yönet';

  @override
  String get manageErrorLoading => 'Ayrıntılar yüklenemedi.';

  @override
  String get btnPublish => 'Yayınla';

  @override
  String get publishSuccess => 'İş yayınlandı.';

  @override
  String get applicationsTitle => 'Başvurular';

  @override
  String get applicationsEmpty => 'Henüz başvuru yok.';

  @override
  String get applicationNote => 'Not';

  @override
  String get applicationStatusPending => 'Durum: beklemede';

  @override
  String get applicationStatusAwarded => 'Durum: verildi';

  @override
  String get btnAward => 'Ver';

  @override
  String get btnManage => 'Yönet';

  @override
  String get labelStatus => 'Durum';

  @override
  String get statusDraft => 'Taslak';

  @override
  String get statusLive => 'Yayında';

  @override
  String get statusAwarded => 'Verildi';

  @override
  String get awardSuccess => 'Başvuru başarıyla verildi.';

  @override
  String get snackNewApplication => 'Yeni başvuru alındı';

  @override
  String applicationsCount(Object count) {
    return '$count başvuru';
  }

  @override
  String get btnApplied => 'Başvuruldu';

  @override
  String get s0EditTitle => 'S0\'ı düzenle';

  @override
  String get publishNow => 'Kaydettikten sonra yayımla';

  @override
  String get publishNowHint => 'Etkinse, taslak kaydedildikten sonra \"Yayında\" durumuna alınır.';

  @override
  String get btnSaveChanges => 'Değişiklikleri kaydet';

  @override
  String get saved => 'Kaydedildi';

  @override
  String get marketplaceLocationLoadedFromProfile => 'Konum profilinden yüklendi — yarıçap filtresi aktif.';

  @override
  String get marketplaceNoHomeAddressHint => 'Profilde adres yok — mesafe filtresi olmadan tüm teklifler gösteriliyor.';

  @override
  String get fieldCategory => 'Kategori';

  @override
  String get categoryAll => 'Tümü';

  @override
  String get categoryRoofer => 'Çatı ustası / Çatı kaplama';

  @override
  String get categorySolar => 'PV / Güneş enerjisi';

  @override
  String get categoryHVAC => 'Isıtma / Sıhhi tesisat / HVAC';

  @override
  String get categoryElectrical => 'Elektrik';

  @override
  String get categoryDrywall => 'Alçıpan';

  @override
  String get categoryPainter => 'Boyacı';

  @override
  String get categoryTiling => 'Fayans / Seramik';

  @override
  String get categoryFlooring => 'Zemin kaplama';

  @override
  String get categoryWindowsDoors => 'Pencere & Kapı';

  @override
  String get categoryInsulationFacade => 'Yalıtım & Cephe';

  @override
  String get categoryMasonryConcrete => 'Duvarcılık & Beton';

  @override
  String get categoryCarpentryJoinery => 'Marangozluk & Doğrama';

  @override
  String get categoryLandscaping => 'Peyzaj & Bahçe';

  @override
  String get categoryScaffolding => 'İskele';

  @override
  String get categoryCleaningRestoration => 'Temizlik & Restorasyon';

  @override
  String get categoryMovingTransport => 'Taşıma & Nakliyat';

  @override
  String get sectionCustomerOk => 'Müşteri onayı';

  @override
  String get helpCustomerOk => 'Müşterinin devre onay verdiğine dair kanıt (ör. imzalı teklif, e-posta/SMS PDF/foto).';

  @override
  String get btnUploadCustomerOk => 'Müşteri onayı yükle';

  @override
  String get customerNameOptional => 'Müşteri adı (opsiyonel)';

  @override
  String get customerPhoneOptional => 'Telefon (opsiyonel)';

  @override
  String get sectionOffer => 'Teklif / Sipariş onayı';

  @override
  String get helpOfferOptional => 'Teklifin veya sipariş onayın. Opsiyonel ama alıcılar için faydalı.';

  @override
  String get btnUploadOffer => 'Teklif yükle';

  @override
  String get errCustomerOkRequired => 'Yayınlamak için en az bir müşteri onayı belgesi gerekir.';

  @override
  String get warnMissingDocsBody => 'Bilgi: Onay/teklif olmadan daha sonra yayınlayamazsın. Belgeleri istediğin zaman ekleyebilirsin.';

  @override
  String get attestLabel => 'Müşterinin devre onayını verdiğini ve tüm bilgilerin doğru olduğunu dürüstçe onaylıyorum.';

  @override
  String get attestConsequences => 'Yanlış beyanda hesap askıya alma, ödemeleri tutma ve gerekli durumlarda hukuki/cezai işlemler uygulanabilir.';

  @override
  String get errAttestRequired => 'Yayınlamak için onay kutusunu işaretlemelisin.';

  @override
  String get genericPleaseFix => 'Lütfen vurgulanan alanları düzeltin:';

  @override
  String get errAwardNeedsDoc => 'Vade \"ihale/verilişte\" ise belge/teklif zorunludur.';

  @override
  String get errNotOwner => 'Bu işin sahibi değilsiniz.';

  @override
  String get errPublishOnlyFromDraft => 'Yayınlama sadece taslak durumundan mümkündür.';

  @override
  String get publishRequirementsTitle => 'Yayınlama gereksinimleri';

  @override
  String get infoReqCustomerOk => 'En az bir müşteri onayı eklendi.';

  @override
  String get infoReqDocForAward => '\"Verilişte\": teklif/sipariş onayı yükleyin.';

  @override
  String get infoReqAttest => 'Formdaki onay kutusu işaretli.';

  @override
  String get draftChecklistTitle => 'Yayın öncesi kontrol listesi';

  @override
  String get chkTitle => 'Başlık dolduruldu';

  @override
  String get chkDescription => 'Açıklama dolduruldu';

  @override
  String get chkLocation => 'Adres/konum ayarlandı';

  @override
  String get chkTargetPrice => 'Hedef fiyat ayarlandı';

  @override
  String get chkCustomerOk => 'Müşteri onayı mevcut';

  @override
  String get chkDocIfAward => 'Belge/teklif mevcut (\"verilişte\" önerilir)';

  @override
  String get chkAttestAtPublish => 'Yayınlarken onay kutusunu işaretleyin';

  @override
  String get draftChecklistCta => 'Yönetime git';

  @override
  String get uploadSuccess => 'Yükleme başarılı.';

  @override
  String get uploadInProgress => 'Yükleniyor...';

  @override
  String get uploadFailed => 'Yükleme başarısız.';

  @override
  String get draftDefaultTitle => 'Taslak';

  @override
  String get errGeocodingFailed => 'Adres jeokodlanamadı.';

  @override
  String get provisionDueAwardLabel => 'Görevlendirme';

  @override
  String get provisionDueHandoverLabel => 'Devir';

  @override
  String get provisionDueFinalInvoiceLabel => 'Nihai fatura';

  @override
  String get sectionPreviewPublic => 'Önizleme (herkese açık)';

  @override
  String get tooltipPreviewPublic => 'Bu dosyalar satın almadan önce alıcılara görünür. Yalnızca karartılmış/anonimleştirilmiş önizlemeler yükleyin.';

  @override
  String get btnUploadPreview => 'Önizleme yükle';

  @override
  String get previewRedactionNoticeTitle => 'Önizleme hakkında önemli uyarı';

  @override
  String get previewRedactionNoticeBody => 'Önizlemeler satın alma öncesinde alıcılara görünür. Hassas verileri karartın (ör. ad, adres, telefon, sözleşme/müşteri no, imzalar, QR/çubuk kodlar). Karartılmamış kişisel veri içeren belgeler yüklemeyin.';

  @override
  String get hintPhoneExample => '+90 530 123 45 67';

  @override
  String get createDealTitle => 'Teklif oluştur';

  @override
  String get chooseDealTypeTitle => 'Teklif türünü seç';

  @override
  String get dealTypeS0Title => 'S0 – İşin tamamını devret';

  @override
  String get dealTypeS0Subtitle => 'Tüm işi başka bir hizmet sağlayıcıya devredin.';

  @override
  String get dealTypeS1Title => 'S1 – Alt kapsam/Alt yüklenici (kilometre taşları)';

  @override
  String get dealTypeS1Subtitle => 'Kilometre taşları ve kanıtlarla alt yüklenici işi.';

  @override
  String get s1Title => 'Alt yüklenici ara (S1)';

  @override
  String get sectionS1Pricing => 'Fiyatlandırma';

  @override
  String get sectionS1Provision => 'Komisyon';

  @override
  String get sectionMilestones => 'Aşamalar';

  @override
  String get pricingModeFixed => 'Sabit fiyat';

  @override
  String get pricingModeTm => 'Zaman ve Malzeme';

  @override
  String get basePriceLabel => 'Toplam bütçe (€)';

  @override
  String get hourlyRateLabel => 'Saatlik ücret (€)';

  @override
  String get expectedHoursLabel => 'Tahmini saat';

  @override
  String get dueTypeAward => 'Beauftragung';

  @override
  String get dueTypeDate => 'Tarih';

  @override
  String get dueTypeHandover => 'Teslim';

  @override
  String get dueTypeCustom => 'Özel';

  @override
  String get dueTypeCustomHelp => 'Özel vade tetikleyicisi (lütfen tarih/açıklama ekleyin).';

  @override
  String get milestoneLabel => 'Aşama';

  @override
  String get milestoneTitle => 'Aşama başlığı';

  @override
  String get milestoneDescription => 'Aşama açıklaması';

  @override
  String get milestoneAmount => 'Tutar (€)';

  @override
  String get milestonePercent => 'Yüzde (%)';

  @override
  String get milestoneDue => 'Vade';

  @override
  String get btnAddMilestonePercent => 'Aşama ekle (%)';

  @override
  String get btnAddMilestoneAmount => 'Aşama ekle (€)';

  @override
  String get milestoneEmptyHint => 'Henüz aşama yok (isteğe bağlı).';

  @override
  String get milestoneBlocking => 'Bloklayan';

  @override
  String get milestoneBlockingHelp => 'Sonraki adım açılmadan önce tamamlanması gerekir.';

  @override
  String get validationMilestoneSum => 'Aşama toplamları uymuyor: yüzde modunda toplam 100% olmalı; sabit fiyatta toplam bütçeye eşit olmalı.';

  @override
  String get btnReorder => 'Yeniden sırala';

  @override
  String get infoS1PricingHelp => 'Alt yüklenici işi için fiyatlandırma. “Sabit fiyat” = iş kapsamı için tek bir toplam bütçe. “Zaman ve malzeme” = saatlik ücret + tahmini saat; faturalama harcanan gerçek zamana göredir.';

  @override
  String get infoS1ProvisionHelp => 'Atanan her alt yüklenici için aracılık/yonetim komisyonun. Yüzde veya sabit tutar ve vade zamanını belirle.';

  @override
  String get coordChipNoCoords => 'Koordinat yok';

  @override
  String get coordMissingLabel => 'Koordinatlar (enlem/boylam)';

  @override
  String get s0DetailsMissingLabel => 'S0 ayrıntıları';

  @override
  String get s1DetailsMissingLabel => 'S1 ayrıntıları';

  @override
  String get marketplaceTypeS0 => 'S0 – İş devri';

  @override
  String get marketplaceTypeS1 => 'S1 – Taşeron arama';

  @override
  String get filterTypeAll => 'Tüm türler';

  @override
  String get filterTypeS0 => 'Yalnızca S0';

  @override
  String get filterTypeS1 => 'Yalnızca S1';

  @override
  String get badgeAwardedToYou => 'Sana verildi';

  @override
  String get badgeAwardedGiven => 'Atama yapıldı';

  @override
  String get btnAssigned => 'Atandı';

  @override
  String get marketplaceOwnDealPill => 'Senin işin';
}
