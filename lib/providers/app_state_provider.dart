import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

/// Gestiona el estado global de la aplicación, como el idioma seleccionado.
/// Utiliza ChangeNotifier para notificar a los widgets cuando hay un cambio.
class AppStateProvider extends ChangeNotifier {
  final PreferencesService _preferencesService;
  late Locale _appLocale;

  AppStateProvider(this._preferencesService) {
    // Carga el idioma guardado al iniciar el provider
    _appLocale = Locale(_preferencesService.loadLanguage());
  }

  /// El Locale actual de la aplicación.
  Locale get appLocale => _appLocale;

  /// Cambia el idioma de la aplicación y lo guarda en las preferencias.
  Future<void> changeLocale(Locale newLocale) async {
    // No hace nada si el idioma seleccionado es el mismo
    if (_appLocale == newLocale) return;

    _appLocale = newLocale;
    // Guarda el nuevo idioma en el dispositivo
    await _preferencesService.saveLanguage(newLocale.languageCode);
    // Notifica a los widgets que escuchan para que se reconstruyan
    notifyListeners();
  }
}
