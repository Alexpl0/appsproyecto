import 'package:flutter_test/flutter_test.dart';
import 'package:rastreo_app/providers/app_state_provider.dart';
import 'package:rastreo_app/services/preferences_service.dart';
import 'package:flutter/material.dart';

void main() {
  group('AppStateProvider', () {
    late PreferencesService prefs;
    late AppStateProvider provider;

    setUp(() async {
      prefs = PreferencesService();
      await prefs.init();
      provider = AppStateProvider(prefs);
    });

    test('idioma inicial es es', () {
      expect(provider.appLocale.languageCode, 'es');
    });

    test('cambiar locale a en notifica', () async {
      int notifications = 0;
      provider.addListener(() { notifications++; });
      await provider.changeLocale(const Locale('en'));
      expect(provider.appLocale.languageCode, 'en');
      expect(notifications, 1); // se notificó exactamente una vez
      // cambiar al mismo idioma no debe notificar
      await provider.changeLocale(const Locale('en'));
      expect(notifications, 1);
    });
  });
}
