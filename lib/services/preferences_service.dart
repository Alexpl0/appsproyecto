import 'package:flutter/foundation.dart';

/// Servicio para gestionar las preferencias del usuario y configuración de la app.
/// En una implementación real, usaría shared_preferences o similar.
class PreferencesService {
  // Simulación de almacenamiento local
  final Map<String, dynamic> _storage = {};
  
  // Claves para las preferencias
  static const String _languageKey = 'language';
  static const String _themeKey = 'theme';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _autoBackupKey = 'auto_backup';
  static const String _sensorIntervalKey = 'sensor_update_interval';
  static const String _temperatureThresholdKey = 'temperature_threshold';
  static const String _humidityThresholdKey = 'humidity_threshold';
  static const String _firstLaunchKey = 'first_launch';
  static const String _userDataKey = 'user_data';

  /// Inicializar el servicio de preferencias
  Future<void> init() async {
    // Simular carga de preferencias
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Configurar valores por defecto si es la primera vez
    if (!_storage.containsKey(_firstLaunchKey)) {
      await _setDefaultValues();
    }
    
    if (kDebugMode) {
      print('PreferencesService inicializado');
    }
  }

  /// Establecer valores por defecto
  Future<void> _setDefaultValues() async {
    _storage[_languageKey] = 'es';
    _storage[_themeKey] = 'light';
    _storage[_notificationsKey] = true;
    _storage[_autoBackupKey] = true;
    _storage[_sensorIntervalKey] = 5;
    _storage[_temperatureThresholdKey] = 25.0;
    _storage[_humidityThresholdKey] = 70.0;
    _storage[_firstLaunchKey] = false;
    _storage[_userDataKey] = {
      'name': 'Admin',
      'email': 'admin@rastreoapp.com',
      'role': 'administrator',
      'avatar': null,
    };
  }

  // === MÉTODOS DE IDIOMA ===
  
  /// Cargar el idioma guardado
  String loadLanguage() {
    return _storage[_languageKey] ?? 'es';
  }

  /// Guardar el idioma seleccionado
  Future<void> saveLanguage(String languageCode) async {
    _storage[_languageKey] = languageCode;
    if (kDebugMode) {
      print('Idioma guardado: $languageCode');
    }
  }

  // === MÉTODOS DE TEMA ===
  
  /// Cargar el tema guardado
  String loadTheme() {
    return _storage[_themeKey] ?? 'light';
  }

  /// Guardar el tema seleccionado
  Future<void> saveTheme(String theme) async {
    _storage[_themeKey] = theme;
    if (kDebugMode) {
      print('Tema guardado: $theme');
    }
  }

  // === MÉTODOS DE NOTIFICACIONES ===
  
  /// Verificar si las notificaciones están habilitadas
  bool areNotificationsEnabled() {
    return _storage[_notificationsKey] ?? true;
  }

  /// Configurar el estado de las notificaciones
  Future<void> setNotificationsEnabled(bool enabled) async {
    _storage[_notificationsKey] = enabled;
    if (kDebugMode) {
      print('Notificaciones ${enabled ? 'habilitadas' : 'deshabilitadas'}');
    }
  }

  // === MÉTODOS DE RESPALDO AUTOMÁTICO ===
  
  /// Verificar si el respaldo automático está habilitado
  bool isAutoBackupEnabled() {
    return _storage[_autoBackupKey] ?? true;
  }

  /// Configurar el respaldo automático
  Future<void> setAutoBackupEnabled(bool enabled) async {
    _storage[_autoBackupKey] = enabled;
    if (kDebugMode) {
      print('Respaldo automático ${enabled ? 'habilitado' : 'deshabilitado'}');
    }
  }

  // === MÉTODOS DE CONFIGURACIÓN DE SENSORES ===
  
  /// Obtener el intervalo de actualización de sensores (en segundos)
  int getSensorUpdateInterval() {
    return _storage[_sensorIntervalKey] ?? 5;
  }

  /// Configurar el intervalo de actualización de sensores
  Future<void> setSensorUpdateInterval(int seconds) async {
    _storage[_sensorIntervalKey] = seconds;
    if (kDebugMode) {
      print('Intervalo de sensores configurado a $seconds segundos');
    }
  }

  /// Obtener el umbral de temperatura
  double getTemperatureThreshold() {
    return _storage[_temperatureThresholdKey] ?? 25.0;
  }

  /// Configurar el umbral de temperatura
  Future<void> setTemperatureThreshold(double threshold) async {
    _storage[_temperatureThresholdKey] = threshold;
    if (kDebugMode) {
      print('Umbral de temperatura configurado a $threshold°C');
    }
  }

  /// Obtener el umbral de humedad
  double getHumidityThreshold() {
    return _storage[_humidityThresholdKey] ?? 70.0;
  }

  /// Configurar el umbral de humedad
  Future<void> setHumidityThreshold(double threshold) async {
    _storage[_humidityThresholdKey] = threshold;
    if (kDebugMode) {
      print('Umbral de humedad configurado a $threshold%');
    }
  }

  // === MÉTODOS DE DATOS DE USUARIO ===
  
  /// Obtener los datos del usuario
  Map<String, dynamic> getUserData() {
    return Map<String, dynamic>.from(_storage[_userDataKey] ?? {});
  }

  /// Guardar los datos del usuario
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    _storage[_userDataKey] = userData;
    if (kDebugMode) {
      print('Datos de usuario guardados: ${userData['name']}');
    }
  }

  /// Actualizar un campo específico del usuario
  Future<void> updateUserField(String field, dynamic value) async {
    final userData = getUserData();
    userData[field] = value;
    await saveUserData(userData);
  }

  // === MÉTODOS DE CONFIGURACIÓN AVANZADA ===
  
  /// Obtener una configuración personalizada
  T? getCustomSetting<T>(String key, [T? defaultValue]) {
    return _storage[key] as T? ?? defaultValue;
  }

  /// Guardar una configuración personalizada
  Future<void> setCustomSetting(String key, dynamic value) async {
    _storage[key] = value;
    if (kDebugMode) {
      print('Configuración personalizada guardada: $key = $value');
    }
  }

  /// Eliminar una configuración
  Future<void> removeSetting(String key) async {
    _storage.remove(key);
    if (kDebugMode) {
      print('Configuración eliminada: $key');
    }
  }

  /// Limpiar todas las configuraciones
  Future<void> clearAllSettings() async {
    _storage.clear();
    await _setDefaultValues();
    if (kDebugMode) {
      print('Todas las configuraciones han sido limpiadas');
    }
  }

  // === MÉTODOS DE CONFIGURACIÓN DE RED ===
  
  /// Obtener la URL de la API
  String getApiEndpoint() {
    return _storage['api_endpoint'] ?? 'https://api.rastreoapp.com';
  }

  /// Configurar la URL de la API
  Future<void> setApiEndpoint(String endpoint) async {
    _storage['api_endpoint'] = endpoint;
    if (kDebugMode) {
      print('Endpoint de API configurado: $endpoint');
    }
  }

  /// Obtener el timeout de solicitudes
  int getRequestTimeout() {
    return _storage['request_timeout'] ?? 30;
  }

  /// Configurar el timeout de solicitudes
  Future<void> setRequestTimeout(int seconds) async {
    _storage['request_timeout'] = seconds;
    if (kDebugMode) {
      print('Timeout de solicitudes configurado: $seconds segundos');
    }
  }

  /// Verificar si solo usar WiFi
  bool shouldUseWiFiOnly() {
    return _storage['wifi_only'] ?? false;
  }

  /// Configurar uso solo de WiFi
  Future<void> setWiFiOnly(bool wifiOnly) async {
    _storage['wifi_only'] = wifiOnly;
    if (kDebugMode) {
      print('Uso solo WiFi ${wifiOnly ? 'habilitado' : 'deshabilitado'}');
    }
  }

  // === MÉTODOS DE CONFIGURACIÓN DE ALMACENAMIENTO ===
  
  /// Obtener el tamaño máximo de caché (en MB)
  int getCacheSize() {
    return _storage['cache_size'] ?? 100;
  }

  /// Configurar el tamaño máximo de caché
  Future<void> setCacheSize(int sizeMB) async {
    _storage['cache_size'] = sizeMB;
    if (kDebugMode) {
      print('Tamaño de caché configurado: $sizeMB MB');
    }
  }

  /// Obtener los días de retención de logs
  int getLogRetentionDays() {
    return _storage['log_retention_days'] ?? 30;
  }

  /// Configurar los días de retención de logs
  Future<void> setLogRetentionDays(int days) async {
    _storage['log_retention_days'] = days;
    if (kDebugMode) {
      print('Retención de logs configurada: $days días');
    }
  }

  // === MÉTODOS DE DEBUGGING ===
  
  /// Verificar si el modo desarrollador está habilitado
  bool isDeveloperModeEnabled() {
    return _storage['developer_mode'] ?? false;
  }

  /// Configurar el modo desarrollador
  Future<void> setDeveloperMode(bool enabled) async {
    _storage['developer_mode'] = enabled;
    if (kDebugMode) {
      print('Modo desarrollador ${enabled ? 'habilitado' : 'deshabilitado'}');
    }
  }

  /// Obtener todas las configuraciones (para debug)
  Map<String, dynamic> getAllSettings() {
    return Map<String, dynamic>.from(_storage);
  }

  /// Exportar configuraciones a JSON
  Map<String, dynamic> exportSettings() {
    final export = Map<String, dynamic>.from(_storage);
    // Remover datos sensibles si es necesario
    export.remove('user_password');
    export.remove('api_tokens');
    return export;
  }

  /// Importar configuraciones desde JSON
  Future<void> importSettings(Map<String, dynamic> settings) async {
    // Validar configuraciones antes de importar
    final validSettings = <String, dynamic>{};
    
    for (final entry in settings.entries) {
      // Solo importar configuraciones conocidas
      if (_isValidSettingKey(entry.key)) {
        validSettings[entry.key] = entry.value;
      }
    }
    
    _storage.addAll(validSettings);
    
    if (kDebugMode) {
      print('Configuraciones importadas: ${validSettings.keys.length} elementos');
    }
  }

  /// Verificar si una clave de configuración es válida
  bool _isValidSettingKey(String key) {
    const validKeys = [
      _languageKey,
      _themeKey,
      _notificationsKey,
      _autoBackupKey,
      _sensorIntervalKey,
      _temperatureThresholdKey,
      _humidityThresholdKey,
      'api_endpoint',
      'request_timeout',
      'wifi_only',
      'cache_size',
      'log_retention_days',
      'developer_mode',
    ];
    
    return validKeys.contains(key) || key.startsWith('custom_');
  }

  // === MÉTODOS DE ESTADÍSTICAS ===
  
  /// Obtener estadísticas de uso de la configuración
  Map<String, dynamic> getUsageStats() {
    return {
      'total_settings': _storage.length,
      'language': loadLanguage(),
      'theme': loadTheme(),
      'notifications_enabled': areNotificationsEnabled(),
      'developer_mode': isDeveloperModeEnabled(),
      'last_modified': DateTime.now().toIso8601String(),
    };
  }
}