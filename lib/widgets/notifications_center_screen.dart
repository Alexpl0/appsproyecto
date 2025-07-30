import 'package:flutter/material.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';
import 'package:rastreo_app/theme/app_theme.dart';

class NotificationsCenterScreen extends StatefulWidget {
  const NotificationsCenterScreen({super.key});

  @override
  State<NotificationsCenterScreen> createState() => _NotificationsCenterScreenState();
}

class _NotificationsCenterScreenState extends State<NotificationsCenterScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _filterType = 'all';
  bool _showOnlyUnread = false;
  
  // Datos simulados de notificaciones
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'Envío SH001 entregado',
      message: 'Tu envío de Vino Tinto Reserva ha sido entregado exitosamente en Ciudad de México.',
      type: NotificationType.delivery,
      priority: NotificationPriority.high,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
      actionData: {'shipmentId': 'SH001', 'action': 'view_details'},
      icon: Icons.check_circle,
      color: AppTheme.success,
    ),
    AppNotification(
      id: '2',
      title: 'Alerta de temperatura',
      message: 'El sensor SEN003 reporta temperatura alta (28°C) en el envío de Whisky Escocés.',
      type: NotificationType.alert,
      priority: NotificationPriority.urgent,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      actionData: {'sensorId': 'SEN003', 'action': 'view_sensor'},
      icon: Icons.warning,
      color: AppTheme.error,
    ),
    AppNotification(
      id: '3',
      title: 'Nuevo envío creado',
      message: 'Se ha creado el envío SH004 para Cerveza Artesanal con destino a Querétaro.',
      type: NotificationType.shipment,
      priority: NotificationPriority.medium,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
      actionData: {'shipmentId': 'SH004', 'action': 'track'},
      icon: Icons.local_shipping,
      color: AppTheme.info,
    ),
    AppNotification(
      id: '4',
      title: 'Actualización de sistema',
      message: 'Nueva versión 1.2.0 disponible con mejoras en la gestión de sensores.',
      type: NotificationType.system,
      priority: NotificationPriority.low,
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      isRead: true,
      actionData: {'action': 'update_app'},
      icon: Icons.system_update,
      color: AppTheme.accent,
    ),
    AppNotification(
      id: '5',
      title: 'Retraso en entrega',
      message: 'El envío SH002 presenta un retraso de 2 horas debido a condiciones climáticas.',
      type: NotificationType.delay,
      priority: NotificationPriority.high,
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      isRead: false,
      actionData: {'shipmentId': 'SH002', 'action': 'view_route'},
      icon: Icons.schedule,
      color: AppTheme.warning,
    ),
    AppNotification(
      id: '6',
      title: 'Recordatorio de mantenimiento',
      message: 'El sensor SEN001 requiere calibración programada para mañana.',
      type: NotificationType.maintenance,
      priority: NotificationPriority.medium,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      actionData: {'sensorId': 'SEN001', 'action': 'schedule_maintenance'},
      icon: Icons.build,
      color: AppTheme.primaryMedium,
    ),
  ];

  List<AppNotification> get _filteredNotifications {
    var filtered = _notifications.where((notification) {
      if (_showOnlyUnread && notification.isRead) return false;
      if (_filterType == 'all') return true;
      return notification.type.toString().split('.').last == _filterType;
    }).toList();
    
    // Ordenar por prioridad y fecha
    filtered.sort((a, b) {
      // Primero por prioridad
      final priorityComparison = _getPriorityOrder(b.priority).compareTo(_getPriorityOrder(a.priority));
      if (priorityComparison != 0) return priorityComparison;
      // Luego por fecha (más recientes primero)
      return b.timestamp.compareTo(a.timestamp);
    });
    
    return filtered;
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.notifications),
            if (_unreadCount > 0)
              Text(
                '$_unreadCount sin leer',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_showOnlyUnread ? Icons.mark_email_read : Icons.mark_email_unread),
            onPressed: () {
              setState(() {
                _showOnlyUnread = !_showOnlyUnread;
              });
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'mark_all_read':
                  _markAllAsRead();
                  break;
                case 'clear_read':
                  _clearReadNotifications();
                  break;
                case 'settings':
                  _showNotificationSettings();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: ListTile(
                  leading: Icon(Icons.done_all),
                  title: Text('Marcar todo como leído'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'clear_read',
                child: ListTile(
                  leading: Icon(Icons.clear_all),
                  title: Text('Limpiar leídas'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Configuración'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Estadísticas de notificaciones
          _buildNotificationStats(localizations, theme),
          
          // Tabs de filtros
          _buildFilterTabs(localizations, theme),
          
          // Lista de notificaciones
          Expanded(
            child: _buildNotificationsList(localizations, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationStats(AppLocalizations localizations, ThemeData theme) {
    final stats = _getNotificationStats();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryMedium.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Sin leer',
              stats['unread'].toString(),
              Icons.mark_email_unread,
              AppTheme.warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Urgentes',
              stats['urgent'].toString(),
              Icons.priority_high,
              AppTheme.error,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Hoy',
              stats['today'].toString(),
              Icons.today,
              AppTheme.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Total',
              stats['total'].toString(),
              Icons.notifications,
              AppTheme.accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(AppLocalizations localizations, ThemeData theme) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppTheme.primaryMedium,
        labelColor: AppTheme.primaryMedium,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        onTap: (index) {
          setState(() {
            switch (index) {
              case 0:
                _filterType = 'all';
                break;
              case 1:
                _filterType = 'delivery';
                break;
              case 2:
                _filterType = 'alert';
                break;
              case 3:
                _filterType = 'system';
                break;
            }
          });
        },
        tabs: [
          Tab(text: 'Todas (${_notifications.length})'),
          Tab(text: 'Entregas (${_notifications.where((n) => n.type == NotificationType.delivery).length})'),
          Tab(text: 'Alertas (${_notifications.where((n) => n.type == NotificationType.alert).length})'),
          Tab(text: 'Sistema (${_notifications.where((n) => n.type == NotificationType.system).length})'),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(AppLocalizations localizations, ThemeData theme) {
    final filteredNotifications = _filteredNotifications;
    
    if (filteredNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _showOnlyUnread ? 'No hay notificaciones sin leer' : 'No hay notificaciones',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        return _buildNotificationCard(notification, localizations, theme);
      },
    );
  }

  Widget _buildNotificationCard(
    AppNotification notification,
    AppLocalizations localizations,
    ThemeData theme,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: notification.isRead ? 1 : 3,
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: notification.isRead 
                ? null 
                : Border.all(color: notification.color.withOpacity(0.3), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: notification.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      notification.icon,
                      color: notification.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                                  color: AppTheme.primaryDark,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildPriorityBadge(notification.priority),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!notification.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: notification.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Text(
                notification.message,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Acciones de la notificación
              if (notification.actionData.isNotEmpty)
                _buildNotificationActions(notification),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(NotificationPriority priority) {
    Color color;
    String label;
    
    switch (priority) {
      case NotificationPriority.urgent:
        color = AppTheme.error;
        label = 'URGENTE';
        break;
      case NotificationPriority.high:
        color = AppTheme.warning;
        label = 'ALTA';
        break;
      case NotificationPriority.medium:
        color = AppTheme.info;
        label = 'MEDIA';
        break;
      case NotificationPriority.low:
        color = Colors.grey;
        label = 'BAJA';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNotificationActions(AppNotification notification) {
    final actions = <Widget>[];
    final actionData = notification.actionData;
    
    switch (actionData['action']) {
      case 'view_details':
        actions.add(
          OutlinedButton.icon(
            onPressed: () => _navigateToShipmentDetails(actionData['shipmentId']),
            icon: const Icon(Icons.info_outline, size: 16),
            label: const Text('Ver detalles'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.info,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
        );
        break;
        
      case 'view_sensor':
        actions.add(
          OutlinedButton.icon(
            onPressed: () => _navigateToSensorDetails(actionData['sensorId']),
            icon: const Icon(Icons.sensors, size: 16),
            label: const Text('Ver sensor'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.warning,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
        );
        break;
        
      case 'track':
        actions.add(
          ElevatedButton.icon(
            onPressed: () => _navigateToTracking(actionData['shipmentId']),
            icon: const Icon(Icons.track_changes, size: 16),
            label: const Text('Rastrear'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryMedium,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
        );
        break;
        
      case 'update_app':
        actions.add(
          ElevatedButton.icon(
            onPressed: () => _showUpdateDialog(),
            icon: const Icon(Icons.download, size: 16),
            label: const Text('Actualizar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
        );
        break;
    }
    
    // Siempre agregar opción para marcar como leída
    if (!notification.isRead) {
      actions.add(
        TextButton.icon(
          onPressed: () => _markAsRead(notification.id),
          icon: const Icon(Icons.done, size: 16),
          label: const Text('Marcar leída'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[600],
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: actions,
    );
  }

  Map<String, int> _getNotificationStats() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return {
      'unread': _notifications.where((n) => !n.isRead).length,
      'urgent': _notifications.where((n) => n.priority == NotificationPriority.urgent).length,
      'today': _notifications.where((n) => n.timestamp.isAfter(today)).length,
      'total': _notifications.length,
    };
  }

  int _getPriorityOrder(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.urgent:
        return 4;
      case NotificationPriority.high:
        return 3;
      case NotificationPriority.medium:
        return 2;
      case NotificationPriority.low:
        return 1;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} día${difference.inDays == 1 ? '' : 's'}';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} hora${difference.inHours == 1 ? '' : 's'}';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} minuto${difference.inMinutes == 1 ? '' : 's'}';
    } else {
      return 'Ahora mismo';
    }
  }

  void _handleNotificationTap(AppNotification notification) {
    if (!notification.isRead) {
      _markAsRead(notification.id);
    }
    
    // Ejecutar acción principal si existe
    final actionData = notification.actionData;
    if (actionData.isNotEmpty) {
      switch (actionData['action']) {
        case 'view_details':
          _navigateToShipmentDetails(actionData['shipmentId']);
          break;
        case 'view_sensor':
          _navigateToSensorDetails(actionData['sensorId']);
          break;
        case 'track':
          _navigateToTracking(actionData['shipmentId']);
          break;
        default:
          _showNotificationDetails(notification);
      }
    } else {
      _showNotificationDetails(notification);
    }
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todas las notificaciones marcadas como leídas'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _clearReadNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Limpiar notificaciones'),
        content: const Text('¿Estás seguro de que quieres eliminar todas las notificaciones leídas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notifications.removeWhere((n) => n.isRead);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notificaciones leídas eliminadas'),
                  backgroundColor: AppTheme.info,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Configuración de Notificaciones',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 20),
              
              _buildSettingSwitch('Notificaciones Push', true),
              _buildSettingSwitch('Alertas de entrega', true),
              _buildSettingSwitch('Alertas de sensor', true),
              _buildSettingSwitch('Recordatorios de mantenimiento', false),
              _buildSettingSwitch('Actualizaciones del sistema', true),
              _buildSettingSwitch('Notificaciones por email', false),
              
              const SizedBox(height: 20),
              const Text(
                'Horario de silencio',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('22:00'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('a'),
                  ),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('07:00'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingSwitch(String title, bool value) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (newValue) {
        // Implementar cambio de configuración
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title ${newValue ? 'activado' : 'desactivado'}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      activeColor: AppTheme.primaryMedium,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showNotificationDetails(AppNotification notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(notification.icon, color: notification.color),
            const SizedBox(width: 8),
            Expanded(child: Text(notification.title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 16),
            Text(
              'Recibida: ${_formatTimestamp(notification.timestamp)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _navigateToShipmentDetails(String shipmentId) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navegando a detalles del envío $shipmentId'),
        backgroundColor: AppTheme.info,
      ),
    );
  }

  void _navigateToSensorDetails(String sensorId) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navegando a detalles del sensor $sensorId'),
        backgroundColor: AppTheme.warning,
      ),
    );
  }

  void _navigateToTracking(String shipmentId) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abriendo tracking del envío $shipmentId'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Actualización Disponible'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nueva versión 1.2.0 disponible'),
            SizedBox(height: 8),
            Text('Mejoras incluidas:'),
            Text('• Gestión mejorada de sensores'),
            Text('• Nuevas métricas de analytics'),
            Text('• Corrección de errores'),
            Text('• Optimización de rendimiento'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Más tarde'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Iniciando descarga de actualización...'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.success,
              foregroundColor: Colors.white,
            ),
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }
}

// Modelos de datos
class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic> actionData;
  final IconData icon;
  final Color color;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.timestamp,
    required this.isRead,
    required this.actionData,
    required this.icon,
    required this.color,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    DateTime? timestamp,
    bool? isRead,
    Map<String, dynamic>? actionData,
    IconData? icon,
    Color? color,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      actionData: actionData ?? this.actionData,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}

enum NotificationType {
  delivery,
  alert,
  shipment,
  system,
  delay,
  maintenance,
}

enum NotificationPriority {
  urgent,
  high,
  medium,
  low,
}