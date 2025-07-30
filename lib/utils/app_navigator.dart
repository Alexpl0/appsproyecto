import 'package:flutter/material.dart';

/// Sistema de navegación centralizado para la aplicación.
/// Proporciona métodos de navegación consistentes y manejo de parámetros.
class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  /// Obtener el contexto actual de navegación
  static BuildContext? get currentContext => navigatorKey.currentContext;
  
  /// Obtener el estado del navegador
  static NavigatorState? get navigator => navigatorKey.currentState;

  // === MÉTODOS DE NAVEGACIÓN BÁSICOS ===

  /// Navegar a una nueva pantalla
  static Future<T?> push<T extends Object?>(String routeName, {Object? arguments}) {
    return navigator!.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Reemplazar la pantalla actual
  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return navigator!.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Navegar y limpiar el stack hasta la ruta especificada
  static Future<T?> pushNamedAndClearUntil<T extends Object?>(
    String routeName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return navigator!.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  /// Volver a la pantalla anterior
  static void pop<T extends Object?>([T? result]) {
    if (navigator!.canPop()) {
      navigator!.pop<T>(result);
    }
  }

  /// Volver hasta una ruta específica
  static void popUntil(String routeName) {
    navigator!.popUntil(ModalRoute.withName(routeName));
  }

  /// Verificar si se puede hacer pop
  static bool canPop() {
    return navigator!.canPop();
  }

  // === NAVEGACIÓN ESPECÍFICA DE LA APP ===

  /// Ir a la pantalla de login
  static Future<void> goToLogin({bool clearStack = false}) {
    if (clearStack) {
      return pushNamedAndClearUntil('/login', (route) => false);
    }
    return push('/login');
  }

  /// Ir a la pantalla principal
  static Future<void> goToHome({bool clearStack = false}) {
    if (clearStack) {
      return pushNamedAndClearUntil('/home', (route) => false);
    }
    return push('/home');
  }

  /// Ir al perfil de usuario
  static Future<void> goToProfile() {
    return push('/profile');
  }

  /// Ir a configuración
  static Future<void> goToSettings() {
    return push('/settings');
  }

  /// Abrir el escáner QR
  static Future<void> openQRScanner() {
    return push('/qr-scanner');
  }

  /// Ir al centro de notificaciones
  static Future<void> goToNotifications() {
    return push('/notifications');
  }

  /// Ir al chat de soporte
  static Future<void> goToSupportChat() {
    return push('/support-chat');
  }

  /// Ir a la búsqueda global
  static Future<void> goToSearch() {
    return push('/search');
  }

  // === NAVEGACIÓN DE ENVÍOS ===

  /// Ir a la lista de envíos
  static Future<void> goToShipments() {
    return push('/shipments');
  }

  /// Ir a los detalles de un envío específico
  static Future<void> goToShipmentDetails(String shipmentId) {
    return push('/shipment-details', arguments: {'shipmentId': shipmentId});
  }

  /// Crear un nuevo envío
  static Future<void> createNewShipment() {
    return push('/shipments'); // La pantalla de envíos maneja la creación
  }

  // === NAVEGACIÓN DE SENSORES ===

  /// Ir a la lista de sensores
  static Future<void> goToSensors() {
    return push('/sensors');
  }

  /// Ir a los detalles de un sensor específico
  static Future<void> goToSensorDetails(String sensorId) {
    return push('/sensor-details', arguments: {'sensorId': sensorId});
  }

  // === NAVEGACIÓN DE HISTORIAL ===

  /// Ir al historial y analytics
  static Future<void> goToHistory() {
    return push('/history');
  }

  // === NAVEGACIÓN DE MAPAS ===

  /// Abrir el mapa con todos los envíos
  static Future<void> openMapAllShipments() {
    return push('/map', arguments: {'showAllShipments': true});
  }

  /// Abrir el mapa para un envío específico
  static Future<void> openMapForShipment(String shipmentId) {
    return push('/map', arguments: {
      'shipmentId': shipmentId,
      'showAllShipments': false,
    });
  }

  // === MÉTODOS DE UTILIDAD ===

  /// Mostrar diálogo de confirmación
  static Future<bool?> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: currentContext!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDestructive ? Colors.red : null,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Mostrar bottom sheet personalizado
  static Future<T?> showCustomBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: currentContext!,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: child,
      ),
    );
  }

  /// Mostrar snackbar de éxito
  static void showSuccessMessage(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
    );
  }

  /// Mostrar snackbar de error
  static void showErrorMessage(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.red,
      icon: Icons.error,
    );
  }

  /// Mostrar snackbar de información
  static void showInfoMessage(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.blue,
      icon: Icons.info,
    );
  }

  /// Mostrar snackbar de advertencia
  static void showWarningMessage(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.orange,
      icon: Icons.warning,
    );
  }

  /// Método privado para mostrar snackbars
  static void _showSnackBar(
    String message, {
    required Color backgroundColor,
    required IconData icon,
  }) {
    final messengerState = ScaffoldMessenger.of(currentContext!);
    
    // Limpiar snackbars anteriores
    messengerState.clearSnackBars();
    
    messengerState.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Mostrar diálogo de carga
  static void showLoadingDialog({String message = 'Cargando...'}) {
    showDialog(
      context: currentContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  /// Cerrar diálogo de carga
  static void hideLoadingDialog() {
    if (navigator!.canPop()) {
      navigator!.pop();
    }
  }

  /// Mostrar diálogo de selección
  static Future<T?> showSelectionDialog<T>({
    required String title,
    required List<SelectionOption<T>> options,
  }) {
    return showDialog<T>(
      context: currentContext!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            return ListTile(
              leading: option.icon != null ? Icon(option.icon) : null,
              title: Text(option.title),
              subtitle: option.subtitle != null ? Text(option.subtitle!) : null,
              onTap: () => Navigator.of(context).pop(option.value),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  // === NAVEGACIÓN AVANZADA ===

  /// Navegación con animación personalizada
  static Future<T?> pushWithCustomTransition<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    SlideDirection direction = SlideDirection.fromRight,
  }) {
    return navigator!.push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin;
          switch (direction) {
            case SlideDirection.fromRight:
              begin = const Offset(1.0, 0.0);
              break;
            case SlideDirection.fromLeft:
              begin = const Offset(-1.0, 0.0);
              break;
            case SlideDirection.fromTop:
              begin = const Offset(0.0, -1.0);
              break;
            case SlideDirection.fromBottom:
              begin = const Offset(0.0, 1.0);
              break;
          }

          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }

  /// Navegación con fade transition
  static Future<T?> pushWithFadeTransition<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return navigator!.push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// Verificar si estamos en una ruta específica
  static bool isCurrentRoute(String routeName) {
    bool isCurrent = false;
    navigator!.popUntil((route) {
      if (route.settings.name == routeName) {
        isCurrent = true;
      }
      return true;
    });
    return isCurrent;
  }

  /// Obtener el nombre de la ruta actual
  static String? getCurrentRouteName() {
    String? currentRoute;
    navigator!.popUntil((route) {
      currentRoute = route.settings.name;
      return true;
    });
    return currentRoute;
  }

  /// Reiniciar la aplicación (ir a login y limpiar stack)
  static Future<void> restartApp() {
    return goToLogin(clearStack: true);
  }

  /// Cerrar sesión
  static Future<void> logout() {
    return pushNamedAndClearUntil('/login', (route) => false);
  }
}

// === CLASES DE UTILIDAD ===

class SelectionOption<T> {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final T value;

  SelectionOption({
    required this.title,
    this.subtitle,
    this.icon,
    required this.value,
  });
}

enum SlideDirection {
  fromRight,
  fromLeft,
  fromTop,
  fromBottom,
}

// === EXTENSIONES ÚTILES ===

extension BuildContextNavigation on BuildContext {
  /// Acceso rápido al navegador desde cualquier BuildContext
  NavigatorState get navigator => Navigator.of(this);
  
  /// Ir atrás de forma segura
  void popSafe<T>([T? result]) {
    if (navigator.canPop()) {
      navigator.pop<T>(result);
    }
  }
  
  /// Mostrar snackbar desde cualquier contexto
  void showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// === RUTAS CONSTANTES ===

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String qrScanner = '/qr-scanner';
  static const String notifications = '/notifications';
  static const String supportChat = '/support-chat';
  static const String search = '/search';
  static const String shipments = '/shipments';
  static const String shipmentDetails = '/shipment-details';
  static const String sensors = '/sensors';
  static const String sensorDetails = '/sensor-details';
  static const String history = '/history';
  static const String map = '/map';
  
  /// Obtener todas las rutas disponibles
  static List<String> get allRoutes => [
    login,
    home,
    profile,
    settings,
    qrScanner,
    notifications,
    supportChat,
    search,
    shipments,
    shipmentDetails,
    sensors,
    sensorDetails,
    history,
    map,
  ];
}