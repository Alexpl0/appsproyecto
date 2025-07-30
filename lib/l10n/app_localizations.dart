import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @welcomeMessage.
  ///
  /// In es, this message translates to:
  /// **'BIENVENIDO'**
  String get welcomeMessage;

  /// No description provided for @userHint.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get userHint;

  /// No description provided for @passwordHint.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get passwordHint;

  /// No description provided for @loginButton.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get loginButton;

  /// No description provided for @invalidCredentials.
  ///
  /// In es, this message translates to:
  /// **'Credenciales no válidas. Inténtalo de nuevo.'**
  String get invalidCredentials;

  /// No description provided for @home.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get home;

  /// No description provided for @status.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get status;

  /// No description provided for @history.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get history;

  /// No description provided for @shipments.
  ///
  /// In es, this message translates to:
  /// **'Envíos'**
  String get shipments;

  /// No description provided for @sensors.
  ///
  /// In es, this message translates to:
  /// **'Sensores'**
  String get sensors;

  /// No description provided for @admin.
  ///
  /// In es, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @lastUpdate.
  ///
  /// In es, this message translates to:
  /// **'Última actualización: {time}'**
  String lastUpdate(String time);

  /// No description provided for @searchByProductOrOwner.
  ///
  /// In es, this message translates to:
  /// **'Buscar por producto o propietario...'**
  String get searchByProductOrOwner;

  /// No description provided for @shipmentsSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen de Envíos'**
  String get shipmentsSummary;

  /// No description provided for @inTransit.
  ///
  /// In es, this message translates to:
  /// **'En Tránsito'**
  String get inTransit;

  /// No description provided for @delivered.
  ///
  /// In es, this message translates to:
  /// **'Entregados'**
  String get delivered;

  /// No description provided for @orders.
  ///
  /// In es, this message translates to:
  /// **'Pedidos'**
  String get orders;

  /// No description provided for @reminderIn10s.
  ///
  /// In es, this message translates to:
  /// **'Notificar en 10s'**
  String get reminderIn10s;

  /// No description provided for @reminderSet.
  ///
  /// In es, this message translates to:
  /// **'Recordatorio programado en 10 segundos.'**
  String get reminderSet;

  /// No description provided for @air.
  ///
  /// In es, this message translates to:
  /// **'Aéreos ✈️'**
  String get air;

  /// No description provided for @land.
  ///
  /// In es, this message translates to:
  /// **'Terrestres 🚛'**
  String get land;

  /// No description provided for @searchByOrderId.
  ///
  /// In es, this message translates to:
  /// **'Buscar por ID de Pedido...'**
  String get searchByOrderId;

  /// No description provided for @noOrdersFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron pedidos con ese ID.'**
  String get noOrdersFound;

  /// No description provided for @orderId.
  ///
  /// In es, this message translates to:
  /// **'ID Pedido: {id}'**
  String orderId(String id);

  /// No description provided for @owner.
  ///
  /// In es, this message translates to:
  /// **'Propietario: {name}'**
  String owner(String name);

  /// No description provided for @bluetoothDevices.
  ///
  /// In es, this message translates to:
  /// **'Dispositivos Bluetooth'**
  String get bluetoothDevices;

  /// No description provided for @noDevicesFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron dispositivos. Asegúrate de que el Bluetooth esté activado y presiona refrescar.'**
  String get noDevicesFound;

  /// No description provided for @searchDevices.
  ///
  /// In es, this message translates to:
  /// **'Buscar Dispositivos'**
  String get searchDevices;

  /// No description provided for @unnamedDevice.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo sin nombre'**
  String get unnamedDevice;

  /// No description provided for @connect.
  ///
  /// In es, this message translates to:
  /// **'Conectar'**
  String get connect;

  /// No description provided for @connecting.
  ///
  /// In es, this message translates to:
  /// **'Conectando...'**
  String get connecting;

  /// No description provided for @connectionError.
  ///
  /// In es, this message translates to:
  /// **'Error al conectar'**
  String get connectionError;

  /// No description provided for @sensorData.
  ///
  /// In es, this message translates to:
  /// **'Datos del Sensor'**
  String get sensorData;

  /// No description provided for @requestData.
  ///
  /// In es, this message translates to:
  /// **'Solicitar Datos'**
  String get requestData;

  /// No description provided for @temperatureLM35.
  ///
  /// In es, this message translates to:
  /// **'Temperatura (LM35)'**
  String get temperatureLM35;

  /// No description provided for @temperatureDHT.
  ///
  /// In es, this message translates to:
  /// **'Temperatura (DHT11)'**
  String get temperatureDHT;

  /// No description provided for @humidity.
  ///
  /// In es, this message translates to:
  /// **'Humedad'**
  String get humidity;

  /// No description provided for @light.
  ///
  /// In es, this message translates to:
  /// **'Luz'**
  String get light;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @spanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @dashboard.
  ///
  /// In es, this message translates to:
  /// **'Panel de Control'**
  String get dashboard;

  /// No description provided for @todayStats.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas de Hoy'**
  String get todayStats;

  /// No description provided for @weeklyReport.
  ///
  /// In es, this message translates to:
  /// **'Reporte Semanal'**
  String get weeklyReport;

  /// No description provided for @monthlyReport.
  ///
  /// In es, this message translates to:
  /// **'Reporte Mensual'**
  String get monthlyReport;

  /// No description provided for @totalShipments.
  ///
  /// In es, this message translates to:
  /// **'Total de Envíos'**
  String get totalShipments;

  /// No description provided for @activeShipments.
  ///
  /// In es, this message translates to:
  /// **'Envíos Activos'**
  String get activeShipments;

  /// No description provided for @completedToday.
  ///
  /// In es, this message translates to:
  /// **'Completados Hoy'**
  String get completedToday;

  /// No description provided for @avgDeliveryTime.
  ///
  /// In es, this message translates to:
  /// **'Tiempo Promedio de Entrega'**
  String get avgDeliveryTime;

  /// No description provided for @days.
  ///
  /// In es, this message translates to:
  /// **'días'**
  String get days;

  /// No description provided for @hours.
  ///
  /// In es, this message translates to:
  /// **'horas'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In es, this message translates to:
  /// **'minutos'**
  String get minutes;

  /// No description provided for @performance.
  ///
  /// In es, this message translates to:
  /// **'Rendimiento'**
  String get performance;

  /// No description provided for @efficiency.
  ///
  /// In es, this message translates to:
  /// **'Eficiencia'**
  String get efficiency;

  /// No description provided for @satisfactionRate.
  ///
  /// In es, this message translates to:
  /// **'Tasa de Satisfacción'**
  String get satisfactionRate;

  /// No description provided for @onTimeDeliveries.
  ///
  /// In es, this message translates to:
  /// **'Entregas a Tiempo'**
  String get onTimeDeliveries;

  /// No description provided for @quickActions.
  ///
  /// In es, this message translates to:
  /// **'Acciones Rápidas'**
  String get quickActions;

  /// No description provided for @createShipment.
  ///
  /// In es, this message translates to:
  /// **'Crear Envío'**
  String get createShipment;

  /// No description provided for @scanQR.
  ///
  /// In es, this message translates to:
  /// **'Escanear QR'**
  String get scanQR;

  /// No description provided for @emergencyAlert.
  ///
  /// In es, this message translates to:
  /// **'Alerta de Emergencia'**
  String get emergencyAlert;

  /// No description provided for @viewReports.
  ///
  /// In es, this message translates to:
  /// **'Ver Reportes'**
  String get viewReports;

  /// No description provided for @newShipment.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Envío'**
  String get newShipment;

  /// No description provided for @editShipment.
  ///
  /// In es, this message translates to:
  /// **'Editar Envío'**
  String get editShipment;

  /// No description provided for @shipmentDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles del Envío'**
  String get shipmentDetails;

  /// No description provided for @trackingNumber.
  ///
  /// In es, this message translates to:
  /// **'Número de Seguimiento'**
  String get trackingNumber;

  /// No description provided for @trackingId.
  ///
  /// In es, this message translates to:
  /// **'ID de Seguimiento'**
  String get trackingId;

  /// No description provided for @recipient.
  ///
  /// In es, this message translates to:
  /// **'Destinatario'**
  String get recipient;

  /// No description provided for @sender.
  ///
  /// In es, this message translates to:
  /// **'Remitente'**
  String get sender;

  /// No description provided for @origin.
  ///
  /// In es, this message translates to:
  /// **'Origen'**
  String get origin;

  /// No description provided for @destination.
  ///
  /// In es, this message translates to:
  /// **'Destino'**
  String get destination;

  /// No description provided for @estimatedDelivery.
  ///
  /// In es, this message translates to:
  /// **'Entrega Estimada'**
  String get estimatedDelivery;

  /// No description provided for @actualDelivery.
  ///
  /// In es, this message translates to:
  /// **'Entrega Real'**
  String get actualDelivery;

  /// No description provided for @weight.
  ///
  /// In es, this message translates to:
  /// **'Peso'**
  String get weight;

  /// No description provided for @dimensions.
  ///
  /// In es, this message translates to:
  /// **'Dimensiones'**
  String get dimensions;

  /// No description provided for @value.
  ///
  /// In es, this message translates to:
  /// **'Valor'**
  String get value;

  /// No description provided for @priority.
  ///
  /// In es, this message translates to:
  /// **'Prioridad'**
  String get priority;

  /// No description provided for @low.
  ///
  /// In es, this message translates to:
  /// **'Baja'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In es, this message translates to:
  /// **'Media'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In es, this message translates to:
  /// **'Alta'**
  String get high;

  /// No description provided for @urgent.
  ///
  /// In es, this message translates to:
  /// **'Urgente'**
  String get urgent;

  /// No description provided for @packageType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de Paquete'**
  String get packageType;

  /// No description provided for @fragile.
  ///
  /// In es, this message translates to:
  /// **'Frágil'**
  String get fragile;

  /// No description provided for @liquid.
  ///
  /// In es, this message translates to:
  /// **'Líquido'**
  String get liquid;

  /// No description provided for @electronic.
  ///
  /// In es, this message translates to:
  /// **'Electrónico'**
  String get electronic;

  /// No description provided for @document.
  ///
  /// In es, this message translates to:
  /// **'Documento'**
  String get document;

  /// No description provided for @other.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get other;

  /// No description provided for @route.
  ///
  /// In es, this message translates to:
  /// **'Ruta'**
  String get route;

  /// No description provided for @currentLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación Actual'**
  String get currentLocation;

  /// No description provided for @nextStop.
  ///
  /// In es, this message translates to:
  /// **'Próxima Parada'**
  String get nextStop;

  /// No description provided for @estimatedArrival.
  ///
  /// In es, this message translates to:
  /// **'Llegada Estimada'**
  String get estimatedArrival;

  /// No description provided for @pending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get pending;

  /// No description provided for @processing.
  ///
  /// In es, this message translates to:
  /// **'Procesando'**
  String get processing;

  /// No description provided for @shipped.
  ///
  /// In es, this message translates to:
  /// **'Enviado'**
  String get shipped;

  /// No description provided for @outForDelivery.
  ///
  /// In es, this message translates to:
  /// **'En Reparto'**
  String get outForDelivery;

  /// No description provided for @delayed.
  ///
  /// In es, this message translates to:
  /// **'Retrasado'**
  String get delayed;

  /// No description provided for @failed.
  ///
  /// In es, this message translates to:
  /// **'Fallido'**
  String get failed;

  /// No description provided for @returned.
  ///
  /// In es, this message translates to:
  /// **'Devuelto'**
  String get returned;

  /// No description provided for @cancelled.
  ///
  /// In es, this message translates to:
  /// **'Cancelado'**
  String get cancelled;

  /// No description provided for @filters.
  ///
  /// In es, this message translates to:
  /// **'Filtros'**
  String get filters;

  /// No description provided for @sortBy.
  ///
  /// In es, this message translates to:
  /// **'Ordenar por'**
  String get sortBy;

  /// No description provided for @dateRange.
  ///
  /// In es, this message translates to:
  /// **'Rango de Fechas'**
  String get dateRange;

  /// No description provided for @from.
  ///
  /// In es, this message translates to:
  /// **'Desde'**
  String get from;

  /// No description provided for @to.
  ///
  /// In es, this message translates to:
  /// **'Hasta'**
  String get to;

  /// No description provided for @apply.
  ///
  /// In es, this message translates to:
  /// **'Aplicar'**
  String get apply;

  /// No description provided for @clear.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get clear;

  /// No description provided for @reset.
  ///
  /// In es, this message translates to:
  /// **'Restablecer'**
  String get reset;

  /// No description provided for @search.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get search;

  /// No description provided for @noResults.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados'**
  String get noResults;

  /// No description provided for @showingResults.
  ///
  /// In es, this message translates to:
  /// **'Mostrando {count} resultados'**
  String showingResults(int count);

  /// No description provided for @profile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In es, this message translates to:
  /// **'Cuenta'**
  String get account;

  /// No description provided for @preferences.
  ///
  /// In es, this message translates to:
  /// **'Preferencias'**
  String get preferences;

  /// No description provided for @notifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notifications;

  /// No description provided for @theme.
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @lightMode.
  ///
  /// In es, this message translates to:
  /// **'Modo Claro'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In es, this message translates to:
  /// **'Modo Oscuro'**
  String get darkMode;

  /// No description provided for @systemMode.
  ///
  /// In es, this message translates to:
  /// **'Seguir Sistema'**
  String get systemMode;

  /// No description provided for @pushNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones Push'**
  String get pushNotifications;

  /// No description provided for @emailNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones por Email'**
  String get emailNotifications;

  /// No description provided for @smsNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones SMS'**
  String get smsNotifications;

  /// No description provided for @privacy.
  ///
  /// In es, this message translates to:
  /// **'Privacidad'**
  String get privacy;

  /// No description provided for @security.
  ///
  /// In es, this message translates to:
  /// **'Seguridad'**
  String get security;

  /// No description provided for @about.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get about;

  /// No description provided for @version.
  ///
  /// In es, this message translates to:
  /// **'Versión'**
  String get version;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get logout;

  /// No description provided for @sensorDashboard.
  ///
  /// In es, this message translates to:
  /// **'Panel de Sensores'**
  String get sensorDashboard;

  /// No description provided for @connectedDevices.
  ///
  /// In es, this message translates to:
  /// **'Dispositivos Conectados'**
  String get connectedDevices;

  /// No description provided for @deviceStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado del Dispositivo'**
  String get deviceStatus;

  /// No description provided for @connected.
  ///
  /// In es, this message translates to:
  /// **'Conectado'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In es, this message translates to:
  /// **'Desconectado'**
  String get disconnected;

  /// No description provided for @batteryLevel.
  ///
  /// In es, this message translates to:
  /// **'Nivel de Batería'**
  String get batteryLevel;

  /// No description provided for @signalStrength.
  ///
  /// In es, this message translates to:
  /// **'Fuerza de Señal'**
  String get signalStrength;

  /// No description provided for @lastReading.
  ///
  /// In es, this message translates to:
  /// **'Última Lectura'**
  String get lastReading;

  /// No description provided for @configure.
  ///
  /// In es, this message translates to:
  /// **'Configurar'**
  String get configure;

  /// No description provided for @calibrate.
  ///
  /// In es, this message translates to:
  /// **'Calibrar'**
  String get calibrate;

  /// No description provided for @alerts.
  ///
  /// In es, this message translates to:
  /// **'Alertas'**
  String get alerts;

  /// No description provided for @thresholds.
  ///
  /// In es, this message translates to:
  /// **'Umbrales'**
  String get thresholds;

  /// No description provided for @minValue.
  ///
  /// In es, this message translates to:
  /// **'Valor Mínimo'**
  String get minValue;

  /// No description provided for @maxValue.
  ///
  /// In es, this message translates to:
  /// **'Valor Máximo'**
  String get maxValue;

  /// No description provided for @gps.
  ///
  /// In es, this message translates to:
  /// **'GPS'**
  String get gps;

  /// No description provided for @accelerometer.
  ///
  /// In es, this message translates to:
  /// **'Acelerómetro'**
  String get accelerometer;

  /// No description provided for @pressure.
  ///
  /// In es, this message translates to:
  /// **'Presión'**
  String get pressure;

  /// No description provided for @altitude.
  ///
  /// In es, this message translates to:
  /// **'Altitud'**
  String get altitude;

  /// No description provided for @today.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In es, this message translates to:
  /// **'Ayer'**
  String get yesterday;

  /// No description provided for @thisWeek.
  ///
  /// In es, this message translates to:
  /// **'Esta Semana'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In es, this message translates to:
  /// **'Este Mes'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In es, this message translates to:
  /// **'Este Año'**
  String get thisYear;

  /// No description provided for @lastWeek.
  ///
  /// In es, this message translates to:
  /// **'Semana Pasada'**
  String get lastWeek;

  /// No description provided for @lastMonth.
  ///
  /// In es, this message translates to:
  /// **'Mes Pasado'**
  String get lastMonth;

  /// No description provided for @lastYear.
  ///
  /// In es, this message translates to:
  /// **'Año Pasado'**
  String get lastYear;

  /// No description provided for @custom.
  ///
  /// In es, this message translates to:
  /// **'Personalizado'**
  String get custom;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @view.
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get view;

  /// No description provided for @share.
  ///
  /// In es, this message translates to:
  /// **'Compartir'**
  String get share;

  /// No description provided for @export.
  ///
  /// In es, this message translates to:
  /// **'Exportar'**
  String get export;

  /// No description provided for @import.
  ///
  /// In es, this message translates to:
  /// **'Importar'**
  String get import;

  /// No description provided for @download.
  ///
  /// In es, this message translates to:
  /// **'Descargar'**
  String get download;

  /// No description provided for @upload.
  ///
  /// In es, this message translates to:
  /// **'Subir'**
  String get upload;

  /// No description provided for @refresh.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get refresh;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @back.
  ///
  /// In es, this message translates to:
  /// **'Atrás'**
  String get back;

  /// No description provided for @next.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In es, this message translates to:
  /// **'Anterior'**
  String get previous;

  /// No description provided for @done.
  ///
  /// In es, this message translates to:
  /// **'Hecho'**
  String get done;

  /// No description provided for @confirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @error.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In es, this message translates to:
  /// **'Éxito'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In es, this message translates to:
  /// **'Advertencia'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get info;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// No description provided for @pleaseWait.
  ///
  /// In es, this message translates to:
  /// **'Por favor espera...'**
  String get pleaseWait;

  /// No description provided for @operationCompleted.
  ///
  /// In es, this message translates to:
  /// **'Operación completada exitosamente'**
  String get operationCompleted;

  /// No description provided for @operationFailed.
  ///
  /// In es, this message translates to:
  /// **'La operación falló'**
  String get operationFailed;

  /// No description provided for @networkError.
  ///
  /// In es, this message translates to:
  /// **'Error de conexión'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In es, this message translates to:
  /// **'Error del servidor'**
  String get serverError;

  /// No description provided for @validationError.
  ///
  /// In es, this message translates to:
  /// **'Error de validación'**
  String get validationError;

  /// No description provided for @permissionDenied.
  ///
  /// In es, this message translates to:
  /// **'Permiso denegado'**
  String get permissionDenied;

  /// No description provided for @featureNotAvailable.
  ///
  /// In es, this message translates to:
  /// **'Función no disponible'**
  String get featureNotAvailable;

  /// No description provided for @required.
  ///
  /// In es, this message translates to:
  /// **'Requerido'**
  String get required;

  /// No description provided for @optional.
  ///
  /// In es, this message translates to:
  /// **'Opcional'**
  String get optional;

  /// No description provided for @invalidFormat.
  ///
  /// In es, this message translates to:
  /// **'Formato inválido'**
  String get invalidFormat;

  /// No description provided for @tooShort.
  ///
  /// In es, this message translates to:
  /// **'Muy corto'**
  String get tooShort;

  /// No description provided for @tooLong.
  ///
  /// In es, this message translates to:
  /// **'Muy largo'**
  String get tooLong;

  /// No description provided for @invalidEmail.
  ///
  /// In es, this message translates to:
  /// **'Email inválido'**
  String get invalidEmail;

  /// No description provided for @passwordTooWeak.
  ///
  /// In es, this message translates to:
  /// **'Contraseña muy débil'**
  String get passwordTooWeak;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get passwordsDoNotMatch;

  /// No description provided for @map.
  ///
  /// In es, this message translates to:
  /// **'Mapa'**
  String get map;

  /// No description provided for @satellite.
  ///
  /// In es, this message translates to:
  /// **'Satélite'**
  String get satellite;

  /// No description provided for @hybrid.
  ///
  /// In es, this message translates to:
  /// **'Híbrido'**
  String get hybrid;

  /// No description provided for @terrain.
  ///
  /// In es, this message translates to:
  /// **'Terreno'**
  String get terrain;

  /// No description provided for @currentPosition.
  ///
  /// In es, this message translates to:
  /// **'Posición Actual'**
  String get currentPosition;

  /// No description provided for @selectLocation.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Ubicación'**
  String get selectLocation;

  /// No description provided for @address.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get address;

  /// No description provided for @coordinates.
  ///
  /// In es, this message translates to:
  /// **'Coordenadas'**
  String get coordinates;

  /// No description provided for @latitude.
  ///
  /// In es, this message translates to:
  /// **'Latitud'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In es, this message translates to:
  /// **'Longitud'**
  String get longitude;

  /// No description provided for @camera.
  ///
  /// In es, this message translates to:
  /// **'Cámara'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In es, this message translates to:
  /// **'Galería'**
  String get gallery;

  /// No description provided for @takePhoto.
  ///
  /// In es, this message translates to:
  /// **'Tomar Foto'**
  String get takePhoto;

  /// No description provided for @selectPhoto.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Foto'**
  String get selectPhoto;

  /// No description provided for @removePhoto.
  ///
  /// In es, this message translates to:
  /// **'Quitar Foto'**
  String get removePhoto;

  /// No description provided for @photos.
  ///
  /// In es, this message translates to:
  /// **'Fotos'**
  String get photos;

  /// No description provided for @attachments.
  ///
  /// In es, this message translates to:
  /// **'Adjuntos'**
  String get attachments;

  /// No description provided for @support.
  ///
  /// In es, this message translates to:
  /// **'Soporte'**
  String get support;

  /// No description provided for @helpCenter.
  ///
  /// In es, this message translates to:
  /// **'Centro de Ayuda'**
  String get helpCenter;

  /// No description provided for @contactUs.
  ///
  /// In es, this message translates to:
  /// **'Contáctanos'**
  String get contactUs;

  /// No description provided for @sendMessage.
  ///
  /// In es, this message translates to:
  /// **'Enviar Mensaje'**
  String get sendMessage;

  /// No description provided for @typeMessage.
  ///
  /// In es, this message translates to:
  /// **'Escribe un mensaje...'**
  String get typeMessage;

  /// No description provided for @chatBot.
  ///
  /// In es, this message translates to:
  /// **'Bot de Chat'**
  String get chatBot;

  /// No description provided for @faq.
  ///
  /// In es, this message translates to:
  /// **'Preguntas Frecuentes'**
  String get faq;

  /// No description provided for @reports.
  ///
  /// In es, this message translates to:
  /// **'Reportes'**
  String get reports;

  /// No description provided for @analytics.
  ///
  /// In es, this message translates to:
  /// **'Análisis'**
  String get analytics;

  /// No description provided for @insights.
  ///
  /// In es, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @trends.
  ///
  /// In es, this message translates to:
  /// **'Tendencias'**
  String get trends;

  /// No description provided for @comparison.
  ///
  /// In es, this message translates to:
  /// **'Comparación'**
  String get comparison;

  /// No description provided for @forecast.
  ///
  /// In es, this message translates to:
  /// **'Pronóstico'**
  String get forecast;

  /// No description provided for @kpi.
  ///
  /// In es, this message translates to:
  /// **'Indicadores Clave'**
  String get kpi;

  /// No description provided for @metrics.
  ///
  /// In es, this message translates to:
  /// **'Métricas'**
  String get metrics;

  /// No description provided for @qrCode.
  ///
  /// In es, this message translates to:
  /// **'Código QR'**
  String get qrCode;

  /// No description provided for @barcode.
  ///
  /// In es, this message translates to:
  /// **'Código de Barras'**
  String get barcode;

  /// No description provided for @scanCode.
  ///
  /// In es, this message translates to:
  /// **'Escanear Código'**
  String get scanCode;

  /// No description provided for @generateQR.
  ///
  /// In es, this message translates to:
  /// **'Generar QR'**
  String get generateQR;

  /// No description provided for @invalidCode.
  ///
  /// In es, this message translates to:
  /// **'Código inválido'**
  String get invalidCode;

  /// No description provided for @codeScanned.
  ///
  /// In es, this message translates to:
  /// **'Código escaneado exitosamente'**
  String get codeScanned;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
