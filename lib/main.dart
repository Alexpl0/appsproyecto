import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Importaciones locales
import 'package:rastreo_app/l10n/app_localizations.dart' as l10n;
import 'package:rastreo_app/screens/home/home_screen.dart';

import 'theme/app_theme.dart';
import 'providers/app_state_provider.dart';
import 'services/preferences_service.dart';
import 'services/notification_service.dart';

// Pantallas principales
import 'screens/login/login_screen.dart';

// Pantallas adicionales
import 'widgets/user_profile_screen.dart';
import 'widgets/qr_scanner_screen.dart';
import 'widgets/interactive_map_widget.dart';
import 'widgets/support_chat_screen.dart';
import 'widgets/notifications_center_screen.dart';
import 'widgets/advanced_settings_screen.dart';
import 'widgets/modern_shipments_screen.dart';
import 'widgets/advanced_sensors_screen.dart';
import 'widgets/advanced_history_screen.dart';
import 'widgets/home_page_content.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar orientación preferida
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Configurar barra de estado
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Inicializar servicios
  final preferencesService = PreferencesService();
  await preferencesService.init();
  
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(RastreoApp(
    preferencesService: preferencesService,
    notificationService: notificationService,
  ));
}

class RastreoApp extends StatelessWidget {
  final PreferencesService preferencesService;
  final NotificationService notificationService;

  const RastreoApp({
    super.key,
    required this.preferencesService,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppStateProvider(preferencesService),
        ),
        Provider.value(value: notificationService),
      ],
      child: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'Rastreo App',
            debugShowCheckedModeBanner: false,
            
            // Configuración de localización
            locale: appState.appLocale,
            localizationsDelegates: l10n.AppLocalizations.localizationsDelegates,
            supportedLocales: l10n.AppLocalizations.supportedLocales,
            
            // Tema de la aplicación
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            
            // Configuración de rutas
            initialRoute: '/login',
            onGenerateRoute: _generateRoute,
            
            // Página de error 404
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const NotFoundScreen(),
              );
            },
          );
        },
      ),
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    // Extraer argumentos si existen
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case '/login':
        return _createRoute(const LoginScreen());
        
      case '/home':
        return _createRoute(const HomeScreen());
        
      case '/profile':
        return _createRoute(const UserProfileScreen());
        
      case '/qr-scanner':
        return _createRoute(const QRScannerScreen());
        
      case '/map':
        return _createRoute(InteractiveMapWidget(
          shipmentId: args?['shipmentId'],
          showAllShipments: args?['showAllShipments'] ?? false,
        ));
        
      case '/support-chat':
        return _createRoute(const SupportChatScreen());
        
      case '/notifications':
        return _createRoute(const NotificationsCenterScreen());
        
      case '/settings':
        return _createRoute(const AdvancedSettingsScreen());
        
      case '/shipments':
        return _createRoute(const ModernShipmentsScreen());
        
      case '/sensors':
        return _createRoute(const AdvancedSensorsScreen());
        
      case '/history':
        return _createRoute(const AdvancedHistoryScreen());
        
      case '/shipment-details':
        return _createRoute(ShipmentDetailsScreen(
          shipmentId: args?['shipmentId'] ?? 'SH001',
        ));
        
      case '/sensor-details':
        return _createRoute(SensorDetailsScreen(
          sensorId: args?['sensorId'] ?? 'SEN001',
        ));
        
      case '/search':
        return _createRoute(const GlobalSearchScreen());
        
      default:
        return null;
    }
  }

  PageRoute _createRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

// Pantalla de error 404
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página no encontrada'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              '404',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              icon: const Icon(Icons.home),
              label: const Text('Ir al inicio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryMedium,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantallas de detalles adicionales
class ShipmentDetailsScreen extends StatelessWidget {
  final String shipmentId;

  const ShipmentDetailsScreen({
    super.key,
    required this.shipmentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Envío $shipmentId'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Compartiendo detalles del envío')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/map',
                arguments: {'shipmentId': shipmentId},
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información del Envío',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('ID del Envío', shipmentId),
                    _buildDetailRow('Producto', 'Vino Tinto Reserva'),
                    _buildDetailRow('Destinatario', 'Juan Pérez'),
                    _buildDetailRow('Estado', 'En tránsito'),
                    _buildDetailRow('Origen', 'Guadalajara, JAL'),
                    _buildDetailRow('Destino', 'Ciudad de México, CDMX'),
                    _buildDetailRow('Fecha de envío', '27 Enero 2024'),
                    _buildDetailRow('Entrega estimada', '29 Enero 2024'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Timeline de Eventos',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTimelineItem(
                      'Paquete entregado',
                      '29 Enero 2024 - 14:30',
                      Icons.check_circle,
                      AppTheme.success,
                      isLast: true,
                    ),
                    _buildTimelineItem(
                      'En reparto',
                      '29 Enero 2024 - 09:00',
                      Icons.local_shipping,
                      AppTheme.info,
                    ),
                    _buildTimelineItem(
                      'Llegó a centro de distribución',
                      '28 Enero 2024 - 18:45',
                      Icons.warehouse,
                      AppTheme.warning,
                    ),
                    _buildTimelineItem(
                      'En tránsito',
                      '27 Enero 2024 - 16:20',
                      Icons.route,
                      AppTheme.accent,
                    ),
                    _buildTimelineItem(
                      'Paquete recogido',
                      '27 Enero 2024 - 10:00',
                      Icons.inventory,
                      AppTheme.primaryMedium,
                      isLast: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/support-chat');
        },
        icon: const Icon(Icons.chat),
        label: const Text('Contactar Soporte'),
        backgroundColor: AppTheme.primaryMedium,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String time,
    IconData icon,
    Color color, {
    bool isLast = false,
  }) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryDark,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              if (!isLast) const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class SensorDetailsScreen extends StatelessWidget {
  final String sensorId;

  const SensorDetailsScreen({
    super.key,
    required this.sensorId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor $sensorId'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Abriendo configuración del sensor')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado del Sensor',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.sensors,
                            color: AppTheme.success,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Conectado',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.success,
                                ),
                              ),
                              Text(
                                'Última lectura: Hace 2 minutos',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lecturas Actuales',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildSensorReading('Temperatura', '18.5°C', Icons.thermostat, AppTheme.error),
                        _buildSensorReading('Humedad', '65.2%', Icons.water_drop, AppTheme.info),
                        _buildSensorReading('Presión', '1013.2 hPa', Icons.compress, AppTheme.warning),
                        _buildSensorReading('Batería', '87%', Icons.battery_std, AppTheme.success),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorReading(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Buscar envíos, sensores, clientes...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _query = '';
              });
            },
          ),
        ],
      ),
      body: _query.isEmpty ? _buildSearchSuggestions() : _buildSearchResults(),
    );
  }

  Widget _buildSearchSuggestions() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Búsquedas recientes',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryDark,
          ),
        ),
        const SizedBox(height: 16),
        _buildSuggestionItem('SH001', 'Vino Tinto Reserva', Icons.local_shipping),
        _buildSuggestionItem('SEN003', 'Sensor Multi', Icons.sensors),
        _buildSuggestionItem('Juan Pérez', 'Cliente', Icons.person),
        
        const SizedBox(height: 24),
        
        Text(
          'Búsquedas populares',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryDark,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPopularChip('Envíos retrasados'),
            _buildPopularChip('Sensores desconectados'),
            _buildPopularChip('Entregas de hoy'),
            _buildPopularChip('Productos frágiles'),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Resultados para "$_query"',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryDark,
          ),
        ),
        const SizedBox(height: 16),
        
        if (_query.toLowerCase().contains('sh') || _query.toLowerCase().contains('envio'))
          ...[
            _buildResultSection('Envíos', [
              _buildResultItem('SH001', 'Vino Tinto Reserva - En tránsito', Icons.local_shipping, AppTheme.info),
              _buildResultItem('SH002', 'Tequila Premium - Entregado', Icons.local_shipping, AppTheme.success),
            ]),
          ],
        
        if (_query.toLowerCase().contains('sen') || _query.toLowerCase().contains('sensor'))
          ...[
            _buildResultSection('Sensores', [
              _buildResultItem('SEN001', 'Sensor Multi - Conectado', Icons.sensors, AppTheme.success),
              _buildResultItem('SEN003', 'Sensor Temp - Alerta', Icons.sensors, AppTheme.warning),
            ]),
          ],
        
        if (_query.toLowerCase().contains('juan') || _query.toLowerCase().contains('cliente'))
          ...[
            _buildResultSection('Clientes', [
              _buildResultItem('Juan Pérez', 'juan.perez@email.com', Icons.person, AppTheme.accent),
            ]),
          ],
      ],
    );
  }

  Widget _buildSuggestionItem(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryMedium),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {
        _searchController.text = title;
        setState(() {
          _query = title;
        });
      },
    );
  }

  Widget _buildPopularChip(String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        _searchController.text = label;
        setState(() {
          _query = label;
        });
      },
      backgroundColor: AppTheme.surface.withOpacity(0.5),
    );
  }

  Widget _buildResultSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryDark,
          ),
        ),
        const SizedBox(height: 8),
        ...items,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildResultItem(String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navegar a detalles según el tipo
          if (title.startsWith('SH')) {
            Navigator.pushNamed(
              context,
              '/shipment-details',
              arguments: {'shipmentId': title},
            );
          } else if (title.startsWith('SEN')) {
            Navigator.pushNamed(
              context,
              '/sensor-details',
              arguments: {'sensorId': title},
            );
          }
        },
      ),
    );
  }
}

final List<Widget> _pages = [
  const HomePageContent(),
  const ModernShipmentsScreen(),
  const AdvancedHistoryScreen(),
  const AdvancedSensorsScreen(),
  const AdvancedSettingsScreen(), // Configuración
  const QRScannerScreen(),        // QR Scanner
];

final List<BottomNavigationBarItem> _items = [
  const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
  const BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: 'Envíos'),
  const BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
  const BottomNavigationBarItem(icon: Icon(Icons.sensors), label: 'Sensores'),
  const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configuración'),
  const BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'QR Scanner'),
];