import 'package:flutter/material.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';

/// Pantalla para mostrar la lista de envíos.
class ShipmentsScreen extends StatelessWidget {
  const ShipmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // El contenido de esta pantalla se construirá más adelante.
    return Scaffold(
      body: Center(
        child: Text(
          localizations.shipments,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
