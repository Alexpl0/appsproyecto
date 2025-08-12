import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rastreo_app/l10n/app_localizations.dart' as l10n;
import 'package:rastreo_app/providers/app_state_provider.dart';
import 'package:rastreo_app/services/preferences_service.dart';
import 'package:rastreo_app/services/notification_service.dart';

class TestApp extends StatelessWidget {
  final Widget child;
  final PreferencesService preferencesService;
  final NotificationService notificationService;

  const TestApp({
    super.key,
    required this.child,
    required this.preferencesService,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider(preferencesService)),
        Provider.value(value: notificationService),
      ],
      child: Consumer<AppStateProvider>(
        builder: (_, appState, __) => MaterialApp(
          locale: appState.appLocale,
          localizationsDelegates: l10n.AppLocalizations.localizationsDelegates,
          supportedLocales: l10n.AppLocalizations.supportedLocales,
          home: child,
        ),
      ),
    );
  }
}
