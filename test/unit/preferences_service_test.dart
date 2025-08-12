import 'package:flutter_test/flutter_test.dart';
import 'package:rastreo_app/services/preferences_service.dart';

void main() {
  group('PreferencesService', () {
    late PreferencesService prefs;

    setUp(() async {
      prefs = PreferencesService();
      await prefs.init();
    });

    test('valores por defecto tras init', () async {
      expect(prefs.loadLanguage(), 'es');
      expect(prefs.loadTheme(), 'light');
      expect(prefs.areNotificationsEnabled(), isTrue);
      expect(prefs.getSensorUpdateInterval(), 5);
    });

    test('guardar y cargar idioma', () async {
      await prefs.saveLanguage('en');
      expect(prefs.loadLanguage(), 'en');
    });

    test('actualizar umbrales de sensores', () async {
      await prefs.setTemperatureThreshold(30);
      await prefs.setHumidityThreshold(80);
      expect(prefs.getTemperatureThreshold(), 30);
      expect(prefs.getHumidityThreshold(), 80);
    });

    test('custom settings CRUD', () async {
      await prefs.setCustomSetting('custom_refresh_rate', 10);
      expect(prefs.getCustomSetting<int>('custom_refresh_rate'), 10);
      await prefs.removeSetting('custom_refresh_rate');
      expect(prefs.getCustomSetting<int>('custom_refresh_rate'), isNull);
    });
  });
}
