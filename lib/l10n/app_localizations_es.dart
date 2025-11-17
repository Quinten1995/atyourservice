// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get registerAppBar => 'Registro';

  @override
  String get registerTitle => 'Registrarse';

  @override
  String get roleLabel => 'Selecciona un rol';

  @override
  String get roleKunde => 'Cliente';

  @override
  String get roleDienstleister => 'Proveedor de servicios';

  @override
  String get categoryLabel => 'Categoría';

  @override
  String get categoryValidator => 'Por favor selecciona una categoría';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get emailEmpty => 'Por favor ingresa un correo electrónico';

  @override
  String get emailInvalid => 'Por favor ingresa un correo electrónico válido';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordEmpty => 'Por favor ingresa una contraseña';

  @override
  String get passwordTooShort => 'La contraseña debe tener al menos 8 caracteres.';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get registerSuccess => '¡Registro exitoso! Por favor confirma tu correo electrónico.';

  @override
  String get registerExists => 'Este correo electrónico ya está registrado. Por favor inicia sesión o restablece tu contraseña.';

  @override
  String get registerInvalidEmail => 'Por favor ingresa una dirección de correo válida.';

  @override
  String get registerPasswordShort => 'La contraseña debe tener al menos 6 caracteres.';

  @override
  String registerFailed(Object error) {
    return 'Error en el registro: $error';
  }

  @override
  String registerUnknownError(Object error) {
    return 'Error desconocido: $error';
  }

  @override
  String get profileAppBar => 'Perfil del proveedor';

  @override
  String get profileAddressLabel => 'Dirección de domicilio (ej. Calle Ejemplo 12, 12345 Ciudad Ejemplo)';

  @override
  String get profileAddressEmpty => 'Por favor ingresa la dirección';

  @override
  String get profileSaveButton => 'Guardar perfil';

  @override
  String get profileAddressSaved => '¡Dirección guardada!';

  @override
  String profileLoadError(Object error) {
    return 'Error al cargar: $error';
  }

  @override
  String profileSaveError(Object error) {
    return 'Error al guardar: $error';
  }

  @override
  String get notLoggedIn => 'No has iniciado sesión';

  @override
  String get pleaseLogin => 'Por favor inicia sesión primero';

  @override
  String get changeNotAllowedTitle => 'Cambio no permitido';

  @override
  String changeNotAllowedContent(Object date) {
    return 'Como usuario gratuito, solo puedes cambiar tu categoría o dirección cada 20 días.\nPróximo cambio permitido desde: $date';
  }

  @override
  String get ok => 'OK';

  @override
  String get profileSaved => '¡Perfil guardado con éxito!';

  @override
  String get changeProfileImage => 'Cambiar foto de perfil';

  @override
  String get upgradeToPremium => 'Actualizar a Premium';

  @override
  String get noRatingsYet => 'Sin valoraciones aún';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get nameValidator => 'Por favor ingresa el nombre';

  @override
  String get descriptionLabel => 'Descripción del servicio:';

  @override
  String get addressLabel => 'Dirección (ej. calle, código postal, ciudad)';

  @override
  String get phoneLabel => 'Teléfono';

  @override
  String get phoneValidator => 'Por favor ingresa un número de teléfono';

  @override
  String get emailEmptyValidator => 'Por favor ingresa tu correo electrónico';

  @override
  String get emailInvalidValidator => 'Por favor ingresa un correo válido';

  @override
  String errorPrefix(Object error) {
    return 'Error: $error';
  }

  @override
  String changeLimitHint(Object date) {
    return 'La categoría/dirección solo podrá ser cambiada a partir del $date.';
  }

  @override
  String get addressNotFound => 'Dirección no encontrada. Por favor verifica.';

  @override
  String ratingsCount(Object count) {
    return '($count valoraciones)';
  }

  @override
  String get premiumAppBar => 'Actualizar a Premium';

  @override
  String get premiumChoosePlan => 'Elige tu plan Premium';

  @override
  String get premiumCurrentPlan => 'Suscripción actual:';

  @override
  String get premiumFreePrice => 'gratis';

  @override
  String get premiumSilverPrice => '4,99 € / mes';

  @override
  String get premiumGoldPrice => '9,99 € / mes';

  @override
  String get premiumFreeFeature1 => 'Aceptar 1 trabajo por semana';

  @override
  String get premiumFreeFeature2 => 'Trabajos en un radio de 5 km';

  @override
  String get premiumFreeFeature3 => 'Solo categorías básicas';

  @override
  String get premiumFreeFeature4 => 'Cambio de categoría solo cada 20 días';

  @override
  String get premiumSilverFeature1 => 'Aceptar 2 encargos por semana';

  @override
  String get premiumSilverFeature2 => 'Trabajos en un radio de 15 km';

  @override
  String get premiumSilverFeature3 => 'Todas las categorías disponibles';

  @override
  String get premiumGoldFeature1 => 'Aceptar 5 encargos por semana';

  @override
  String get premiumGoldFeature2 => 'Trabajos en un radio de 30 km';

  @override
  String get premiumGoldFeature3 => 'Todas las categorías disponibles';

  @override
  String get premiumGoldFeature4 => 'Distintivo de usuario premium (visible para los clientes)';

  @override
  String premiumChooseButton(Object title) {
    return 'Elegir $title';
  }

  @override
  String get premiumPaymentNote => 'Nota: Todos los pagos se procesan de forma segura a través de Apple o Google. Puedes cancelar o gestionar tu suscripción en cualquier momento en la tienda.';

  @override
  String get premiumSilverComingSoon => '¡Silver pronto disponible!';

  @override
  String get premiumGoldComingSoon => '¡Gold pronto disponible!';

  @override
  String get auftragHidden => 'Trabajo oculto.';

  @override
  String auftragHideError(Object error) {
    return 'Error al ocultar el trabajo: $error';
  }

  @override
  String get meineAuftraegeAppBar => 'Mis trabajos';

  @override
  String get refreshTooltip => 'Actualizar';

  @override
  String get noAuftraegeFound => 'No se encontraron trabajos.';

  @override
  String get geplanterAuftrag => 'Trabajo programado';

  @override
  String get auftragAusblenden => 'Ocultar trabajo';

  @override
  String get loginFailedDetails => 'Error al iniciar sesión. Por favor verifica tus datos o confirma tu correo electrónico.';

  @override
  String get loginSuccess => '¡Inicio de sesión exitoso!';

  @override
  String loginFailedPrefix(Object error) {
    return 'Error de inicio de sesión: $error';
  }

  @override
  String loginUnknownError(Object error) {
    return 'Error desconocido: $error';
  }

  @override
  String get emailValidatorEmpty => 'Por favor ingresa un correo electrónico';

  @override
  String get emailValidatorInvalid => 'Por favor ingresa un correo electrónico válido';

  @override
  String get passwordValidatorEmpty => 'Por favor ingresa una contraseña';

  @override
  String get passwordValidatorShort => 'La contraseña debe tener al menos 6 caracteres';

  @override
  String get loginKundeAppBar => 'Inicio de sesión para clientes';

  @override
  String get loginKundeHeadline => 'Iniciar sesión';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get noAccountYet => '¿No tienes cuenta? Regístrate ahora';

  @override
  String get loginFailedDetailsDL => 'Error al iniciar sesión. Por favor verifica tus datos o confirma tu correo electrónico.';

  @override
  String get wrongRoleDL => 'Esta cuenta no es un proveedor de servicios. Por favor usa el inicio de sesión para clientes.';

  @override
  String get loginDLAppBar => 'Inicio de sesión para proveedores';

  @override
  String get loginDLHeadline => 'Iniciar sesión';

  @override
  String get kundenDashboardHeader => 'Tu panel';

  @override
  String get kundenDashboardAppBar => 'Panel de clientes';

  @override
  String get laufendeAuftraege => 'Trabajos en curso';

  @override
  String statusPrefix(Object status) {
    return 'Estado: $status';
  }

  @override
  String dienstleisterPrefix(Object dienstleister) {
    return 'Proveedor: $dienstleister';
  }

  @override
  String get offeneAuftraege => 'Trabajos abiertos';

  @override
  String get noOffeneAuftraege => 'No se encontraron trabajos abiertos.';

  @override
  String get abgeschlosseneAuftraege => 'Trabajos completados';

  @override
  String get abgeschlossenStatus => 'Completado';

  @override
  String get neuerAuftrag => 'Nuevo trabajo';

  @override
  String get pleaseCreateProfile => 'Por favor crea tu perfil primero.';

  @override
  String get profilMissingCategory => 'Falta categoría en el perfil.';

  @override
  String get dienstleisterDashboardHeader => 'Tu panel';

  @override
  String get dienstleisterDashboardAppBar => 'Panel de proveedores';

  @override
  String get meineLaufendenAuftraege => 'Mis trabajos en curso';

  @override
  String kundePrefix(Object kunde) {
    return 'Cliente: $kunde';
  }

  @override
  String get offenePassendeAuftraege => 'Trabajos abiertos que coinciden';

  @override
  String get noPassendeAuftraege => 'No se encontraron trabajos que coincidan.';

  @override
  String entfernungSuffix(Object dist) {
    return 'a $dist km';
  }

  @override
  String get auftragBereitsBewertet => 'Ya has valorado este trabajo.';

  @override
  String get bewertungDialogTitle => 'Calificar proveedor de servicios';

  @override
  String get bewertungKommentarLabel => 'Comentario (opcional)';

  @override
  String get abbrechen => 'Cancelar';

  @override
  String get abschicken => 'Enviar';

  @override
  String get auftragErstellenTitle => 'Crear nuevo trabajo';

  @override
  String get auftragEinstellenUeberschrift => 'Publicar trabajo ahora';

  @override
  String get titelLabel => 'Título';

  @override
  String get titelValidator => 'Por favor ingresa un título';

  @override
  String get beschreibungLabel => 'Descripción';

  @override
  String get kategorieLabel => 'Categoría';

  @override
  String get heimatadresseEinfuegen => 'Insertar dirección de domicilio';

  @override
  String get adresseLabel => 'Dirección (ej. Alter Markt 76, 50667 Colonia)';

  @override
  String get telefonnummerLabel => 'Número de teléfono';

  @override
  String get telefonnummerValidator => 'Por favor ingresa un número de teléfono';

  @override
  String get ausfuehrungszeitpunkt => 'Hora de ejecución';

  @override
  String get soSchnellWieMoeglich => 'Lo antes posible';

  @override
  String get geplant => 'Programado';

  @override
  String get datumWaehlen => 'Elegir fecha';

  @override
  String get zeitVon => 'Hora desde';

  @override
  String get zeitBis => 'Hora hasta';

  @override
  String get wiederkehrendCheckbox => '¿Trabajo recurrente?';

  @override
  String get intervallLabel => 'Intervalo';

  @override
  String get intervallValidator => 'Por favor selecciona un intervalo';

  @override
  String get wochentagLabel => 'Día de la semana';

  @override
  String get wochentagValidator => 'Por favor selecciona un día de la semana';

  @override
  String get anzahlWiederholungenLabel => 'Número de repeticiones (opcional)';

  @override
  String get wiederholenBisNichtGesetzt => 'Repetir hasta: no definido';

  @override
  String wiederholenBisLabel(Object date) {
    return 'Repetir hasta: $date';
  }

  @override
  String get auftragAbschicken => 'Enviar trabajo';

  @override
  String get auftragGespeichert => '¡Trabajo guardado!';

  @override
  String get bitteEinloggen => 'Por favor inicia sesión primero';

  @override
  String get adresseNichtGefunden => 'Dirección no encontrada.';

  @override
  String unbekannterFehler(Object error) {
    return 'Error desconocido: $error';
  }

  @override
  String get auftragDetailTitle => 'Detalles del trabajo';

  @override
  String get nichtEingeloggt => 'No ha iniciado sesión';

  @override
  String get rolleNichtErmittelt => 'No se pudo determinar el rol';

  @override
  String get auftragNichtGefunden => 'Trabajo no encontrado';

  @override
  String get bewertungDanke => '¡Gracias por tu valoración!';

  @override
  String get limitErreicht => 'Límite alcanzado';

  @override
  String get limitFree => 'Como proveedor freemium, puedes aceptar hasta 2 trabajos por semana. ¡Actualiza a Silver o Gold para más opciones!';

  @override
  String get limitSilver => 'Como proveedor Silver, puedes aceptar hasta 5 trabajos por semana. ¡Actualiza a Gold para trabajos ilimitados!';

  @override
  String get auftragAnnehmen => 'Aceptar trabajo';

  @override
  String get auftragBeenden => 'Finalizar trabajo';

  @override
  String get auftragEntfernenUebersicht => 'Eliminar trabajo de la vista general';

  @override
  String get auftragEntfernen => 'Eliminar trabajo';

  @override
  String get auftragEntfernenTitel => '¿Eliminar trabajo?';

  @override
  String get auftragEntfernenText => '¿Quieres eliminar este trabajo de tu vista general?';

  @override
  String get entfernen => 'Eliminar';

  @override
  String get keineDatenVerfuegbar => 'No hay datos disponibles';

  @override
  String get beschreibung => 'Descripción:';

  @override
  String get kategorie => 'Categoría:';

  @override
  String get adresse => 'Dirección:';

  @override
  String get status => 'Estado:';

  @override
  String jedenWochentag(Object wochentag) {
    return 'Cada $wochentag';
  }

  @override
  String bisDatum(Object datum) {
    return 'hasta $datum';
  }

  @override
  String get malSuffix => 'veces';

  @override
  String kontaktZuLabel(Object label) {
    return 'Contacto con $label:';
  }

  @override
  String get nummerKopiert => '¡Número copiado!';

  @override
  String get nummerKopieren => 'Copiar número';

  @override
  String get anrufen => 'Llamar';

  @override
  String fehlerPrefix(Object error) {
    return 'Error: $error';
  }

  @override
  String get editProfileTooltip => 'Editar perfil';

  @override
  String get appTitle => 'AtYourService';

  @override
  String get hello => '¡Bienvenido!';

  @override
  String get kundeButton => 'Busco un proveedor de servicios';

  @override
  String get dienstleisterButton => 'Soy un proveedor de servicios';

  @override
  String get category_babysitter => 'Niñera / Cuidado de niños';

  @override
  String get category_catering => 'Catering';

  @override
  String get category_dachdecker => 'Techador';

  @override
  String get category_elektriker => 'Electricista';

  @override
  String get category_ernaehrungsberatung => 'Asesoría nutricional';

  @override
  String get category_eventplanung => 'Planificación de eventos';

  @override
  String get category_fahrdienste => 'Servicios de transporte';

  @override
  String get category_fahrlehrer => 'Instructor de conducción';

  @override
  String get category_fensterputzer => 'Limpiador de ventanas';

  @override
  String get category_fliesenleger => 'Colocador de azulejos';

  @override
  String get category_fotografie => 'Fotografía / Videografía';

  @override
  String get category_friseur => 'Peluquero/a';

  @override
  String get category_gartenpflege => 'Cuidado del jardín / Corte de césped';

  @override
  String get category_grafikdesign => 'Diseño gráfico';

  @override
  String get category_handy_reparatur => 'Reparación de móviles/tablets';

  @override
  String get category_haushaltsreinigung => 'Limpieza del hogar';

  @override
  String get category_hausmeisterservice => 'Servicio de portería';

  @override
  String get category_heizungsbauer => 'Instalador de calefacción';

  @override
  String get category_hundesitter => 'Paseador de perros / Cuidado de perros';

  @override
  String get category_it_support => 'Soporte informático';

  @override
  String get category_klempner => 'Fontanero';

  @override
  String get category_kosmetik => 'Esteticista';

  @override
  String get category_kuenstler => 'Artista (p.ej. músico para eventos)';

  @override
  String get category_kurierdienst => 'Servicio de mensajería';

  @override
  String get category_maler => 'Pintor';

  @override
  String get category_massagen => 'Masajes';

  @override
  String get category_maurer => 'Albañil';

  @override
  String get category_moebelaufbau => 'Montaje de muebles';

  @override
  String get category_musikunterricht => 'Clases de música';

  @override
  String get category_nachhilfe => 'Clases particulares';

  @override
  String get category_nagelstudio => 'Salón de uñas';

  @override
  String get category_pc_reparatur => 'Reparación de PC/portátiles';

  @override
  String get category_partyservice => 'Servicio para fiestas';

  @override
  String get category_personal_trainer => 'Entrenador personal';

  @override
  String get category_rasenmaeher_service => 'Mantenimiento de jardines / Paisajismo';

  @override
  String get category_rechtsberatung => 'Asesoría jurídica';

  @override
  String get category_reparaturdienste => 'Servicios de reparación';

  @override
  String get category_seniorenbetreuung => 'Cuidado de mayores';

  @override
  String get category_social_media => 'Gestión de redes sociales';

  @override
  String get category_sonstige => 'Otros servicios';

  @override
  String get category_sprachunterricht => 'Clases de idiomas';

  @override
  String get category_steuerberatung => 'Asesoría fiscal';

  @override
  String get category_tischler => 'Carpintero';

  @override
  String get category_transport => 'Transporte y movilidad';

  @override
  String get category_umzugstransporte => 'Transporte de mudanzas';

  @override
  String get category_umzugshelfer => 'Ayudante de mudanza';

  @override
  String get category_uebersetzungen => 'Traducciones';

  @override
  String get category_waescheservice => 'Servicio de lavandería';

  @override
  String get category_webdesign => 'Diseño web';

  @override
  String get category_einkaufsservice => 'Servicio de compras';

  @override
  String get category_haustierbetreuung => 'Cuidado de mascotas';

  @override
  String get premiumBadgeLabel => 'Premium';

  @override
  String get statusOffen => 'Abierto';

  @override
  String get statusInBearbeitung => 'En progreso';

  @override
  String get statusAbgeschlossen => 'Completado';

  @override
  String get privacyButton => 'Privacidad';

  @override
  String get interval_weekly => 'Semanal';

  @override
  String get interval_biweekly => 'Cada 2 semanas';

  @override
  String get interval_monthly => 'Mensual';

  @override
  String get weekday_monday => 'Lunes';

  @override
  String get weekday_tuesday => 'Martes';

  @override
  String get weekday_wednesday => 'Miércoles';

  @override
  String get weekday_thursday => 'Jueves';

  @override
  String get weekday_friday => 'Viernes';

  @override
  String get weekday_saturday => 'Sábado';

  @override
  String get weekday_sunday => 'Domingo';

  @override
  String get kundenInfoBanner => 'Has iniciado sesión como cliente. Describe aquí el servicio que necesitas. Los proveedores de servicios te enviarán ofertas.';

  @override
  String get titelHint => 'p. ej. limpiar mi apartamento';

  @override
  String get beschreibungHint => 'Describe lo que se debe hacer – p. ej. limpiar 3 habitaciones, cocina y baño ...';

  @override
  String get invoiceSectionTitle => 'Datos de facturación (solo Gold)';

  @override
  String get invoiceNameLabel => 'Nombre en la factura (por ejemplo, nombre de empresa)';

  @override
  String get invoiceAddressLabel => 'Dirección de facturación:';

  @override
  String get invoiceTaxNumberLabel => 'Número fiscal (opcional)';

  @override
  String get invoiceIbanLabel => 'IBAN (opcional)';

  @override
  String get invoiceLogoUrlLabel => 'URL del logotipo (opcional)';

  @override
  String get invoiceGoldInfo => 'Los datos de facturación se pueden editar con el plan GOLD.';

  @override
  String get rechnungGenerierenButtonLabel => 'Generar factura';

  @override
  String get meineAbgeschlossenenAuftraege => 'Mis pedidos completados';

  @override
  String get verbergenButtonLabel => 'Ocultar';

  @override
  String get rechnungGenerierenAppBar => 'Generar factura';

  @override
  String get rechnungAlsPdfAnzeigenLabel => 'Mostrar factura en PDF';

  @override
  String get invoiceLabel => 'Factura';

  @override
  String get fromLabel => 'De:';

  @override
  String get taxNumberLabel => 'Número fiscal:';

  @override
  String get ibanLabel => 'IBAN:';

  @override
  String get toLabel => 'Para:';

  @override
  String get amountLabel => 'Importe:';

  @override
  String get dateLabel => 'Fecha:';

  @override
  String get generatedByText => 'Esta factura fue generada automáticamente a través de AtYourService.';

  @override
  String get currencyLabel => 'Moneda';

  @override
  String get amountRequired => 'Por favor, introduce una cantidad válida.';

  @override
  String get premiumGoldInvoiceFeature => 'Generación de factura en PDF';

  @override
  String get onlyForGoldTooltip => 'Esta función está disponible solo para suscriptores Gold.';

  @override
  String get deleteJobTooltip => 'Eliminar trabajo de la lista';

  @override
  String get invoiceNumberLabel => 'Número de factura';

  @override
  String get invoiceProfileHint => 'Por favor, introduce tus datos de facturación en tu perfil. Estos se incluirán automáticamente en la factura PDF.';

  @override
  String get auftragErneutPosten => 'Volver a publicar el encargo';

  @override
  String get auftragErneutPostenTitle => '¿Volver a publicar este encargo?';

  @override
  String get auftragErneutPostenText => 'El proveedor actual será eliminado. El encargo volverá a estar visible para otros. ¿Deseas continuar?';

  @override
  String get auftragErneutGepostet => 'El encargo se ha vuelto a publicar.';

  @override
  String get premiumActivated => '¡Suscripción activada correctamente!';

  @override
  String premiumPurchaseFailed(Object error) {
    return 'La compra ha fallado: $error';
  }

  @override
  String get premiumProductNotFound => '¡Producto no encontrado!';

  @override
  String get premiumStoreNotLoaded => 'No se pudieron cargar los productos de la tienda.';

  @override
  String premiumYearlySuffix(Object price) {
    return 'Anual: $price';
  }

  @override
  String premiumYearlyButton(Object plan) {
    return '$plan (Anual)';
  }

  @override
  String get deleteAccountTitle => 'Eliminar cuenta';

  @override
  String get deleteAccountWarning => '¿Seguro que deseas eliminar tu cuenta de forma permanente? Todos tus datos se eliminarán de forma irreversible.';

  @override
  String get deleteAccountButton => 'Eliminar cuenta';

  @override
  String get accountDeleted => 'Tu cuenta ha sido eliminada.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get premiumDeactivated => 'Premium desactivado.';

  @override
  String acceptedByLabel(Object name) {
    return 'Aceptado por $name';
  }

  @override
  String get adresseValidator => 'Por favor, introduce una dirección.';

  @override
  String get abgeschlosseneAuftraegeHinweis => 'Aquí puedes eliminar trabajos completados y valorar a tu proveedor de servicios.';

  @override
  String get goldBadgeLabel => 'Suscripción Gold';

  @override
  String get silverBadgeLabel => 'Suscripción Silver';

  @override
  String get topBewertetBadgeLabel => 'Mejor valorado';

  @override
  String get badgeCertified => 'Certificado';

  @override
  String get badgeExperienced => 'Experimentado';

  @override
  String get badgeExpert => 'Experto';

  @override
  String get badgeMaster => 'Maestro';

  @override
  String badgeCertifiedCounter(Object count) {
    return '$count trabajos completados';
  }

  @override
  String badgeExperiencedCounter(Object count) {
    return '$count trabajos completados';
  }

  @override
  String badgeExpertCounter(Object count) {
    return '$count trabajos completados';
  }

  @override
  String badgeMasterCounter(Object count) {
    return '$count trabajos completados';
  }

  @override
  String get achievementTitle => 'Logros y Insignias';

  @override
  String get goldBadgeDesc => 'Tienes una suscripción Gold y puedes aceptar trabajos ilimitados.';

  @override
  String get silverBadgeDesc => 'Tienes una suscripción Silver y puedes aceptar 3 trabajos por semana.';

  @override
  String get topBewertetBadgeDesc => 'Obtén una media de al menos 4,5 estrellas de al menos 5 valoraciones.';

  @override
  String badgeCertifiedProgress(Object count) {
    return 'Certificado ($count/1)';
  }

  @override
  String get badgeCertifiedDesc => 'Completa 3 trabajos.';

  @override
  String badgeExperiencedProgress(Object count) {
    return 'Experimentado ($count/2)';
  }

  @override
  String get badgeExperiencedDesc => 'Completa un total de 10 trabajos.';

  @override
  String badgeExpertProgress(Object count) {
    return 'Experto ($count/3)';
  }

  @override
  String get badgeExpertDesc => 'Completa un total de 25 trabajos.';

  @override
  String badgeMasterProgress(Object count) {
    return 'Maestro ($count/4)';
  }

  @override
  String get badgeMasterDesc => 'Completa un total de 50 trabajos.';

  @override
  String get trafficScreenInfoText => 'Aquí puede ver cuántos proveedores de servicios hay actualmente activos por categoría en su zona. Cuantos más proveedores haya, más rápido se suele aceptar su solicitud.';

  @override
  String get filterAbgeschlossen => 'Completado';

  @override
  String get auftraege => 'Trabajos';

  @override
  String get profil => 'Perfil';

  @override
  String get filterAlle => 'Todos';

  @override
  String get filterOffen => 'Abierto';

  @override
  String get filterLaufend => 'En curso';

  @override
  String get forgotPasswordButton => '¿Olvidaste tu contraseña?';

  @override
  String get forgotPasswordInfo => 'Introduce tu dirección de correo electrónico registrada. Recibirás un enlace para restablecer tu contraseña.';

  @override
  String get sendResetLinkButton => 'Enviar enlace de restablecimiento';

  @override
  String get resetMailSent => 'El enlace ha sido enviado. ¡Revisa tu bandeja de entrada!';

  @override
  String get keineDienstleisterInRegion => 'No se ha encontrado ningún proveedor de servicios en tu región.';

  @override
  String get trafficScreenKeineAdresse => 'No se ha encontrado ninguna dirección en tu perfil.';

  @override
  String get trafficScreenAdresseFehler => 'No se pudo convertir tu dirección en coordenadas.';

  @override
  String get auftragWiederkehrendAppBar => 'Tarea recurrente';

  @override
  String get auftragWiederkehrendHeadline => '¿Debe esta tarea repetirse regularmente?';

  @override
  String get auftragWiederkehrendInfo => 'Elige si y con qué frecuencia la tarea debe realizarse automáticamente.';

  @override
  String get auftragReviewAppBar => 'Revisar y enviar';

  @override
  String get auftragReviewHeadline => '¿Todo correcto?';

  @override
  String get auftragReviewInfo => 'Revisa tus datos antes de enviar la tarea.';

  @override
  String get absendenButton => 'Enviar';

  @override
  String get ja => 'Sí';

  @override
  String get nein => 'No';

  @override
  String get wiederholenBisLabelPlain => 'Repetir hasta';

  @override
  String get auftragAdresseAppBar => 'Dirección y contacto';

  @override
  String get auftragAdresseHeadline => '¿Dónde debe realizarse la tarea?';

  @override
  String get auftragAdresseInfo => 'Introduce la dirección y tu número de teléfono para que el proveedor pueda contactarte.';

  @override
  String get adresseHint => 'p. ej. Calle Ejemplo 12, 12345 Madrid';

  @override
  String get telefonnummerHint => 'p. ej. 612 345 678';

  @override
  String get zurueckButton => 'Atrás';

  @override
  String get weiterButton => 'Siguiente';

  @override
  String get auftragKategorieAppBar => 'Seleccionar categoría';

  @override
  String get auftragKategorieHeadline => '¿Para qué categoría necesitas ayuda?';

  @override
  String get auftragKategorieInfo => 'Elige el servicio adecuado. Puedes dar más detalles después.';

  @override
  String get kategorieValidator => 'Por favor, selecciona una categoría.';

  @override
  String get auftragDetailsAppBar => 'Detalles de la tarea';

  @override
  String get auftragDetailsHeadline => 'Describe la tarea';

  @override
  String get auftragDetailsInfo => '¿Qué hay que hacer? ¡Cuantos más detalles, mejor!';

  @override
  String get auftragTerminAppBar => 'Fecha y hora';

  @override
  String get auftragTerminHeadline => '¿Cuándo debe realizarse la tarea?';

  @override
  String get auftragTerminInfo => 'Elige la fecha y la hora o selecciona \'lo antes posible\'.';

  @override
  String get terminLabel => 'Fecha';

  @override
  String get preisLabel => 'Precio (€) o \'negociable\'';

  @override
  String get preisHint => 'p.ej. 60 o \'negociable\'';

  @override
  String get preisValidator => 'Por favor, introduce un precio válido o \'negociable\'.';

  @override
  String get preisHinweisLabel => 'Nota de precio (opcional)';

  @override
  String get preisHinweisHint => 'p.ej. tarifa por hora, coste de material, negociable, etc.';

  @override
  String get preisTypLabel => 'Seleccionar opción de precio';

  @override
  String get preisTypGesamt => 'Precio total';

  @override
  String get preisTypStunden => 'Tarifa por hora';

  @override
  String get preisTypVerhandelbar => 'A convenir / negociable';

  @override
  String get preisLabelGesamt => 'Precio total (€)';

  @override
  String get preisHintGesamt => 'p. ej. 120';

  @override
  String get preisLabelStunden => 'Tarifa por hora (€ por hora)';

  @override
  String get preisHintStunden => 'p. ej. 20';

  @override
  String get preisHinweisVerhandelbar => 'Precio a convenir / se aceptan ofertas';

  @override
  String get preisTypGesamtDesc => 'Indicas el precio total para el trabajo.';

  @override
  String get preisTypStundenDesc => 'Indicas una tarifa por hora para el trabajo.';

  @override
  String get preisTypVerhandelbarDesc => 'El precio se negociará directamente con el proveedor de servicios.';

  @override
  String get heimatadresseButtonInfo => 'Toca aquí para rellenar automáticamente tu dirección guardada.';

  @override
  String get verhandelbarLabel => 'Negociable';

  @override
  String get terminValidierungFehler => 'Por favor, selecciona una fecha y ambas horas.';

  @override
  String get wiederkehrendValidierungFehler => 'Por favor, selecciona correctamente el intervalo, el día de la semana y el número de repeticiones para las tareas recurrentes.';

  @override
  String priceTotal(Object amount) {
    return '$amount €';
  }

  @override
  String pricePerHour(Object amount, Object hourShort) {
    return '$amount € / $hourShort';
  }

  @override
  String get priceNegotiable => 'Negociable';

  @override
  String get hourShort => 'h';

  @override
  String get setNewPasswordTitle => 'Establecer nueva contraseña';

  @override
  String get setNewPasswordInfo => 'Introduce tu nueva contraseña dos veces para confirmar.';

  @override
  String get newPasswordLabel => 'Nueva contraseña';

  @override
  String get confirmNewPasswordLabel => 'Confirmar nueva contraseña';

  @override
  String get saveNewPasswordButton => 'Guardar nueva contraseña';

  @override
  String get passwordEmptyError => 'La contraseña no puede estar vacía.';

  @override
  String get passwordsDontMatch => 'Las contraseñas no coinciden.';

  @override
  String get passwordResetSuccess => 'Contraseña restablecida correctamente. Ahora puedes iniciar sesión.';

  @override
  String get premiumRestorePurchases => 'Restaurar compras';

  @override
  String get premiumRetry => 'Volver a intentar';

  @override
  String get wrongRoleCustomer => 'Esta cuenta está registrada como proveedor de servicios y no puede usarse para iniciar sesión como cliente.';

  @override
  String get accountNotRegistered => 'No se encontró ninguna cuenta con este correo electrónico. Regístrese primero.';

  @override
  String get wrongCredentials => 'Correo electrónico o contraseña incorrectos.';

  @override
  String get premiumPushDelayFree => 'Notificaciones push: retraso de 1 h';

  @override
  String get premiumPushDelaySilver => 'Notificaciones push: retraso de 30 min';

  @override
  String get premiumPushDelayGold => 'Notificaciones push: instantáneas para nuevos trabajos';

  @override
  String get companyNameOptional => 'Nombre de la empresa (opcional)';

  @override
  String get vatIdOptional => 'NIF IVA (opcional)';

  @override
  String get bicOptional => 'BIC (opcional)';

  @override
  String get smallBusinessLabel => 'Pequeña empresa según §19 UStG';

  @override
  String get defaultVatRateLabel => 'Tipo de IVA estándar (%)';

  @override
  String get invalidVatRate => 'Tipo de IVA no válido';

  @override
  String get profileNameLabel => 'Nombre completo';

  @override
  String get invoiceNoShort => 'N.º:';

  @override
  String get netAmountLabel => 'Neto';

  @override
  String vatLabelWithPercent(Object percent) {
    return 'IVA ($percent%)';
  }

  @override
  String get totalLabel => 'Total';

  @override
  String get dueOnLabel => 'Vence el:';

  @override
  String get vatIdLabel => 'NIF-IVA:';

  @override
  String get bicLabel => 'BIC:';

  @override
  String paymentTermsDefault(Object days) {
    return 'Pagadero dentro de $days días sin deducciones.';
  }

  @override
  String get badgeInfoText => 'Estas insignias solo pueden ser obtenidas por los proveedores de servicios y aparecen cuando el proveedor acepta el trabajo.';

  @override
  String get noAuftraegeKundeHint => 'Crea tu primer encargo tocando el botón de más (+).';

  @override
  String get upsellCardTitle => 'Trabajo cerca de ti';

  @override
  String upsellCategoryLabel(String category) {
    return 'Categoría: $category';
  }

  @override
  String upsellUpgradeButton(String plan) {
    return 'Mejora a $plan para ver este trabajo';
  }

  @override
  String get planFree => 'Gratis';

  @override
  String get planSilver => 'Plata';

  @override
  String get planGold => 'Oro';

  @override
  String get filterNeu => 'Nuevos';

  @override
  String onlyNewWindowInfo(int hours) {
    return 'Muestra trabajos de las últimas $hours horas.';
  }

  @override
  String get cancelLabel => 'Cancelar';

  @override
  String get editProfileCta => 'Completar perfil';

  @override
  String get update_required_title => 'Actualización requerida';

  @override
  String get update_required_message => 'Actualiza la app para continuar.';

  @override
  String get update_available_title => 'Actualización disponible';

  @override
  String get update_available_message => 'Hay una nueva versión disponible. ¿Actualizar ahora?';

  @override
  String get update_action_update_now => 'Actualizar ahora';

  @override
  String get update_action_later => 'Más tarde';

  @override
  String get invoiceSectionSubtitle => 'Opcional: datos de empresa e impuestos para la facturación automática';

  @override
  String get marketplaceTitle => 'Intercambiar trabajos';

  @override
  String get marketplaceTabSell => 'Vender';

  @override
  String get marketplaceTabBuy => 'Comprar';

  @override
  String get marketplaceOfferCreateCta => 'Transferir un trabajo';

  @override
  String get marketplaceFilter => 'Filtrar';

  @override
  String get marketplaceSort => 'Ordenar';

  @override
  String get marketplaceBuyNow => 'Postular ahora';

  @override
  String get marketplaceSnackOpenForm => 'Abriendo formulario de oferta…';

  @override
  String get marketplaceSnackStartCheckout => 'Iniciando pago…';

  @override
  String marketplaceOfferTitle(int index) {
    return 'Oferta n.º $index';
  }

  @override
  String marketplaceOfferSubtitle(String category, String price, Object distanceKm) {
    return '$category • $distanceKm km';
  }

  @override
  String marketplaceBuyTitle(int index) {
    return 'Anuncio n.º $index · Reparación menor';
  }

  @override
  String marketplaceBuySubtitle(String category, String price, String distance) {
    return 'Categoría: $category · $price/h · $distance km';
  }

  @override
  String get marketplaceEmptyList => 'No se encontraron ofertas.';

  @override
  String get marketplaceErrorLoading => 'No se pudo cargar la lista.';

  @override
  String get marketplaceAppliedSuccess => 'Postulación enviada — el vendedor puede verla.';

  @override
  String get marketplaceAlreadyApplied => 'Ya te has postulado.';

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
    return 'Precio objetivo: $price';
  }

  @override
  String marketplaceChipProvision(Object value) {
    return 'Comisión: $value';
  }

  @override
  String get s0Title => 'Transferir trabajo (S0)';

  @override
  String get sectionBasics => 'Básico';

  @override
  String get fieldTitle => 'Título';

  @override
  String get hintTitleExample => 'p. ej. Renovación de techo, 120 m²';

  @override
  String get fieldDescription => 'Descripción';

  @override
  String get hintDescription => 'Descripción breve, detalles, materiales incl./excl.';

  @override
  String get fieldLocation => 'Ubicación/radio (por ahora texto)';

  @override
  String get hintLocation => 'p. ej. Colonia, 15 km';

  @override
  String get pickStartDate => 'Elegir fecha de inicio';

  @override
  String get pickDeadline => 'Elegir fecha límite';

  @override
  String get labelStart => 'Inicio';

  @override
  String get labelDeadline => 'Fecha límite';

  @override
  String get sectionS0PriceProvision => 'S0 – Precio y comisión';

  @override
  String get tooltipS0PriceProvision => 'Precio objetivo = precio total del trabajo.\nComisión = pago por transferir.';

  @override
  String get fieldTargetPriceEur => 'Precio objetivo (EUR)';

  @override
  String get hintTargetPriceExample => 'p. ej. 12.500';

  @override
  String get helpTargetPrice => 'Valor total asumido por el comprador.';

  @override
  String get fieldProvisionType => 'Tipo de comisión';

  @override
  String get provisionTypePercent => 'Porcentaje';

  @override
  String get provisionTypeFixed => 'Fijo';

  @override
  String get fieldProvisionValuePercent => 'Valor de comisión (%)';

  @override
  String get fieldProvisionValueFixed => 'Valor de comisión (€)';

  @override
  String get helpProvisionPercent => 'Típico: 5–12% (límite posible).';

  @override
  String get helpProvisionFixed => 'Importe fijo de comisión.';

  @override
  String get fieldProvisionDue => '¿Cuándo vence la comisión?';

  @override
  String get provisionDueAward => 'en la adjudicación';

  @override
  String get provisionDueHandover => 'al entregar';

  @override
  String get provisionDueFinalInvoice => 'con la factura final';

  @override
  String get provisionDueAwardHelp => 'Al adjudicar: la comisión vence inmediatamente después de la adjudicación.';

  @override
  String get provisionDueHandoverHelp => 'Al entregar: tras el OK del cliente y entrega.';

  @override
  String get provisionDueFinalInvoiceHelp => 'Con la factura final: cuando el comprador termina el trabajo.';

  @override
  String get sectionEvidencePlaceholder => 'Pruebas (placeholder)';

  @override
  String get btnUploadEvidence => 'Subir oferta/OK del cliente';

  @override
  String get btnCreateDraft => 'Crear borrador';

  @override
  String get btnSaving => 'Guardando…';

  @override
  String get noteSupabaseActive => 'Nota: almacenamiento Supabase activo. Pagos y subidas después.';

  @override
  String get formErrorRequired => 'Obligatorio';

  @override
  String get formErrorInvalidAmount => 'Importe no válido';

  @override
  String get formErrorGreaterZero => 'Debe ser > 0';

  @override
  String get formErrorRealistic => 'Por favor, sé realista';

  @override
  String get formErrorInvalidValue => 'Valor no válido';

  @override
  String get formErrorPercentRange => 'Rango permitido: 0–30%';

  @override
  String get errPickStartDate => 'Elige una fecha de inicio';

  @override
  String get errPickDeadline => 'Elige una fecha límite';

  @override
  String get draftSaved => 'Borrador S0 guardado.';

  @override
  String get genericError => 'Algo salió mal.';

  @override
  String get btnMyDeals => 'Mis ofertas';

  @override
  String get myDealsTitle => 'Mis ofertas';

  @override
  String get myDealsEmpty => 'Aún no hay trabajos.';

  @override
  String get myDealsErrorLoading => 'No se han podido cargar tus trabajos.';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterDraft => 'Borradores';

  @override
  String get filterLive => 'Activos';

  @override
  String get filterAwarded => 'Adjudicados';

  @override
  String get manageTitle => 'Gestionar trabajo';

  @override
  String get manageErrorLoading => 'No se pudieron cargar los detalles.';

  @override
  String get btnPublish => 'Publicar';

  @override
  String get publishSuccess => 'Trabajo publicado.';

  @override
  String get applicationsTitle => 'Postulaciones';

  @override
  String get applicationsEmpty => 'Aún no hay postulaciones.';

  @override
  String get applicationNote => 'Nota';

  @override
  String get applicationStatusPending => 'Estado: pendiente';

  @override
  String get applicationStatusAwarded => 'Estado: adjudicado';

  @override
  String get btnAward => 'Adjudicar';

  @override
  String get btnManage => 'Gestionar';

  @override
  String get labelStatus => 'Estado';

  @override
  String get statusDraft => 'Borrador';

  @override
  String get statusLive => 'Activo';

  @override
  String get statusAwarded => 'Adjudicado';

  @override
  String get awardSuccess => 'Postulación adjudicada con éxito.';

  @override
  String get snackNewApplication => 'Nueva postulación recibida';

  @override
  String applicationsCount(Object count) {
    return '$count solicitudes';
  }

  @override
  String get btnApplied => 'Postulado';

  @override
  String get s0EditTitle => 'Editar S0';

  @override
  String get publishNow => 'Publicar tras guardar';

  @override
  String get publishNowHint => 'Si está activado, el borrador pasará a «En vivo» después de guardar.';

  @override
  String get btnSaveChanges => 'Guardar cambios';

  @override
  String get saved => 'Guardado';

  @override
  String get marketplaceLocationLoadedFromProfile => 'Ubicación cargada de tu perfil — filtro de radio activo.';

  @override
  String get marketplaceNoHomeAddressHint => 'Sin dirección en el perfil — se muestran todas las ofertas sin filtro de distancia.';

  @override
  String get fieldCategory => 'Categoría';

  @override
  String get categoryAll => 'Todas';

  @override
  String get categoryRoofer => 'Cubiertas / Tejados';

  @override
  String get categorySolar => 'FV / Solar';

  @override
  String get categoryHVAC => 'Calefacción / Fontanería / HVAC';

  @override
  String get categoryElectrical => 'Electricidad';

  @override
  String get categoryDrywall => 'Pladur / Tablaroca';

  @override
  String get categoryPainter => 'Pintor';

  @override
  String get categoryTiling => 'Alicatado';

  @override
  String get categoryFlooring => 'Suelos / Pavimentos';

  @override
  String get categoryWindowsDoors => 'Ventanas y Puertas';

  @override
  String get categoryInsulationFacade => 'Aislamiento y Fachada';

  @override
  String get categoryMasonryConcrete => 'Albañilería y Hormigón';

  @override
  String get categoryCarpentryJoinery => 'Carpintería';

  @override
  String get categoryLandscaping => 'Jardinería / Paisajismo';

  @override
  String get categoryScaffolding => 'Andamios';

  @override
  String get categoryCleaningRestoration => 'Limpieza y Restauración';

  @override
  String get categoryMovingTransport => 'Mudanzas y Transporte';

  @override
  String get sectionCustomerOk => 'Consentimiento del cliente';

  @override
  String get helpCustomerOk => 'Prueba de que el cliente acepta la cesión (p. ej., oferta firmada, correo/SMS en PDF/foto).';

  @override
  String get btnUploadCustomerOk => 'Subir consentimiento';

  @override
  String get customerNameOptional => 'Nombre del cliente (opcional)';

  @override
  String get customerPhoneOptional => 'Teléfono (opcional)';

  @override
  String get sectionOffer => 'Oferta / Confirmación de pedido';

  @override
  String get helpOfferOptional => 'Tu oferta o confirmación. Opcional pero útil para compradores.';

  @override
  String get btnUploadOffer => 'Subir oferta';

  @override
  String get errCustomerOkRequired => 'Se requiere al menos un documento de consentimiento para publicar.';

  @override
  String get warnMissingDocsBody => 'Aviso: sin consentimiento/oferta no podrás publicar más tarde. Puedes añadir los documentos en cualquier momento.';

  @override
  String get attestLabel => 'Confirmo de forma veraz que el cliente aceptó la cesión y que toda la información es correcta.';

  @override
  String get attestConsequences => 'En caso de falsedades podemos suspender la cuenta, retener pagos y emprender acciones civiles y, cuando proceda, penales.';

  @override
  String get errAttestRequired => 'Debes marcar la confirmación para publicar.';

  @override
  String get genericPleaseFix => 'Corrige los campos resaltados:';

  @override
  String get errAwardNeedsDoc => 'Si el vencimiento es \"al adjudicar\", se requiere un documento/oferta.';

  @override
  String get errNotOwner => 'No eres el propietario de este trabajo.';

  @override
  String get errPublishOnlyFromDraft => 'Solo se puede publicar desde el estado borrador.';

  @override
  String get publishRequirementsTitle => 'Requisitos para publicar';

  @override
  String get infoReqCustomerOk => 'Hay al menos una autorización del cliente adjunta.';

  @override
  String get infoReqDocForAward => 'Para \"al adjudicar\": sube oferta/confirmación de pedido.';

  @override
  String get infoReqAttest => 'La casilla de confirmación está marcada.';

  @override
  String get draftChecklistTitle => 'Lista previa a la publicación';

  @override
  String get chkTitle => 'Título completado';

  @override
  String get chkDescription => 'Descripción completada';

  @override
  String get chkLocation => 'Dirección/ubicación establecida';

  @override
  String get chkTargetPrice => 'Precio objetivo establecido';

  @override
  String get chkCustomerOk => 'Autorización del cliente presente';

  @override
  String get chkDocIfAward => 'Documento/oferta presente (recomendado si es \"al adjudicar\")';

  @override
  String get chkAttestAtPublish => 'Marca la confirmación al publicar';

  @override
  String get draftChecklistCta => 'Abrir gestión';

  @override
  String get uploadSuccess => 'Subida completada.';

  @override
  String get uploadInProgress => 'Subiendo...';

  @override
  String get uploadFailed => 'Error al subir.';

  @override
  String get draftDefaultTitle => 'Borrador';

  @override
  String get errGeocodingFailed => 'No se pudo geocodificar la dirección.';

  @override
  String get provisionDueAwardLabel => 'Adjudicación';

  @override
  String get provisionDueHandoverLabel => 'Entrega';

  @override
  String get provisionDueFinalInvoiceLabel => 'Factura final';

  @override
  String get sectionPreviewPublic => 'Vista previa (pública)';

  @override
  String get tooltipPreviewPublic => 'Estos archivos son visibles antes de la compra. Sube solo vistas previas anonimizadas/expurgadas.';

  @override
  String get btnUploadPreview => 'Subir vista previa';

  @override
  String get previewRedactionNoticeTitle => 'Aviso importante sobre la vista previa';

  @override
  String get previewRedactionNoticeBody => 'Las vistas previas son visibles para los compradores antes de la compra. Oculta datos sensibles (nombres, direcciones, teléfonos, n.º de contrato/cliente, firmas, códigos QR/de barras). No subas documentos con datos personales sin ocultar.';

  @override
  String get hintPhoneExample => '+34 612 34 56 78';

  @override
  String get createDealTitle => 'Crear oferta';

  @override
  String get chooseDealTypeTitle => 'Elegir tipo de oferta';

  @override
  String get dealTypeS0Title => 'S0 – Reventa del trabajo';

  @override
  String get dealTypeS0Subtitle => 'Vender el trabajo completo a otro proveedor.';

  @override
  String get dealTypeS1Title => 'S1 – Subparte/Subcontrata (hitos)';

  @override
  String get dealTypeS1Subtitle => 'Subcontratación con hitos y evidencias.';

  @override
  String get s1Title => 'Buscar subcontratistas (S1)';

  @override
  String get sectionS1Pricing => 'Precios';

  @override
  String get sectionS1Provision => 'Comisión';

  @override
  String get sectionMilestones => 'Hitos';

  @override
  String get pricingModeFixed => 'Precio fijo';

  @override
  String get pricingModeTm => 'Tiempo y Materiales';

  @override
  String get basePriceLabel => 'Presupuesto total (€)';

  @override
  String get hourlyRateLabel => 'Tarifa por hora (€)';

  @override
  String get expectedHoursLabel => 'Horas estimadas';

  @override
  String get dueTypeAward => 'Adjudicación';

  @override
  String get dueTypeDate => 'Fecha';

  @override
  String get dueTypeHandover => 'Entrega';

  @override
  String get dueTypeCustom => 'Personalizado';

  @override
  String get dueTypeCustomHelp => 'Disparador de vencimiento personalizado (indica fecha/comentario).';

  @override
  String get milestoneLabel => 'Hito';

  @override
  String get milestoneTitle => 'Título del hito';

  @override
  String get milestoneDescription => 'Descripción del hito';

  @override
  String get milestoneAmount => 'Importe (€)';

  @override
  String get milestonePercent => 'Porcentaje (%)';

  @override
  String get milestoneDue => 'Vencimiento';

  @override
  String get btnAddMilestonePercent => 'Añadir hito (%)';

  @override
  String get btnAddMilestoneAmount => 'Añadir hito (€)';

  @override
  String get milestoneEmptyHint => 'Aún no hay hitos (opcional).';

  @override
  String get milestoneBlocking => 'Bloqueante';

  @override
  String get milestoneBlockingHelp => 'Debe completarse antes de desbloquear el siguiente paso.';

  @override
  String get validationMilestoneSum => 'Los totales de los hitos no cuadran: usa 100% en modo porcentaje o iguala el presupuesto total en precio fijo.';

  @override
  String get btnReorder => 'Reordenar';

  @override
  String get infoS1PricingHelp => 'Cómo presupuestas el trabajo subcontratado. «Precio fijo» = un presupuesto total para el alcance. «Tiempo y materiales» = tarifa por hora + horas estimadas; la facturación real según el tiempo invertido.';

  @override
  String get infoS1ProvisionHelp => 'Tu comisión por cada subcontratista adjudicado. Define porcentaje o importe fijo y su vencimiento.';

  @override
  String get coordChipNoCoords => 'Sin coordenadas';

  @override
  String get coordMissingLabel => 'Coordenadas (lat/lng)';

  @override
  String get s0DetailsMissingLabel => 'Detalles S0';

  @override
  String get s1DetailsMissingLabel => 'Detalles S1';

  @override
  String get marketplaceTypeS0 => 'S0 – Ceder trabajo';

  @override
  String get marketplaceTypeS1 => 'S1 – Búsqueda de subcontrata';

  @override
  String get filterTypeAll => 'Todos los tipos';

  @override
  String get filterTypeS0 => 'Solo S0';

  @override
  String get filterTypeS1 => 'Solo S1';

  @override
  String get badgeAwardedToYou => 'Adjudicado para ti';

  @override
  String get badgeAwardedGiven => 'Adjudicado';

  @override
  String get btnAssigned => 'Adjudicado';

  @override
  String get marketplaceOwnDealPill => 'Tu encargo';
}
