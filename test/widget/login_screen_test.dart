import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rastreo_app/screens/login/login_screen.dart';
import 'package:rastreo_app/services/preferences_service.dart';
import 'package:rastreo_app/services/notification_service.dart';
import '../helpers/test_app.dart';

void main() {
  group('LoginScreen UI', () {
    late PreferencesService prefs;
    late NotificationService notifications;

    setUp(() async {
      prefs = PreferencesService();
      await prefs.init();
      notifications = NotificationService();
      await notifications.init();
    });

    testWidgets('muestra textos básicos en español por defecto', (tester) async {
      await tester.pumpWidget(TestApp(
        child: const LoginScreen(),
        preferencesService: prefs,
        notificationService: notifications,
      ));
      await tester.pumpAndSettle();

      expect(find.text('BIENVENIDO'), findsOneWidget); // welcomeMessage ES
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Entrar'), findsOneWidget); // loginButton ES
    });

    testWidgets('cambio de idioma ES -> EN actualiza textos', (tester) async {
      await tester.pumpWidget(TestApp(
        child: const LoginScreen(),
        preferencesService: prefs,
        notificationService: notifications,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Entrar'), findsOneWidget);
      await tester.tap(find.text('EN'));
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('login fallido muestra snackbar de error', (tester) async {
      await tester.pumpWidget(TestApp(
        child: const LoginScreen(),
        preferencesService: prefs,
        notificationService: notifications,
      ));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'User');
      await tester.enterText(fields.at(1), 'Wrong');
      await tester.tap(find.text('Entrar'));
      await tester.pump();

      expect(find.textContaining('Credenciales no válidas'), findsOneWidget);
    });
  });
}
