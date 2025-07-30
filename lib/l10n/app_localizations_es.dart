// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcomeMessage => 'BIENVENIDO';

  @override
  String get userHint => 'Usuario';

  @override
  String get passwordHint => 'Contraseña';

  @override
  String get loginButton => 'Entrar';

  @override
  String get invalidCredentials =>
      'Credenciales no válidas. Inténtalo de nuevo.';

  @override
  String get home => 'Inicio';

  @override
  String get status => 'Estado';

  @override
  String get history => 'Historial';

  @override
  String get shipments => 'Envíos';

  @override
  String get sensors => 'Sensores';

  @override
  String get admin => 'Admin';

  @override
  String lastUpdate(String time) {
    return 'Última actualización: $time';
  }

  @override
  String get searchByProductOrOwner => 'Buscar por producto o propietario...';

  @override
  String get shipmentsSummary => 'Resumen de Envíos';

  @override
  String get inTransit => 'En Tránsito';

  @override
  String get delivered => 'Entregados';

  @override
  String get orders => 'Pedidos';

  @override
  String get reminderIn10s => 'Notificar en 10s';

  @override
  String get reminderSet => 'Recordatorio programado en 10 segundos.';

  @override
  String get air => 'Aéreos ✈️';

  @override
  String get land => 'Terrestres 🚛';

  @override
  String get searchByOrderId => 'Buscar por ID de Pedido...';

  @override
  String get noOrdersFound => 'No se encontraron pedidos con ese ID.';

  @override
  String orderId(String id) {
    return 'ID Pedido: $id';
  }

  @override
  String owner(String name) {
    return 'Propietario: $name';
  }

  @override
  String get bluetoothDevices => 'Dispositivos Bluetooth';

  @override
  String get noDevicesFound =>
      'No se encontraron dispositivos. Asegúrate de que el Bluetooth esté activado y presiona refrescar.';

  @override
  String get searchDevices => 'Buscar Dispositivos';

  @override
  String get unnamedDevice => 'Dispositivo sin nombre';

  @override
  String get connect => 'Conectar';

  @override
  String get connecting => 'Conectando...';

  @override
  String get connectionError => 'Error al conectar';

  @override
  String get sensorData => 'Datos del Sensor';

  @override
  String get requestData => 'Solicitar Datos';

  @override
  String get temperatureLM35 => 'Temperatura (LM35)';

  @override
  String get temperatureDHT => 'Temperatura (DHT11)';

  @override
  String get humidity => 'Humedad';

  @override
  String get light => 'Luz';

  @override
  String get language => 'Idioma';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'English';

  @override
  String get dashboard => 'Panel de Control';

  @override
  String get todayStats => 'Estadísticas de Hoy';

  @override
  String get weeklyReport => 'Reporte Semanal';

  @override
  String get monthlyReport => 'Reporte Mensual';

  @override
  String get totalShipments => 'Total de Envíos';

  @override
  String get activeShipments => 'Envíos Activos';

  @override
  String get completedToday => 'Completados Hoy';

  @override
  String get avgDeliveryTime => 'Tiempo Promedio de Entrega';

  @override
  String get days => 'días';

  @override
  String get hours => 'horas';

  @override
  String get minutes => 'minutos';

  @override
  String get performance => 'Rendimiento';

  @override
  String get efficiency => 'Eficiencia';

  @override
  String get satisfactionRate => 'Tasa de Satisfacción';

  @override
  String get onTimeDeliveries => 'Entregas a Tiempo';

  @override
  String get quickActions => 'Acciones Rápidas';

  @override
  String get createShipment => 'Crear Envío';

  @override
  String get scanQR => 'Escanear QR';

  @override
  String get emergencyAlert => 'Alerta de Emergencia';

  @override
  String get viewReports => 'Ver Reportes';

  @override
  String get newShipment => 'Nuevo Envío';

  @override
  String get editShipment => 'Editar Envío';

  @override
  String get shipmentDetails => 'Detalles del Envío';

  @override
  String get trackingNumber => 'Número de Seguimiento';

  @override
  String get trackingId => 'ID de Seguimiento';

  @override
  String get recipient => 'Destinatario';

  @override
  String get sender => 'Remitente';

  @override
  String get origin => 'Origen';

  @override
  String get destination => 'Destino';

  @override
  String get estimatedDelivery => 'Entrega Estimada';

  @override
  String get actualDelivery => 'Entrega Real';

  @override
  String get weight => 'Peso';

  @override
  String get dimensions => 'Dimensiones';

  @override
  String get value => 'Valor';

  @override
  String get priority => 'Prioridad';

  @override
  String get low => 'Baja';

  @override
  String get medium => 'Media';

  @override
  String get high => 'Alta';

  @override
  String get urgent => 'Urgente';

  @override
  String get packageType => 'Tipo de Paquete';

  @override
  String get fragile => 'Frágil';

  @override
  String get liquid => 'Líquido';

  @override
  String get electronic => 'Electrónico';

  @override
  String get document => 'Documento';

  @override
  String get other => 'Otro';

  @override
  String get route => 'Ruta';

  @override
  String get currentLocation => 'Ubicación Actual';

  @override
  String get nextStop => 'Próxima Parada';

  @override
  String get estimatedArrival => 'Llegada Estimada';

  @override
  String get pending => 'Pendiente';

  @override
  String get processing => 'Procesando';

  @override
  String get shipped => 'Enviado';

  @override
  String get outForDelivery => 'En Reparto';

  @override
  String get delayed => 'Retrasado';

  @override
  String get failed => 'Fallido';

  @override
  String get returned => 'Devuelto';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get filters => 'Filtros';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get dateRange => 'Rango de Fechas';

  @override
  String get from => 'Desde';

  @override
  String get to => 'Hasta';

  @override
  String get apply => 'Aplicar';

  @override
  String get clear => 'Limpiar';

  @override
  String get reset => 'Restablecer';

  @override
  String get search => 'Buscar';

  @override
  String get noResults => 'Sin resultados';

  @override
  String showingResults(int count) {
    return 'Mostrando $count resultados';
  }

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Configuración';

  @override
  String get account => 'Cuenta';

  @override
  String get preferences => 'Preferencias';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get theme => 'Tema';

  @override
  String get lightMode => 'Modo Claro';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get systemMode => 'Seguir Sistema';

  @override
  String get pushNotifications => 'Notificaciones Push';

  @override
  String get emailNotifications => 'Notificaciones por Email';

  @override
  String get smsNotifications => 'Notificaciones SMS';

  @override
  String get privacy => 'Privacidad';

  @override
  String get security => 'Seguridad';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get sensorDashboard => 'Panel de Sensores';

  @override
  String get connectedDevices => 'Dispositivos Conectados';

  @override
  String get deviceStatus => 'Estado del Dispositivo';

  @override
  String get connected => 'Conectado';

  @override
  String get disconnected => 'Desconectado';

  @override
  String get batteryLevel => 'Nivel de Batería';

  @override
  String get signalStrength => 'Fuerza de Señal';

  @override
  String get lastReading => 'Última Lectura';

  @override
  String get configure => 'Configurar';

  @override
  String get calibrate => 'Calibrar';

  @override
  String get alerts => 'Alertas';

  @override
  String get thresholds => 'Umbrales';

  @override
  String get minValue => 'Valor Mínimo';

  @override
  String get maxValue => 'Valor Máximo';

  @override
  String get gps => 'GPS';

  @override
  String get accelerometer => 'Acelerómetro';

  @override
  String get pressure => 'Presión';

  @override
  String get altitude => 'Altitud';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get thisWeek => 'Esta Semana';

  @override
  String get thisMonth => 'Este Mes';

  @override
  String get thisYear => 'Este Año';

  @override
  String get lastWeek => 'Semana Pasada';

  @override
  String get lastMonth => 'Mes Pasado';

  @override
  String get lastYear => 'Año Pasado';

  @override
  String get custom => 'Personalizado';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get view => 'Ver';

  @override
  String get share => 'Compartir';

  @override
  String get export => 'Exportar';

  @override
  String get import => 'Importar';

  @override
  String get download => 'Descargar';

  @override
  String get upload => 'Subir';

  @override
  String get refresh => 'Actualizar';

  @override
  String get retry => 'Reintentar';

  @override
  String get back => 'Atrás';

  @override
  String get next => 'Siguiente';

  @override
  String get previous => 'Anterior';

  @override
  String get done => 'Hecho';

  @override
  String get confirm => 'Confirmar';

  @override
  String get error => 'Error';

  @override
  String get success => 'Éxito';

  @override
  String get warning => 'Advertencia';

  @override
  String get info => 'Información';

  @override
  String get loading => 'Cargando...';

  @override
  String get pleaseWait => 'Por favor espera...';

  @override
  String get operationCompleted => 'Operación completada exitosamente';

  @override
  String get operationFailed => 'La operación falló';

  @override
  String get networkError => 'Error de conexión';

  @override
  String get serverError => 'Error del servidor';

  @override
  String get validationError => 'Error de validación';

  @override
  String get permissionDenied => 'Permiso denegado';

  @override
  String get featureNotAvailable => 'Función no disponible';

  @override
  String get required => 'Requerido';

  @override
  String get optional => 'Opcional';

  @override
  String get invalidFormat => 'Formato inválido';

  @override
  String get tooShort => 'Muy corto';

  @override
  String get tooLong => 'Muy largo';

  @override
  String get invalidEmail => 'Email inválido';

  @override
  String get passwordTooWeak => 'Contraseña muy débil';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get map => 'Mapa';

  @override
  String get satellite => 'Satélite';

  @override
  String get hybrid => 'Híbrido';

  @override
  String get terrain => 'Terreno';

  @override
  String get currentPosition => 'Posición Actual';

  @override
  String get selectLocation => 'Seleccionar Ubicación';

  @override
  String get address => 'Dirección';

  @override
  String get coordinates => 'Coordenadas';

  @override
  String get latitude => 'Latitud';

  @override
  String get longitude => 'Longitud';

  @override
  String get camera => 'Cámara';

  @override
  String get gallery => 'Galería';

  @override
  String get takePhoto => 'Tomar Foto';

  @override
  String get selectPhoto => 'Seleccionar Foto';

  @override
  String get removePhoto => 'Quitar Foto';

  @override
  String get photos => 'Fotos';

  @override
  String get attachments => 'Adjuntos';

  @override
  String get support => 'Soporte';

  @override
  String get helpCenter => 'Centro de Ayuda';

  @override
  String get contactUs => 'Contáctanos';

  @override
  String get sendMessage => 'Enviar Mensaje';

  @override
  String get typeMessage => 'Escribe un mensaje...';

  @override
  String get chatBot => 'Bot de Chat';

  @override
  String get faq => 'Preguntas Frecuentes';

  @override
  String get reports => 'Reportes';

  @override
  String get analytics => 'Análisis';

  @override
  String get insights => 'Insights';

  @override
  String get trends => 'Tendencias';

  @override
  String get comparison => 'Comparación';

  @override
  String get forecast => 'Pronóstico';

  @override
  String get kpi => 'Indicadores Clave';

  @override
  String get metrics => 'Métricas';

  @override
  String get qrCode => 'Código QR';

  @override
  String get barcode => 'Código de Barras';

  @override
  String get scanCode => 'Escanear Código';

  @override
  String get generateQR => 'Generar QR';

  @override
  String get invalidCode => 'Código inválido';

  @override
  String get codeScanned => 'Código escaneado exitosamente';
}
