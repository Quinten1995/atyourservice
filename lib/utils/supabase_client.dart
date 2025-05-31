import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientManager {
  static final SupabaseClient client = Supabase.instance.client;

  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://npqanssmfxdvwauuaemd.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5wcWFuc3NtZnhkdndhdXVhZW1kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg2NzU5NTUsImV4cCI6MjA2NDI1MTk1NX0.8EMBALxjSNuygVaEnx1bjzTq73dB3s35xW09-V7AWHc',
    );
  }
}
