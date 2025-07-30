import 'package:flutter/material.dart';
import 'package:rastreo_app/widgets/modern_dashboard.dart';

/// Widget que muestra el contenido principal de la pantalla de inicio.
/// Ahora utiliza el ModernDashboard para una experiencia más rica.
class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Simplemente retorna el ModernDashboard que contiene toda la funcionalidad
    return const ModernDashboard();
  }
}