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
  String get passwordTooShort => 'La contraseña debe tener al menos 6 caracteres';

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
  String get descriptionLabel => 'Descripción';

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
  String get premiumSilverFeature1 => 'Aceptar trabajos ilimitados';

  @override
  String get premiumSilverFeature2 => 'Trabajos en un radio de 15 km';

  @override
  String get premiumSilverFeature3 => 'Todas las categorías disponibles';

  @override
  String get premiumGoldFeature1 => 'Aceptar trabajos ilimitados';

  @override
  String get premiumGoldFeature2 => 'Trabajos en un radio de 40 km';

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
  String get category_rasenmaeher_service => 'Servicio de cortacésped';

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
}
