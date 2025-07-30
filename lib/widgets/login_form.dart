import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';
import 'package:rastreo_app/providers/app_state_provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    final localizations = AppLocalizations.of(context)!;
    // Lógica de autenticación simple
    if (_userController.text == 'Admin' &&
        _passwordController.text == 'Admin') {
      // Navega a la pantalla de inicio reemplazando la pantalla de login
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Muestra un mensaje de error si las credenciales son incorrectas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.invalidCredentials),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Campo de texto para el usuario
          TextField(
            controller: _userController,
            decoration: InputDecoration(
              hintText: localizations.userHint,
              prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).colorScheme.primary),
            ),
            keyboardType: TextInputType.text,
          ).animate().fadeIn(delay: 300.ms).slideX(),

          const SizedBox(height: 16),

          // Campo de texto para la contraseña
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: localizations.passwordHint,
              prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.primary),
            ),
          ).animate().fadeIn(delay: 400.ms).slideX(),

          const SizedBox(height: 24),

          // Botón de Login
          ElevatedButton(
            onPressed: _login,
            child: Text(localizations.loginButton),
          ).animate().fadeIn(delay: 500.ms).scale(),

          const SizedBox(height: 20),

          // Selector de idioma
          _buildLanguageSelector(context),
        ],
      ),
    );
  }

  /// Widget para cambiar entre español e inglés.
  Widget _buildLanguageSelector(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final isSpanish = appState.appLocale.languageCode == 'es';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => appState.changeLocale(const Locale('es')),
            child: Text(
              'ES',
              style: TextStyle(
                fontWeight: isSpanish ? FontWeight.bold : FontWeight.normal,
                color: isSpanish ? Theme.of(context).colorScheme.secondary : Colors.white,
              ),
            ),
          ),
          const Text(' / ', style: TextStyle(color: Colors.white)),
          GestureDetector(
            onTap: () => appState.changeLocale(const Locale('en')),
            child: Text(
              'EN',
              style: TextStyle(
                fontWeight: !isSpanish ? FontWeight.bold : FontWeight.normal,
                color: !isSpanish ? Theme.of(context).colorScheme.secondary : Colors.white,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }
}
