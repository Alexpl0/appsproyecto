import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';
import 'package:rastreo_app/providers/app_state_provider.dart';

/// Un widget que muestra un menú para seleccionar el idioma de la app.
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return PopupMenuButton<Locale>(
      onSelected: (Locale locale) {
        Provider.of<AppStateProvider>(context, listen: false).changeLocale(locale);
      },
      icon: const Icon(Icons.language, color: Colors.white),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        PopupMenuItem<Locale>(
          value: const Locale('es'),
          child: Text(localizations.spanish),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('en'),
          child: Text(localizations.english),
        ),
      ],
    );
  }
}
