import 'package:flutter/material.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';
import 'package:rastreo_app/screens/sensors/device_selection_screen.dart';
import 'package:rastreo_app/widgets/language_switcher.dart';

// Importa las pantallas que se mostrarán en la barra de navegación.
// Revertimos a la pantalla de envíos anterior.
import 'package:rastreo_app/widgets/home_page_content.dart';
import 'package:rastreo_app/screens/shipments/shipments_screen.dart'; // <-- Pantalla original
import 'package:rastreo_app/widgets/modern_shipments_screen.dart'; // <-- Pantalla de envíos
import 'package:rastreo_app/widgets/advanced_history_screen.dart';
import 'package:rastreo_app/widgets/advanced_settings_screen.dart'; // Nueva importación
import 'package:rastreo_app/widgets/qr_scanner_screen.dart'; // Nueva importación

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Lista de las pantallas que se mostrarán en la navegación.
  final List<Widget> _pages = [
    const HomePageContent(),
    const ModernShipmentsScreen(),
    const AdvancedHistoryScreen(),
    const DeviceSelectionScreen(),
    const AdvancedSettingsScreen(), // Nueva pantalla de configuración
    const QRScannerScreen(),        // Nueva pantalla de QR Scanner
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Títulos para la AppBar, correspondientes a cada página.
    final List<String> titles = [
      localizations.home,
      localizations.shipments,
      localizations.history,
      localizations.sensors,
      localizations.settings, // Título para configuración
      localizations.qrScanner, // Título para QR Scanner
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        actions: const [
          LanguageSwitcher(),
          SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: localizations.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_shipping_outlined),
            activeIcon: const Icon(Icons.local_shipping),
            label: localizations.shipments,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history_outlined),
            activeIcon: const Icon(Icons.history),
            label: localizations.history,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.sensors_outlined),
            activeIcon: const Icon(Icons.sensors),
            label: localizations.sensors,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: localizations.settings, // Configuración
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            activeIcon: const Icon(Icons.qr_code_scanner),
            label: localizations.qrScanner, // QR Scanner
          ),
        ],
      ),
    );
  }
}

class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    // Replace this with actual localization logic if needed.
    return AppLocalizations();
  }

  String get home => 'Home';
  String get shipments => 'Shipments';
  String get history => 'History';
  String get sensors => 'Sensors';
  String get settings => 'Settings';
  String get qrScanner => 'QR Scanner'; // Added getter for QR Scanner
}
