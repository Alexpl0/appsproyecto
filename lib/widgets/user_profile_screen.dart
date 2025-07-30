import 'package:flutter/material.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';
import 'package:rastreo_app/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:rastreo_app/providers/app_state_provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = true;
  bool _darkMode = false;
  final String _selectedLanguage = 'es';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appState = Provider.of<AppStateProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar con gradiente
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primaryDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryGradient,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localizations.admin,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'admin@rastreoapp.com',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Contenido del perfil
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              
              // Estadísticas del usuario
              _buildUserStats(localizations, theme),
              
              const SizedBox(height: 24),
              
              // Configuración de cuenta
              _buildAccountSection(localizations, theme),
              
              const SizedBox(height: 24),
              
              // Configuración de notificaciones
              _buildNotificationsSection(localizations, theme),
              
              const SizedBox(height: 24),
              
              // Configuración de apariencia
              _buildAppearanceSection(localizations, theme, appState),
              
              const SizedBox(height: 24),
              
              // Configuración avanzada
              _buildAdvancedSection(localizations, theme),
              
              const SizedBox(height: 24),
              
              // Sobre la app
              _buildAboutSection(localizations, theme),
              
              const SizedBox(height: 32),
              
              // Botón de cerrar sesión
              _buildLogoutButton(localizations),
              
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStats(AppLocalizations localizations, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mi Actividad',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.local_shipping,
                  label: 'Envíos Gestionados',
                  value: '247',
                  color: AppTheme.info,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.access_time,
                  label: 'Tiempo Activo',
                  value: '45d',
                  color: AppTheme.success,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.star,
                  label: 'Calificación',
                  value: '4.8',
                  color: AppTheme.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryDark,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAccountSection(AppLocalizations localizations, ThemeData theme) {
    return _buildSection(
      title: localizations.account,
      children: [
        _buildSettingsTile(
          icon: Icons.person_outline,
          title: 'Información Personal',
          subtitle: 'Editar nombre, email y teléfono',
          onTap: () => _showEditProfileModal(context),
        ),
        _buildSettingsTile(
          icon: Icons.security,
          title: localizations.security,
          subtitle: 'Cambiar contraseña y configurar 2FA',
          onTap: () => _showSecurityModal(context),
        ),
        _buildSettingsTile(
          icon: Icons.business,
          title: 'Información de Empresa',
          subtitle: 'Datos fiscales y de facturación',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(AppLocalizations localizations, ThemeData theme) {
    return _buildSection(
      title: localizations.notifications,
      children: [
        _buildSwitchTile(
          icon: Icons.notifications,
          title: localizations.pushNotifications,
          subtitle: 'Recibir notificaciones en tiempo real',
          value: _pushNotifications,
          onChanged: (value) {
            setState(() {
              _pushNotifications = value;
            });
          },
        ),
        _buildSwitchTile(
          icon: Icons.email,
          title: localizations.emailNotifications,
          subtitle: 'Recibir resúmenes por email',
          value: _emailNotifications,
          onChanged: (value) {
            setState(() {
              _emailNotifications = value;
            });
          },
        ),
        _buildSwitchTile(
          icon: Icons.sms,
          title: localizations.smsNotifications,
          subtitle: 'Alertas urgentes por SMS',
          value: _smsNotifications,
          onChanged: (value) {
            setState(() {
              _smsNotifications = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(AppLocalizations localizations, ThemeData theme, AppStateProvider appState) {
    return _buildSection(
      title: 'Apariencia',
      children: [
        _buildSwitchTile(
          icon: Icons.dark_mode,
          title: localizations.darkMode,
          subtitle: 'Usar tema oscuro',
          value: _darkMode,
          onChanged: (value) {
            setState(() {
              _darkMode = value;
            });
            // TODO: Implementar cambio de tema
          },
        ),
        _buildDropdownTile(
          icon: Icons.language,
          title: localizations.language,
          subtitle: 'Cambiar idioma de la aplicación',
          value: appState.appLocale.languageCode,
          items: [
            {'value': 'es', 'label': localizations.spanish},
            {'value': 'en', 'label': localizations.english},
          ],
          onChanged: (value) {
            appState.changeLocale(Locale(value!));
          },
        ),
        _buildSettingsTile(
          icon: Icons.palette,
          title: 'Personalización',
          subtitle: 'Colores y diseño de la interfaz',
          onTap: () => _showThemeModal(context),
        ),
      ],
    );
  }

  Widget _buildAdvancedSection(AppLocalizations localizations, ThemeData theme) {
    return _buildSection(
      title: 'Configuración Avanzada',
      children: [
        _buildSettingsTile(
          icon: Icons.backup,
          title: 'Respaldo de Datos',
          subtitle: 'Configurar copias de seguridad automáticas',
          onTap: () => _showBackupModal(context),
        ),
        _buildSettingsTile(
          icon: Icons.sync,
          title: 'Sincronización',
          subtitle: 'Configurar sincronización con otros dispositivos',
          onTap: () {},
        ),
        _buildSettingsTile(
          icon: Icons.storage,
          title: 'Gestión de Datos',
          subtitle: 'Ver uso de almacenamiento y limpiar cache',
          onTap: () => _showStorageModal(context),
        ),
        _buildSettingsTile(
          icon: Icons.developer_mode,
          title: 'Opciones de Desarrollador',
          subtitle: 'Configuraciones avanzadas y debug',
          onTap: () => _showDeveloperModal(context),
        ),
      ],
    );
  }

  Widget _buildAboutSection(AppLocalizations localizations, ThemeData theme) {
    return _buildSection(
      title: localizations.about,
      children: [
        _buildSettingsTile(
          icon: Icons.info,
          title: 'Información de la App',
          subtitle: 'Versión 1.0.0 (Build 1)',
          onTap: () => _showAboutModal(context),
        ),
        _buildSettingsTile(
          icon: Icons.help,
          title: localizations.helpCenter,
          subtitle: 'Preguntas frecuentes y soporte',
          onTap: () {},
        ),
        _buildSettingsTile(
          icon: Icons.privacy_tip,
          title: localizations.privacy,
          subtitle: 'Política de privacidad',
          onTap: () {},
        ),
        _buildSettingsTile(
          icon: Icons.gavel,
          title: 'Términos de Servicio',
          subtitle: 'Condiciones de uso',
          onTap: () {},
        ),
        _buildSettingsTile(
          icon: Icons.rate_review,
          title: 'Calificar App',
          subtitle: 'Ayúdanos con tu opinión',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryDark,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryMedium.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryMedium, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryDark,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryMedium.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryMedium, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryDark,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryMedium,
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<Map<String, String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryMedium.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryMedium, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryDark,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item['value'],
            child: Text(item['label']!),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildLogoutButton(AppLocalizations localizations) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(context, localizations),
        icon: const Icon(Icons.logout),
        label: Text(localizations.logout),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.error,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showEditProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Editar Perfil',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 24),
              
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Nombre completo',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Perfil actualizado'),
                        backgroundColor: AppTheme.success,
                      ),
                    );
                  },
                  child: const Text('Guardar Cambios'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSecurityModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Configuración de Seguridad'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.lock, color: AppTheme.primaryMedium),
              title: Text('Cambiar Contraseña'),
              subtitle: Text('Última actualización: hace 30 días'),
            ),
            ListTile(
              leading: Icon(Icons.security, color: AppTheme.success),
              title: Text('Autenticación en 2 Pasos'),
              subtitle: Text('Configurar 2FA para mayor seguridad'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showThemeModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Personalización'),
        content: const Text('Próximamente: Personaliza los colores y el diseño de tu aplicación.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showBackupModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Respaldo de Datos'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Configuración actual:'),
            SizedBox(height: 8),
            Text('• Respaldo automático: Activado'),
            Text('• Frecuencia: Diario'),
            Text('• Último respaldo: Hace 2 horas'),
            Text('• Ubicación: Google Drive'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Configurar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showStorageModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Gestión de Almacenamiento'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Uso de almacenamiento:'),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.3,
              backgroundColor: AppTheme.surface,
              valueColor: AlwaysStoppedAnimation(AppTheme.primaryMedium),
            ),
            SizedBox(height: 8),
            Text('2.3 GB de 8 GB utilizados'),
            SizedBox(height: 16),
            Text('• Datos de envíos: 1.8 GB'),
            Text('• Cache de imágenes: 350 MB'),
            Text('• Configuración: 150 MB'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache limpiado'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            child: const Text('Limpiar Cache'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showDeveloperModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Opciones de Desarrollador'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.bug_report, color: AppTheme.warning),
              title: Text('Modo Debug'),
              subtitle: Text('Activar logs detallados'),
            ),
            ListTile(
              leading: Icon(Icons.network_check, color: AppTheme.info),
              title: Text('Monitor de Red'),
              subtitle: Text('Ver solicitudes HTTP'),
            ),
            ListTile(
              leading: Icon(Icons.memory, color: AppTheme.error),
              title: Text('Monitor de Memoria'),
              subtitle: Text('Ver uso de recursos'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showAboutModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.local_shipping, color: AppTheme.primaryMedium),
            SizedBox(width: 8),
            Text('Rastreo App'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Versión: 1.0.0 (Build 1)'),
            Text('Desarrollado por: Equipo DevApp'),
            SizedBox(height: 16),
            Text('Una aplicación moderna para el rastreo y monitoreo de envíos con tecnología IoT.'),
            SizedBox(height: 16),
            Text('© 2024 Rastreo App. Todos los derechos reservados.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(localizations.logout),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: Text(localizations.logout),
          ),
        ],
      ),
    );
  }
}