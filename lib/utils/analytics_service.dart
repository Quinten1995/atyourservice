import 'package:firebase_analytics/firebase_analytics.dart';

/// Zentraler Analytics-Service für Events & User-Props.
/// - Sprechende snake_case Eventnamen
/// - Einheitliche Parameter (IDs, Stadt, Rolle, Plan, Plattform, App-Version)
/// - Alias-Schicht für alte Eventnamen -> neue evt_* Namen
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService I = AnalyticsService._();

  final FirebaseAnalytics _fa = FirebaseAnalytics.instance;

  // ---------------------------------------------------------------------------
  // Aktivierung (z.B. nach Consent)
  // ---------------------------------------------------------------------------
  Future<void> setEnabled(bool enabled) async {
    await _fa.setAnalyticsCollectionEnabled(enabled);
  }

  // ---------------------------------------------------------------------------
  // User-Kontext
  // ---------------------------------------------------------------------------
  Future<void> setUserId(String? userId) => _fa.setUserId(id: userId);

  Future<void> setUserProps({
    String? role, // 'customer' | 'provider'
    String? city, // z.B. 'Trier'
    String? locale, // 'de', 'nl', 'en', ...
    String? plan, // 'free' | 'silver' | 'gold'
  }) async {
    if (role != null) await _fa.setUserProperty(name: 'role', value: role);
    if (city != null) await _fa.setUserProperty(name: 'city', value: city);
    if (locale != null)
      await _fa.setUserProperty(name: 'locale', value: locale);
    if (plan != null) await _fa.setUserProperty(name: 'plan', value: plan);
  }

  // ---------------------------------------------------------------------------
  // Defaults (werden an jedes Event angehängt, falls nicht überschrieben)
  // ---------------------------------------------------------------------------
  Map<String, Object> _defaults = {};

  void setDefaultParams({
    String? userId,
    String? role, // 'customer' | 'provider'
    String? city, // 'Trier'
    String? locale, // 'de'
    String? plan, // 'free'|'silver'|'gold'
    String? platform, // 'ios'|'android'
    String? appVersion, // '3.4.0'
  }) {
    _defaults = _clean({
      'user_id': userId,
      'role': role,
      'city': city,
      'locale': locale,
      'plan': plan,
      'platform': platform,
      'app_ver': appVersion,
    });
  }

  // ---------------------------------------------------------------------------
  // Utils
  // ---------------------------------------------------------------------------
  Map<String, Object> _clean(Map<String, Object?> params) {
    final out = <String, Object>{};
    params.forEach((k, v) {
      if (v != null) out[k] = v;
    });
    return out;
  }

  Map<String, Object> _withDefaults(Map<String, Object?> params) {
    return {..._defaults, ..._clean(params)};
  }

  // ---------------------------------------------------------------------------
  // Alias-Schicht: alte Namen -> neue snake_case Events
  // ---------------------------------------------------------------------------
  static const Map<String, String> _alias = {
    'jobCreated': 'job_created',
    'jobViewed': 'job_viewed',
    'jobApplied': 'job_first_response',
    'providerAccept': 'job_matched',
    'jobCompleted': 'job_completed',
    'subscriptionStarted': 'subscription_started',
    'subscriptionRenewed': 'subscription_renewed',
    'subscriptionCancelled': 'subscription_cancelled',
    'notificationDelivered': 'push_delivered',
    'notificationOpened': 'push_opened',
  };

  /// Für bestehende Aufrufe mit alten Namen (legacy).
  Future<void> logLegacy(
    String oldName, {
    Map<String, Object?> params = const {},
  }) {
    final mapped = _alias[oldName] ?? oldName;
    return _fa.logEvent(name: mapped, parameters: _withDefaults(params));
  }

  // ---------------------------------------------------------------------------
  // Generische Logger
  // ---------------------------------------------------------------------------
  /// Ursprüngliche Methode (belassen für Abwärtskompatibilität).
  Future<void> log(String name, {Map<String, Object?> params = const {}}) {
    return _fa.logEvent(name: name, parameters: _withDefaults(params));
  }

  /// Wrapper, falls du gern .logEvent(...) aufrufst.
  Future<void> logEvent(String name, {Map<String, Object?> params = const {}}) {
    return _fa.logEvent(name: name, parameters: _withDefaults(params));
  }

  // ---------------------------------------------------------------------------
  // Shortcuts / Kern-Events (Funnel-fähig)
  // ---------------------------------------------------------------------------
  Future<void> appOpen() => _fa.logAppOpen();

  Future<void> signupCompleted({required String role, required String city}) =>
      _fa.logEvent(
        name: 'signup_completed',
        parameters: _withDefaults({'role': role, 'city': city}),
      );

  Future<void> onboardingCompleted({required String role}) => _fa.logEvent(
    name: 'onboarding_completed',
    parameters: _withDefaults({'role': role}),
  );

  Future<void> providerProfileCompleted({required String city}) => _fa.logEvent(
    name: 'provider_profile_completed',
    parameters: _withDefaults({'city': city}),
  );

  /// Kunde legt Auftrag an (Nenner für Matching/Conversion).
  Future<void> jobCreated({
    required String category, // z.B. 'plumbing'
    required String city, // z.B. 'Trier'
    String? jobId,
    double? radius_km,
  }) => _fa.logEvent(
    name: 'job_created',
    parameters: _withDefaults({
      'job_id': jobId,
      'category': category,
      'city': city,
      'radius_km': radius_km,
    }),
  );

  /// Sichtkontakt: DL hat Job gesehen / Kunde hat Screen geöffnet.
  Future<void> jobViewed({required String jobId, String? category}) =>
      _fa.logEvent(
        name: 'job_viewed',
        parameters: _withDefaults({'job_id': jobId, 'category': category}),
      );

  /// Erste Antwort eines beliebigen DL auf diesen Job (pro Job nur einmal sinnvoll).
  /// ttr_s = Time-to-First-Response in Sekunden.
  Future<void> jobFirstResponse({
    required String jobId,
    String? category,
    String? providerId,
    int? ttr_s,
  }) => _fa.logEvent(
    name: 'job_first_response',
    parameters: _withDefaults({
      'job_id': jobId,
      'category': category,
      'provider_id': providerId,
      'ttr_s': ttr_s,
    }),
  );

  /// Match/Annahme (Auftrag wurde verbindlich angenommen).
  Future<void> jobMatched({
    required String jobId,
    String? category,
    String? providerId,
  }) => _fa.logEvent(
    name: 'job_matched',
    parameters: _withDefaults({
      'job_id': jobId,
      'category': category,
      'provider_id': providerId,
    }),
  );

  /// Abschluss des Auftrags.
  /// ttc_s = Time-to-Completion in Sekunden.
  Future<void> jobCompleted({
    required String jobId,
    String? category,
    int? ttc_s,
  }) => _fa.logEvent(
    name: 'job_completed',
    parameters: _withDefaults({
      'job_id': jobId,
      'category': category,
      'ttc_s': ttc_s,
    }),
  );

  /// Optional beibehalten: explizite "accepted"-Event-Variante
  /// (falls du sie in Code-Stellen nutzt). Für KPIs nutzen wir i.d.R. job_matched.
  Future<void> jobAccepted({required String category, int? ttr_s}) =>
      _fa.logEvent(
        name: 'job_accepted',
        parameters: _withDefaults({'category': category, 'ttr_s': ttr_s}),
      );

  // ---------------------------------------------------------------------------
  // Abos / Revenue-Signale (für CR Upgrade, MRR & später LTV)
  // ---------------------------------------------------------------------------
  Future<void> subscriptionStarted({required String plan}) => _fa.logEvent(
    name: 'subscription_started',
    parameters: _withDefaults({'plan': plan}),
  );

  Future<void> subscriptionRenewed({required String plan}) => _fa.logEvent(
    name: 'subscription_renewed',
    parameters: _withDefaults({'plan': plan}),
  );

  Future<void> subscriptionCancelled({required String plan, String? reason}) =>
      _fa.logEvent(
        name: 'subscription_cancelled',
        parameters: _withDefaults({'plan': plan, 'reason': reason}),
      );

  // ---------------------------------------------------------------------------
  // Push / Benachrichtigungen
  // ---------------------------------------------------------------------------
  Future<void> pushDelivered({required String type}) => _fa.logEvent(
    name: 'push_delivered',
    parameters: _withDefaults({'type': type}),
  );

  Future<void> pushOpened({required String type}) => _fa.logEvent(
    name: 'push_opened',
    parameters: _withDefaults({'type': type}),
  );

  // ---------------------------------------------------------------------------
  // (Optional) Screen-Funnel ohne auf GA4-Reserved 'screen_view' zu stoßen
  // ---------------------------------------------------------------------------
  Future<void> screenView({
    required String screen,
    String? step, // z.B. '01_welcome', '02_details', ...
  }) => _fa.logEvent(
    name: 'screen_view_custom',
    parameters: _withDefaults({'screen': screen, 'step': step}),
  );
}
