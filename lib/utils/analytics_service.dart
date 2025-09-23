import 'package:firebase_analytics/firebase_analytics.dart';

/// Zentraler Analytics-Service für Events & User-Props.
/// Nutze snake_case für Event-Namen und kurze, sprechende Parameter-Schlüssel.
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService I = AnalyticsService._();

  final FirebaseAnalytics _fa = FirebaseAnalytics.instance;

  // ---- Aktivierung (z.B. nach Consent) ----
  Future<void> setEnabled(bool enabled) async {
    await _fa.setAnalyticsCollectionEnabled(enabled);
  }

  // ---- User-Kontext ----
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

  // ---- kleine Hilfsfunktion: Nulls entfernen & auf Map<String,Object> casten ----
  Map<String, Object> _clean(Map<String, Object?> params) {
    final out = <String, Object>{};
    params.forEach((k, v) {
      if (v != null) out[k] = v;
    });
    return out;
  }

  // ---- Generische Logger ----
  /// Deine ursprüngliche Methode.
  Future<void> log(String name, {Map<String, Object?> params = const {}}) {
    return _fa.logEvent(name: name, parameters: _clean(params));
  }

  /// Wrapper, damit Aufrufe wie `AnalyticsService.I.logEvent(...)` funktionieren.
  Future<void> logEvent(String name, {Map<String, Object?> params = const {}}) {
    return _fa.logEvent(name: name, parameters: _clean(params));
  }

  // ---- Bequeme Kurz-Methoden für Kern-Events ----
  Future<void> appOpen() => _fa.logAppOpen();

  Future<void> signupCompleted({required String role, required String city}) =>
      _fa.logEvent(
        name: 'signup_completed',
        parameters: _clean({'role': role, 'city': city}),
      );

  Future<void> onboardingCompleted({required String role}) => _fa.logEvent(
    name: 'onboarding_completed',
    parameters: _clean({'role': role}),
  );

  Future<void> providerProfileCompleted({required String city}) => _fa.logEvent(
    name: 'provider_profile_completed',
    parameters: _clean({'city': city}),
  );

  Future<void> jobCreated({
    required String category, // z.B. 'plumbing'
    required String city, // z.B. 'Trier'
  }) => _fa.logEvent(
    name: 'job_created',
    parameters: _clean({'category': category, 'city': city}),
  );

  /// Time-to-Response in Sekunden (ttr_s) optional mitgeben.
  Future<void> jobAccepted({required String category, int? ttr_s}) =>
      _fa.logEvent(
        name: 'job_accepted',
        parameters: _clean({'category': category, 'ttr_s': ttr_s}),
      );

  Future<void> subscriptionStarted({required String plan}) => _fa.logEvent(
    name: 'subscription_started',
    parameters: _clean({'plan': plan}),
  );

  Future<void> subscriptionCancelled({required String plan, String? reason}) =>
      _fa.logEvent(
        name: 'subscription_cancelled',
        parameters: _clean({'plan': plan, 'reason': reason}),
      );

  Future<void> pushOpened({required String type}) =>
      _fa.logEvent(name: 'push_opened', parameters: _clean({'type': type}));
}
