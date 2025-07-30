import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:math' as math;

/// Servicio para gestionar notificaciones locales y push.
/// En una implementación real, usaría flutter_local_notifications y FCM.
class NotificationService {
  // Simulador de notificaciones
  final List<NotificationData> _notifications = [];
  final StreamController<NotificationData> _notificationController = 
      StreamController<NotificationData>.broadcast();
  
  Timer? _simulationTimer;
  bool _initialized = false;
  bool _notificationsEnabled = true;

  /// Stream para escuchar nuevas notificaciones
  Stream<NotificationData> get notificationStream => _notificationController.stream;

  /// Inicializar el servicio de notificaciones
  Future<void> init() async {
    if (_initialized) return;
    
    // Simular inicialización
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Solicitar permisos (simulado)
    await _requestPermissions();
    
    // Configurar canales de notificación
    await _setupNotificationChannels();
    
    // Iniciar simulación de notificaciones en tiempo real
    _startNotificationSimulation();
    
    _initialized = true;
    
    if (kDebugMode) {
      print('NotificationService inicializado');
    }
  }

  /// Solicitar permisos de notificación
  Future<bool> _requestPermissions() async {
    // Simular solicitud de permisos
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (kDebugMode) {
      print('Permisos de notificación concedidos');
    }
    
    return true;
  }

  /// Configurar canales de notificación
  Future<void> _setupNotificationChannels() async {
    // En una implementación real, configuraría canales como:
    // - Entregas (delivery)
    // - Alertas de sensores (sensor_alerts)
    // - Sistema (system)
    // - Emergencias (emergency)
    
    if (kDebugMode) {
      print('Canales de notificación configurados');
    }
  }

  /// Mostrar una notificación local
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    NotificationPriority priority = NotificationPriority.medium,
    NotificationCategory category = NotificationCategory.general,
  }) async {
    if (!_notificationsEnabled) return;

    final notification = NotificationData(
      id: _generateNotificationId(),
      title: title,
      body: body,
      payload: payload,
      priority: priority,
      category: category,
      timestamp: DateTime.now(),
    );

    _notifications.add(notification);
    
    // Emitir la notificación al stream
    _notificationController.add(notification);
    
    if (kDebugMode) {
      print('Notificación mostrada: $title');
    }
  }

  /// Programar una notificación para más tarde
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    NotificationPriority priority = NotificationPriority.medium,
    NotificationCategory category = NotificationCategory.general,
  }) async {
    final delay = scheduledDate.difference(DateTime.now());
    
    if (delay.isNegative) {
      // Si la fecha ya pasó, mostrar inmediatamente
      await showNotification(
        title: title,
        body: body,
        payload: payload,
        priority: priority,
        category: category,
      );
      return;
    }

    // Programar para más tarde
    Timer(delay, () {
      showNotification(
        title: title,
        body: body,
        payload: payload,
        priority: priority,
        category: category,
      );
    });

    if (kDebugMode) {
      print('Notificación programada para: $scheduledDate');
    }
  }

  /// Cancelar una notificación programada
  Future<void> cancelNotification(int notificationId) async {
    _notifications.removeWhere((n) => n.id == notificationId);
    
    if (kDebugMode) {
      print('Notificación cancelada: $notificationId');
    }
  }

  /// Cancelar todas las notificaciones
  Future<void> cancelAllNotifications() async {
    _notifications.clear();
    
    if (kDebugMode) {
      print('Todas las notificaciones canceladas');
    }
  }

  /// Habilitar o deshabilitar notificaciones
  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
    
    if (!enabled) {
      cancelAllNotifications();
    }
    
    if (kDebugMode) {
      print('Notificaciones ${enabled ? 'habilitadas' : 'deshabilitadas'}');
    }
  }

  /// Verificar si las notificaciones están habilitadas
  bool get areNotificationsEnabled => _notificationsEnabled;

  /// Obtener todas las notificaciones
  List<NotificationData> getAllNotifications() {
    return List<NotificationData>.from(_notifications);
  }

  /// Obtener notificaciones no leídas
  List<NotificationData> getUnreadNotifications() {
    return _notifications.where((n) => !n.isRead).toList();
  }

  /// Marcar una notificación como leída
  void markAsRead(int notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  /// Marcar todas las notificaciones como leídas
  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  /// Eliminar una notificación
  void deleteNotification(int notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
  }

  /// Iniciar simulación de notificaciones en tiempo real
  void _startNotificationSimulation() {
    // Simular notificaciones cada 30-120 segundos
    _simulationTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (_notificationsEnabled && math.Random().nextBool()) {
        _generateRandomNotification();
      }
    });
  }

  /// Generar una notificación aleatoria para la simulación
  void _generateRandomNotification() {
    final random = math.Random();
    final notificationTypes = [
      {
        'title': 'Envío entregado',
        'body': 'Tu envío SH${random.nextInt(999).toString().padLeft(3, '0')} ha sido entregado exitosamente.',
        'category': NotificationCategory.delivery,
        'priority': NotificationPriority.high,
      },
      {
        'title': 'Alerta de temperatura',
        'body': 'El sensor SEN${random.nextInt(99).toString().padLeft(2, '0')} reporta temperatura alta (${25 + random.nextInt(10)}°C).',
        'category': NotificationCategory.sensor,
        'priority': NotificationPriority.urgent,
      },
      {
        'title': 'Nuevo envío',
        'body': 'Se ha creado un nuevo envío para ${_getRandomProduct()}.',
        'category': NotificationCategory.shipment,
        'priority': NotificationPriority.medium,
      },
      {
        'title': 'Retraso en entrega',
        'body': 'El envío SH${random.nextInt(999).toString().padLeft(3, '0')} presenta un retraso de ${1 + random.nextInt(3)} horas.',
        'category': NotificationCategory.delay,
        'priority': NotificationPriority.high,
      },
      {
        'title': 'Sensor desconectado',
        'body': 'El sensor SEN${random.nextInt(99).toString().padLeft(2, '0')} se ha desconectado.',
        'category': NotificationCategory.sensor,
        'priority': NotificationPriority.medium,
      },
      {
        'title': 'Mantenimiento programado',
        'body': 'Recordatorio: mantenimiento del sistema programado para mañana a las 02:00.',
        'category': NotificationCategory.maintenance,
        'priority': NotificationPriority.low,
      },
    ];

    final notification = notificationTypes[random.nextInt(notificationTypes.length)];
    
    showNotification(
      title: notification['title'] as String,
      body: notification['body'] as String,
      category: notification['category'] as NotificationCategory,
      priority: notification['priority'] as NotificationPriority,
    );
  }

  /// Obtener un producto aleatorio para las notificaciones
  String _getRandomProduct() {
    final products = [
      'Vino Tinto Reserva',
      'Tequila Premium',
      'Whisky Escocés',
      'Cerveza Artesanal',
      'Ron Añejo',
      'Vodka Premium',
      'Ginebra Artesanal',
      'Champagne Francés',
    ];
    
    return products[math.Random().nextInt(products.length)];
  }

  /// Generar un ID único para la notificación
  int _generateNotificationId() {
    return DateTime.now().millisecondsSinceEpoch % 1000000;
  }

  /// Obtener estadísticas de notificaciones
  Map<String, dynamic> getNotificationStats() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return {
      'total': _notifications.length,
      'unread': _notifications.where((n) => !n.isRead).length,
      'today': _notifications.where((n) => n.timestamp.isAfter(today)).length,
      'by_category': {
        'delivery': _notifications.where((n) => n.category == NotificationCategory.delivery).length,
        'sensor': _notifications.where((n) => n.category == NotificationCategory.sensor).length,
        'shipment': _notifications.where((n) => n.category == NotificationCategory.shipment).length,
        'system': _notifications.where((n) => n.category == NotificationCategory.system).length,
      },
      'by_priority': {
        'urgent': _notifications.where((n) => n.priority == NotificationPriority.urgent).length,
        'high': _notifications.where((n) => n.priority == NotificationPriority.high).length,
        'medium': _notifications.where((n) => n.priority == NotificationPriority.medium).length,
        'low': _notifications.where((n) => n.priority == NotificationPriority.low).length,
      },
    };
  }

  /// Limpiar notificaciones antiguas
  void cleanOldNotifications({int maxAge = 30}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: maxAge));
    _notifications.removeWhere((n) => n.timestamp.isBefore(cutoffDate));
    
    if (kDebugMode) {
      print('Notificaciones antiguas limpiadas (más de $maxAge días)');
    }
  }

  /// Destruir el servicio
  void dispose() {
    _simulationTimer?.cancel();
    _notificationController.close();
    _notifications.clear();
    
    if (kDebugMode) {
      print('NotificationService destruido');
    }
  }

  // === MÉTODOS ESPECÍFICOS PARA LA APP ===

  /// Notificación de envío entregado
  Future<void> notifyDeliveryCompleted(String shipmentId, String product) async {
    await showNotification(
      title: 'Envío entregado ✅',
      body: 'Tu envío de $product ($shipmentId) ha sido entregado exitosamente.',
      payload: 'shipment:$shipmentId',
      category: NotificationCategory.delivery,
      priority: NotificationPriority.high,
    );
  }

  /// Notificación de alerta de sensor
  Future<void> notifySensorAlert(String sensorId, String alertType, String value) async {
    await showNotification(
      title: 'Alerta de sensor ⚠️',
      body: 'Sensor $sensorId: $alertType detectado ($value).',
      payload: 'sensor:$sensorId',
      category: NotificationCategory.sensor,
      priority: NotificationPriority.urgent,
    );
  }

  /// Notificación de retraso en envío
  Future<void> notifyShipmentDelay(String shipmentId, String delay) async {
    await showNotification(
      title: 'Retraso en entrega ⏰',
      body: 'El envío $shipmentId presenta un retraso de $delay.',
      payload: 'shipment:$shipmentId',
      category: NotificationCategory.delay,
      priority: NotificationPriority.high,
    );
  }

  /// Notificación de nuevo envío
  Future<void> notifyNewShipment(String shipmentId, String product) async {
    await showNotification(
      title: 'Nuevo envío creado 📦',
      body: 'Se ha creado el envío $shipmentId para $product.',
      payload: 'shipment:$shipmentId',
      category: NotificationCategory.shipment,
      priority: NotificationPriority.medium,
    );
  }

  /// Notificación de actualización del sistema
  Future<void> notifySystemUpdate(String version) async {
    await showNotification(
      title: 'Actualización disponible 🔄',
      body: 'Nueva versión $version disponible con mejoras y correcciones.',
      payload: 'system:update',
      category: NotificationCategory.system,
      priority: NotificationPriority.low,
    );
  }

  /// Notificación de mantenimiento
  Future<void> notifyMaintenance(String message, DateTime scheduledTime) async {
    await showNotification(
      title: 'Mantenimiento programado 🔧',
      body: message,
      payload: 'system:maintenance',
      category: NotificationCategory.maintenance,
      priority: NotificationPriority.medium,
    );
  }

  /// Recordatorio personalizado
  Future<void> scheduleReminder(String title, String message, DateTime when) async {
    await scheduleNotification(
      title: title,
      body: message,
      scheduledDate: when,
      category: NotificationCategory.reminder,
      priority: NotificationPriority.medium,
    );
  }
}

// === MODELOS DE DATOS ===

class NotificationData {
  final int id;
  final String title;
  final String body;
  final String? payload;
  final NotificationPriority priority;
  final NotificationCategory category;
  final DateTime timestamp;
  final bool isRead;

  NotificationData({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    required this.priority,
    required this.category,
    required this.timestamp,
    this.isRead = false,
  });

  NotificationData copyWith({
    int? id,
    String? title,
    String? body,
    String? payload,
    NotificationPriority? priority,
    NotificationCategory? category,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return NotificationData(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum NotificationPriority {
  low,
  medium,
  high,
  urgent,
}

enum NotificationCategory {
  general,
  delivery,
  sensor,
  shipment,
  delay,
  system,
  maintenance,
  reminder,
}