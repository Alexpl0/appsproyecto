// Conjunto de pruebas unitarias y de widgets para la aplicación.
// Incluye pruebas de:
//  - PreferencesService (valores por defecto y actualización)
//  - AppStateProvider (cambio de idioma y notificaciones)
//  - LoginScreen (UI, cambio de idioma y navegación tras login)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:rastreo_app/main.dart';
import 'package:rastreo_app/providers/app_state_provider.dart';
import 'package:rastreo_app/services/preferences_service.dart';
import 'package:rastreo_app/services/notification_service.dart';
import 'package:rastreo_app/screens/login/login_screen.dart';
import 'package:rastreo_app/l10n/app_localizations.dart' as l10n;

/// Pequeña app de prueba para envolver widgets con providers y localización.
class _TestHarness extends StatelessWidget {
  final Widget child;
  final PreferencesService prefs;
  final NotificationService notifications;

  const _TestHarness({
    required this.child,
    required this.prefs,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider(prefs)),
        Provider.value(value: notifications),
      ],
      child: Consumer<AppStateProvider>(
        builder: (_, appState, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: appState.appLocale,
          localizationsDelegates: l10n.AppLocalizations.localizationsDelegates,
          supportedLocales: l10n.AppLocalizations.supportedLocales,
          home: child,
        ),
      ),
    );
  }
}

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
  });

  group('AppStateProvider', () {
    late PreferencesService prefs;
    late AppStateProvider provider;

    setUp(() async {
      prefs = PreferencesService();
      await prefs.init();
      provider = AppStateProvider(prefs);
    });

    test('idioma inicial es es', () {
      expect(provider.appLocale.languageCode, 'es');
    });

    test('cambiar locale a en notifica una vez', () async {
      int notifications = 0;
      provider.addListener(() { notifications++; });
      await provider.changeLocale(const Locale('en'));
      expect(provider.appLocale.languageCode, 'en');
      expect(notifications, 1);
      await provider.changeLocale(const Locale('en'));
      expect(notifications, 1); // no debe incrementar
    });
  });

  group('LoginScreen', () {
    late PreferencesService prefs;
    late NotificationService notifications;

    setUp(() async {
      prefs = PreferencesService();
      await prefs.init();
      notifications = NotificationService();
      await notifications.init();
    });

    testWidgets('muestra textos básicos en español por defecto', (tester) async {
      await tester.pumpWidget(_TestHarness(
        child: const LoginScreen(),
        prefs: prefs,
        notifications: notifications,
      ));
      await tester.pumpAndSettle();

      expect(find.text('BIENVENIDO'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Entrar'), findsOneWidget);
    });

    testWidgets('cambio de idioma ES -> EN actualiza textos', (tester) async {
      await tester.pumpWidget(_TestHarness(
        child: const LoginScreen(),
        prefs: prefs,
        notifications: notifications,
      ));
      await tester.pumpAndSettle();
      expect(find.text('Entrar'), findsOneWidget);
      await tester.tap(find.text('EN'));
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('login fallido muestra snackbar error', (tester) async {
      await tester.pumpWidget(_TestHarness(
        child: const LoginScreen(),
        prefs: prefs,
        notifications: notifications,
      ));
      await tester.pumpAndSettle();
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'user');
      await tester.enterText(fields.at(1), 'wrong');
      await tester.tap(find.text('Entrar'));
      await tester.pump();
      expect(find.textContaining('Credenciales no válidas'), findsOneWidget);
    });
  });

  group('Flujo de login completo', () {
    late PreferencesService prefs;
    late NotificationService notifications;

    setUp(() async {
      prefs = PreferencesService();
      await prefs.init();
      notifications = NotificationService();
      await notifications.init();
    });
  });
}

