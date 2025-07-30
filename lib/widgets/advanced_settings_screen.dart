import 'package:flutter/material.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';
import 'package:rastreo_app/theme/app_theme.dart';

class AdvancedSettingsScreen extends StatefulWidget {
  const AdvancedSettingsScreen({super.key});

  @override
  State<AdvancedSettingsScreen> createState() => _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState extends State<AdvancedSettingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Estados de configuración
  bool _autoBackup = true;
  bool _cloudSync = false;
  bool _analyticsEnabled = true;
  bool _crashReporting = true;
  bool _betaFeatures = false;
  bool _developerMode = false;
  
  // Configuraciones de red
  String _apiEndpoint = 'https://api.rastreoapp.com';
  int _requestTimeout = 30;
  bool _useWifiOnly = false;
  bool _lowDataMode = false;
  
  // Configuraciones de sensores
  int _sensorUpdateInterval = 5;
  bool _sensorAutoReconnect = true;
  double _temperatureThreshold = 25.0;
  double _humidityThreshold = 70.0;
  
  // Configuraciones de almacenamiento
  int _cacheSize = 100;
  int _logRetentionDays = 30;
  bool _compressLogs = true;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'General', icon: Icon(Icons.settings, size: 20)),
            Tab(text: 'Red', icon: Icon(Icons.wifi, size: 20)),
            Tab(text: 'Sensores', icon: Icon(Icons.sensors, size: 20)),
            Tab(text: 'Datos', icon: Icon(Icons.storage, size: 20)),
            Tab(text: 'Avanzado', icon: Icon(Icons.code, size: 20)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGeneralSettings(localizations, theme),
          _buildNetworkSettings(localizations, theme),
          _buildSensorSettings(localizations, theme),
          _buildDataSettings(localizations, theme),
          _buildAdvancedSettings(localizations, theme),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings(AppLocalizations localizations, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Configuración General', Icons.settings),
          _buildSettingsCard([
            _buildSwitchSetting(
              'Respaldo Automático',
              'Respaldar datos automáticamente cada día',
              _autoBackup,
              (value) => setState(() => _autoBackup = value),
              Icons.backup,
            ),
            _buildSwitchSetting(
              'Sincronización en la Nube',
              'Sincronizar configuración entre dispositivos',
              _cloudSync,
              (value) => setState(() => _cloudSync = value),
              Icons.cloud_sync,
            ),
            _buildDropdownSetting(
              'Frecuencia de Respaldo',
              'Cada 24 horas',
              Icons.schedule,
              ['Cada hora', 'Cada 6 horas', 'Cada 12 horas', 'Cada 24 horas', 'Manual'],
              'Cada 24 horas',
              (value) {},
            ),
          ]),
          
          const SizedBox(height: 24),
          
          _buildSectionHeader('Privacidad y Analíticas', Icons.privacy_tip),
          _buildSettingsCard([
            _buildSwitchSetting(
              'Analíticas de Uso',
              'Ayúdanos a mejorar la app compartiendo datos de uso',
              _analyticsEnabled,
              (value) => setState(() => _analyticsEnabled = value),
              Icons.analytics,
            ),
            _buildSwitchSetting(
              'Reportes de Errores',
              'Enviar reportes automáticos de errores',
              _crashReporting,
              (value) => setState(() => _crashReporting = value),
              Icons.bug_report,
            ),
            _buildActionSetting(
              'Limpiar Datos de Analíticas',
              'Eliminar todos los datos de uso guardados',
              Icons.delete_forever,
              () => _showClearAnalyticsDialog(),
            ),
          ]),
          
          const SizedBox(height: 24),
          
          _buildSectionHeader('Funciones Experimentales', Icons.science),
          _buildSettingsCard([
            _buildSwitchSetting(
              'Funciones Beta',
              'Acceder a características experimentales',
              _betaFeatures,
              (value) => setState(() => _betaFeatures = value),
              Icons.new_releases,
            ),
            if (_betaFeatures) ...[
              _buildActionSetting(
                'IA Predictiva (Beta)',
                'Predicción inteligente de entregas',
                Icons.psychology,
                () => _showBetaFeatureDialog('IA Predictiva'),
              ),
              _buildActionSetting(
                'Realidad Aumentada (Beta)',
                'Visualización AR de rutas',
                Icons.view_in_ar,
                () => _showBetaFeatureDialog('Realidad Aumentada'),
              ),
            ],
          ]),
        ],
      ),
    );
  }

  Widget _buildNetworkSettings(AppLocalizations localizations, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Configuración de Red', Icons.wifi),
          _buildSettingsCard([
            _buildTextFieldSetting(
              'Endpoint de API',
              'URL del servidor de la aplicación',
              _apiEndpoint,
              (value) => setState(() => _apiEndpoint = value),
              Icons.link,
            ),
            _buildSliderSetting(
              'Timeout de Solicitudes',
              'Tiempo límite para solicitudes de red',
              _requestTimeout.toDouble(),
              5,
              120,
              'segundos',
              (value) => setState(() => _requestTimeout = value.round()),
              Icons.timer,
            ),
            _buildSwitchSetting(
              'Solo WiFi',
              'Usar solo conexión WiFi para sincronización',
              _useWifiOnly,
              (value) => setState(() => _useWifiOnly = value),
              Icons.wifi,
            ),
            _buildSwitchSetting(
              'Modo de Datos Reducidos',
              'Minimizar el uso de datos móviles',
              _lowDataMode,
              (value) => setState(() => _lowDataMode = value),
              Icons.data_usage,
            ),
          ]),
          
          const SizedBox(height: 24),
          
          _buildSectionHeader('Diagnóstico de Red', Icons.network_check),
          _buildSettingsCard([
            _buildActionSetting(
              'Probar Conexión',
              'Verificar conectividad con el servidor',
              Icons.speed,
              () => _testNetworkConnection(),
            ),
            _buildActionSetting(
              'Ver Estadísticas de Red',
              'Revisar uso de datos y velocidad',
              Icons.bar_chart,
              () => _showNetworkStats(),
            ),
            _buildActionSetting(
              'Limpiar Cache de Red',
              'Eliminar datos en cache de solicitudes',
              Icons.cached,
              () => _clearNetworkCache(),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSensorSettings(AppLocalizations localizations, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Configuración de Sensores', Icons.sensors),
          _buildSettingsCard([
            _buildSliderSetting(
              'Intervalo de Actualización',
              'Frecuencia de lectura de sensores',
              _sensorUpdateInterval.toDouble(),
              1,
              60,
              'segundos',
              (value) => setState(() => _sensorUpdateInterval = value.round()),
              Icons.refresh,
            ),
            _buildSwitchSetting(
              'Reconexión Automática',
              'Intentar reconectar sensores desconectados',
              _sensorAutoReconnect,
              (value) => setState(() => _sensorAutoReconnect = value),
              Icons.autorenew,
            ),
          ]),
          
          const SizedBox(height: 24),
          
          _buildSectionHeader('Umbrales de Alerta', Icons.warning),
          _buildSettingsCard([
            _buildSliderSetting(
              'Temperatura Máxima',
              'Umbral de alerta para temperatura',
              _temperatureThreshold,
              0,
              50,
              '°C',
              (value) => setState(() => _temperatureThreshold = value),
              Icons.thermostat,
            ),
            _buildSliderSetting(
              'Humedad Máxima',
              'Umbral de alerta para humedad',
              _humidityThreshold,
              0,
              100,
              '%',
              (value) => setState(() => _humidityThreshold = value),
              Icons.water_drop,
            ),
            _buildActionSetting(
              'Configurar Alertas Personalizadas',
              'Crear alertas específicas por producto',
              Icons.tune,
              () => _showCustomAlertsDialog(),
            ),
          ]),
          
          const SizedBox(height: 24),
          
          _buildSectionHeader('Calibración', Icons.tune),
          _buildSettingsCard([
            _buildActionSetting(
              'Calibrar Sensores de Temperatura',
              'Ajustar precisión de lecturas de temperatura',
              Icons.device_thermostat,
              () => _showCalibrationDialog('temperatura'),
            ),
            _buildActionSetting(
              'Calibrar Sensores de Humedad',
              'Ajustar precisión de lecturas de humedad',
              Icons.opacity,
              () => _showCalibrationDialog('humedad'),
            ),
            _buildActionSetting(
              'Restablecer Calibración',
              'Volver a valores de fábrica',
              Icons.restore,
              () => _showResetCalibrationDialog(),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildDataSettings(AppLocalizations localizations, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Gestión de Almacenamiento', Icons.storage),
          _buildSettingsCard([
            _buildSliderSetting(
              'Tamaño de Cache',
              'Espacio reservado para datos temporales',
              _cacheSize.toDouble(),
              50,
              500,
              'MB',
              (value) => setState(() => _cacheSize = value.round()),
              Icons.folder,
            ),
            _buildSliderSetting(
              'Retención de Logs',
              'Días para conservar registros de actividad',
              _logRetentionDays.toDouble(),
              7,
              90,
              'días',
              (value) => setState(() => _logRetentionDays = value.round()),
              Icons.description,
            ),
            _buildSwitchSetting(
              'Comprimir Logs',
              'Reducir espacio usado por registros',
              _compressLogs,
              (value) => setState(() => _compressLogs = value),
              Icons.compress,
            ),
          ]),
          
          const SizedBox(height: 24),
          
          _buildSectionHeader('Uso de Almacenamiento', Icons.pie_chart),
          _buildUsageCard(),
          
          const SizedBox(height: 24),
          
          _buildSectionHeader('Mantenimiento de Datos', Icons.build),
          _buildSettingsCard([
            _buildActionSetting(
              'Limpiar Cache',
              'Liberar espacio eliminando archivos temporales',
              Icons.cleaning_services,
              () => _clearCache(),
            ),
            _buildActionSetting(
              'Optimizar Base de Datos',
              'Mejorar rendimiento de la base de datos',
              Icons.speed,
              () => _optimizeDatabase(),
            ),
            _buildActionSetting(
              'Exportar Datos',
              'Crear respaldo completo de todos los datos',
              Icons.download,
              () => _exportData(),
            ),
            _buildActionSetting(
              'Importar Datos',
              'Restaurar desde un archivo de respaldo',
              Icons.upload,
              () => _importData(),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings(AppLocalizations localizations, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Opciones de Desarrollador', Icons.code),
          _buildSettingsCard([
            _buildSwitchSetting(
              'Modo Desarrollador',
              'Habilitar opciones avanzadas de desarrollo',
              _developerMode,
              (value) => setState(() => _developerMode = value),
              Icons.developer_mode,
            ),
            if (_developerMode) ...[
              _buildSwitchSetting(
                'Debug Verbose',
                'Mostrar información detallada de depuración',
                false,
                (value) {},
                Icons.bug_report,
              ),
              _buildSwitchSetting(
                'Mock de Sensores',
                'Usar datos simulados para sensores',
                false,
                (value) {},
                Icons.science,
              ),
              _buildActionSetting(
                'Ver Logs de Sistema',
                'Revisar registros técnicos detallados',
                Icons.list_alt,
                () => _showSystemLogs(),
              ),
              _buildActionSetting(
                'Ejecutar Diagnóstico',
                'Verificar estado de todos los componentes',
                Icons.health_and_safety,
                () => _runDiagnostic(),
              ),
            ],
          ]),
          
          const SizedBox(height: 24),
          
          _buildSectionHeader('Información del Sistema', Icons.info),
          _buildInfoCard(),
          
          const SizedBox(height: 24),
          
          _buildSectionHeader('Acciones Peligrosas', Icons.warning),
          _buildDangerCard(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryMedium, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
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

  Widget _buildSliderSetting(
    String title,
    String subtitle,
    double value,
    double min,
    double max,
    String unit,
    ValueChanged<double> onChanged,
    IconData icon,
  ) {
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
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  onChanged: onChanged,
                  activeColor: AppTheme.primaryMedium,
                ),
              ),
              Container(
                width: 60,
                alignment: Alignment.centerRight,
                child: Text(
                  '${value.round()} $unit',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryDark,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    String title,
    String subtitle,
    IconData icon,
    List<String> options,
    String currentValue,
    ValueChanged<String> onChanged,
  ) {
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
        value: currentValue,
        underline: const SizedBox(),
        items: options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (value) => onChanged(value!),
      ),
    );
  }

  Widget _buildTextFieldSetting(
    String title,
    String subtitle,
    String value,
    ValueChanged<String> onChanged,
    IconData icon,
  ) {
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
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: value),
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActionSetting(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
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
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildUsageCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildUsageItem('Datos de envíos', '2.3 GB', 0.6, AppTheme.info),
          _buildUsageItem('Cache de imágenes', '350 MB', 0.3, AppTheme.warning),
          _buildUsageItem('Logs del sistema', '150 MB', 0.1, AppTheme.success),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total utilizado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
              Text(
                '2.8 GB de 8 GB',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsageItem(String label, String size, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(
                size,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        children: [
          _InfoRow('Versión de la App', '1.0.0 (Build 1)'),
          _InfoRow('Versión de Flutter', '3.16.0'),
          _InfoRow('Plataforma', 'Android 13'),
          _InfoRow('Memoria RAM', '6 GB'),
          _InfoRow('Almacenamiento libre', '32 GB'),
          _InfoRow('ID del dispositivo', 'RAS-2024-001'),
        ],
      ),
    );
  }

  Widget _buildDangerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.error.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.error.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDangerAction(
            'Restablecer Configuración',
            'Volver a configuración de fábrica',
            Icons.restore,
            () => _showResetSettingsDialog(),
          ),
          _buildDangerAction(
            'Eliminar Todos los Datos',
            'Borrar completamente toda la información',
            Icons.delete_forever,
            () => _showDeleteAllDataDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerAction(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.error, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppTheme.error,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // Métodos de acción
  void _showClearAnalyticsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Limpiar Datos de Analíticas'),
        content: const Text('¿Estás seguro de que quieres eliminar todos los datos de analíticas? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Datos de analíticas eliminados');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showBetaFeatureDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('$feature (Beta)'),
        content: Text('La función de $feature está en fase beta. Puede contener errores o comportamientos inesperados.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('$feature activado');
            },
            child: const Text('Activar'),
          ),
        ],
      ),
    );
  }

  void _testNetworkConnection() async {
    _showLoadingDialog('Probando conexión...');
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);
    _showSuccessMessage('Conexión exitosa - 45ms de latencia');
  }

  void _showNetworkStats() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Estadísticas de Red'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Datos descargados: 245 MB'),
            Text('Datos subidos: 89 MB'),
            Text('Velocidad promedio: 15.2 Mbps'),
            Text('Latencia promedio: 45ms'),
            Text('Solicitudes exitosas: 1,234'),
            Text('Errores de red: 3'),
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

  void _clearNetworkCache() async {
    _showLoadingDialog('Limpiando cache...');
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);
    _showSuccessMessage('Cache de red limpiado - 45 MB liberados');
  }

  void _showCustomAlertsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Alertas Personalizadas'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Vinos'),
              subtitle: Text('Temp: 15-20°C, Humedad: 60-75%'),
              trailing: Icon(Icons.edit),
            ),
            ListTile(
              title: Text('Productos Electrónicos'),
              subtitle: Text('Temp: 10-30°C, Humedad: <60%'),
              trailing: Icon(Icons.edit),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _showCalibrationDialog(String sensorType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Calibrar Sensor de ${sensorType.substring(0, 1).toUpperCase()}${sensorType.substring(1)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sigue estos pasos para calibrar el sensor de $sensorType:'),
            const SizedBox(height: 16),
            const Text('1. Coloca el sensor en un ambiente controlado'),
            const Text('2. Espera 5 minutos para estabilización'),
            const Text('3. Introduce el valor de referencia'),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Valor de referencia',
                suffixText: sensorType == 'temperatura' ? '°C' : '%',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Sensor de $sensorType calibrado');
            },
            child: const Text('Calibrar'),
          ),
        ],
      ),
    );
  }

  void _showResetCalibrationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Restablecer Calibración'),
        content: const Text('¿Estás seguro de que quieres restablecer la calibración de todos los sensores a los valores de fábrica?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Calibración restablecida');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.warning),
            child: const Text('Restablecer'),
          ),
        ],
      ),
    );
  }

  void _clearCache() async {
    _showLoadingDialog('Limpiando cache...');
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);
    _showSuccessMessage('Cache limpiado - 150 MB liberados');
  }

  void _optimizeDatabase() async {
    _showLoadingDialog('Optimizando base de datos...');
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pop(context);
    _showSuccessMessage('Base de datos optimizada - Velocidad mejorada en 25%');
  }

  void _exportData() async {
    _showLoadingDialog('Exportando datos...');
    await Future.delayed(const Duration(seconds: 4));
    Navigator.pop(context);
    _showSuccessMessage('Datos exportados a /Downloads/rastreo_backup.zip');
  }

  void _importData() async {
    _showLoadingDialog('Importando datos...');
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pop(context);
    _showSuccessMessage('Datos importados exitosamente');
  }

  void _showSystemLogs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logs del Sistema'),
        content: const SizedBox(
          width: double.maxFinite,
          height: 300,
          child: SingleChildScrollView(
            child: Text(
              '2024-01-29 14:30:15 - INFO: App iniciada\n'
              '2024-01-29 14:30:16 - INFO: Conectando a API\n'
              '2024-01-29 14:30:17 - INFO: Autenticación exitosa\n'
              '2024-01-29 14:30:18 - INFO: Sincronizando datos\n'
              '2024-01-29 14:30:19 - WARN: Sensor SEN003 desconectado\n'
              '2024-01-29 14:30:20 - INFO: Reconectando sensor...\n'
              '2024-01-29 14:30:21 - INFO: Sensor SEN003 reconectado\n'
              '2024-01-29 14:30:22 - INFO: Dashboard cargado',
              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Exportar'),
          ),
        ],
      ),
    );
  }

  void _runDiagnostic() async {
    _showLoadingDialog('Ejecutando diagnóstico...');
    await Future.delayed(const Duration(seconds: 5));
    Navigator.pop(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Resultado del Diagnóstico'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('✅ Conectividad de red: OK'),
            Text('✅ Base de datos: OK'),
            Text('✅ Sensores: 3/3 conectados'),
            Text('⚠️ Memoria: 85% utilizada'),
            Text('✅ Almacenamiento: OK'),
            Text('✅ Permisos: OK'),
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

  void _showResetSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Restablecer Configuración'),
        content: const Text('¿Estás seguro de que quieres restablecer toda la configuración a los valores por defecto? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Configuración restablecida');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Restablecer'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('⚠️ PELIGRO'),
        content: const Text('¿Estás COMPLETAMENTE SEGURO de que quieres eliminar TODOS los datos? Esta acción es IRREVERSIBLE y perderás:\n\n• Todos los envíos\n• Configuración de sensores\n• Historial completo\n• Configuración personal'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('ELIMINAR TODO'),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}