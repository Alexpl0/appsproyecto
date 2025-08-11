import 'package:flutter/material.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';
import 'package:rastreo_app/theme/app_theme.dart';
import 'dart:math' as math;
import 'dart:async';

class AdvancedSensorsScreen extends StatefulWidget {
  const AdvancedSensorsScreen({super.key});

  @override
  State<AdvancedSensorsScreen> createState() => _AdvancedSensorsScreenState();
}

class _AdvancedSensorsScreenState extends State<AdvancedSensorsScreen>
    with TickerProviderStateMixin {
  Timer? _simulationTimer;
  late TabController _tabController;
  
  // Datos simulados de dispositivos
  final List<Map<String, dynamic>> _devices = [
    {
      'id': 'SEN001',
      'name': 'Sensor Vino Tinto',
      'type': 'multi',
      'status': 'connected',
      'batteryLevel': 87,
      'signalStrength': 4,
      'shipmentId': 'SH001',
      'lastUpdate': DateTime.now().subtract(const Duration(minutes: 2)),
      'sensors': {
        'temperature': {'value': 18.5, 'unit': '°C', 'min': 15, 'max': 25, 'status': 'normal'},
        'humidity': {'value': 65.2, 'unit': '%', 'min': 50, 'max': 70, 'status': 'normal'},
        'light': {'value': 120, 'unit': 'lux', 'min': 0, 'max': 500, 'status': 'normal'},
        'pressure': {'value': 1013.2, 'unit': 'hPa', 'min': 900, 'max': 1100, 'status': 'normal'},
        'gps': {'lat': 19.4326, 'lng': -99.1332, 'accuracy': 3.2},
        'accelerometer': {'x': 0.2, 'y': -0.1, 'z': 9.8, 'vibration': 'low'},
      },
      'history': <Map<String, dynamic>>[], // Inicializar como lista vacía
    },
    {
      'id': 'SEN002',
      'name': 'Sensor Tequila Premium',
      'type': 'temperature',
      'status': 'connected',
      'batteryLevel': 92,
      'signalStrength': 5,
      'shipmentId': 'SH002',
      'lastUpdate': DateTime.now().subtract(const Duration(minutes: 1)),
      'sensors': {
        'temperature': {'value': 22.3, 'unit': '°C', 'min': 18, 'max': 28, 'status': 'normal'},
        'humidity': {'value': 58.7, 'unit': '%', 'min': 40, 'max': 80, 'status': 'normal'},
        'gps': {'lat': 25.6866, 'lng': -100.3161, 'accuracy': 2.8},
      },
      'history': <Map<String, dynamic>>[],
    },
    {
      'id': 'SEN003',
      'name': 'Sensor Whisky Escocés',
      'type': 'multi',
      'status': 'warning',
      'batteryLevel': 23,
      'signalStrength': 2,
      'shipmentId': 'SH003',
      'lastUpdate': DateTime.now().subtract(const Duration(minutes: 15)),
      'sensors': {
        'temperature': {'value': 28.9, 'unit': '°C', 'min': 15, 'max': 25, 'status': 'high'},
        'humidity': {'value': 82.1, 'unit': '%', 'min': 50, 'max': 70, 'status': 'high'},
        'light': {'value': 850, 'unit': 'lux', 'min': 0, 'max': 500, 'status': 'high'},
        'gps': {'lat': 21.1619, 'lng': -86.8515, 'accuracy': 8.5},
        'accelerometer': {'x': 2.1, 'y': -1.8, 'z': 9.2, 'vibration': 'high'},
      },
      'history': <Map<String, dynamic>>[],
    },
  ];

  int _selectedDeviceIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _startSimulation();
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        for (var device in _devices) {
          _updateDeviceData(device);
        }
      });
    });
  }

  void _updateDeviceData(Map<String, dynamic> device) {
    final sensors = device['sensors'] as Map<String, dynamic>;
    final history = device['history'] as List<Map<String, dynamic>>;
    
    // Actualizar datos de sensores con variación realista
    if (sensors.containsKey('temperature')) {
      final temp = sensors['temperature'] as Map<String, dynamic>;
      final currentTemp = temp['value'] as double;
      final newTemp = currentTemp + (math.Random().nextDouble() - 0.5) * 2;
      temp['value'] = double.parse(newTemp.toStringAsFixed(1));
      
      // Verificar umbrales
      final min = temp['min'] as int;
      final max = temp['max'] as int;
      if (newTemp < min) {
        temp['status'] = 'low';
      } else if (newTemp > max) {
        temp['status'] = 'high';
      } else {
        temp['status'] = 'normal';
      }
    }

    if (sensors.containsKey('humidity')) {
      final humidity = sensors['humidity'] as Map<String, dynamic>;
      final currentHumidity = humidity['value'] as double;
      final newHumidity = currentHumidity + (math.Random().nextDouble() - 0.5) * 3;
      humidity['value'] = double.parse(newHumidity.clamp(0, 100).toStringAsFixed(1));
      
      final min = humidity['min'] as int;
      final max = humidity['max'] as int;
      if (newHumidity < min) {
        humidity['status'] = 'low';
      } else if (newHumidity > max) {
        humidity['status'] = 'high';
      } else {
        humidity['status'] = 'normal';
      }
    }

    if (sensors.containsKey('gps')) {
      final gps = sensors['gps'] as Map<String, dynamic>;
      final currentLat = gps['lat'] as double;
      final currentLng = gps['lng'] as double;
      
      // Simular movimiento pequeño
      gps['lat'] = currentLat + (math.Random().nextDouble() - 0.5) * 0.001;
      gps['lng'] = currentLng + (math.Random().nextDouble() - 0.5) * 0.001;
      gps['accuracy'] = 1.0 + math.Random().nextDouble() * 5;
    }

    // Agregar entrada al historial
    history.add({
      'timestamp': DateTime.now(),
      'temperature': sensors['temperature']?['value'],
      'humidity': sensors['humidity']?['value'],
    });

    // Mantener solo las últimas 20 lecturas
    if (history.length > 20) {
      history.removeAt(0);
    }

    // Actualizar estado del dispositivo basado en alertas
    final hasHighTemp = sensors['temperature']?['status'] == 'high';
    final hasHighHumidity = sensors['humidity']?['status'] == 'high';
    
    if (hasHighTemp || hasHighHumidity) {
      device['status'] = 'warning';
    } else {
      device['status'] = 'connected';
    }

    device['lastUpdate'] = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // 📊 Resumen de dispositivos
          _buildDevicesSummary(localizations, theme),
          
          // 📱 Tabs de navegación
          _buildTabBar(localizations, theme),
          
          // 📄 Contenido de las tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDevicesOverview(localizations, theme),
                _buildSelectedDeviceDetails(localizations, theme),
                _buildAlertsAndSettings(localizations, theme),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDeviceModal(context, localizations),
        backgroundColor: AppTheme.primaryMedium,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDevicesSummary(AppLocalizations localizations, ThemeData theme) {
    final connectedDevices = _devices.where((d) => d['status'] == 'connected').length;
    final warningDevices = _devices.where((d) => d['status'] == 'warning').length;
    final disconnectedDevices = _devices.where((d) => d['status'] == 'disconnected').length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryMedium.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            localizations.sensorDashboard,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.check_circle,
                  label: localizations.connected,
                  value: connectedDevices.toString(),
                  color: AppTheme.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.warning,
                  label: localizations.alerts,
                  value: warningDevices.toString(),
                  color: AppTheme.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.cloud_off,
                  label: localizations.disconnected,
                  value: disconnectedDevices.toString(),
                  color: AppTheme.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(AppLocalizations localizations, ThemeData theme) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppTheme.primaryMedium,
        labelColor: AppTheme.primaryMedium,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(
            icon: Icon(Icons.dashboard),
            text: 'Dispositivos',
          ),
          Tab(
            icon: Icon(Icons.analytics),
            text: 'Detalles',
          ),
          Tab(
            icon: Icon(Icons.settings),
            text: 'Alertas',
          ),
        ],
      ),
    );
  }

  Widget _buildDevicesOverview(AppLocalizations localizations, ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _devices.length,
      itemBuilder: (context, index) {
        final device = _devices[index];
        return _buildDeviceCard(device, localizations, theme, index);
      },
    );
  }

  Widget _buildDeviceCard(
    Map<String, dynamic> device,
    AppLocalizations localizations,
    ThemeData theme,
    int index,
  ) {
    final status = device['status'] as String;
    final statusConfig = _getDeviceStatusConfig(status);
    final sensors = device['sensors'] as Map<String, dynamic>;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedDeviceIndex = index;
            _tabController.animateTo(1);
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabecera del dispositivo
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: statusConfig['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.sensors,
                      color: statusConfig['color'],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device['name'],
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                        Text(
                          'ID: ${device['id']} • ${device['shipmentId']}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusConfig['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusConfig['label'],
                      style: TextStyle(
                        color: statusConfig['color'],
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Información del dispositivo
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.battery_std,
                    label: 'Batería',
                    value: '${device['batteryLevel']}%',
                    color: _getBatteryColor(device['batteryLevel']),
                  ),
                  const SizedBox(width: 12),
                  _buildInfoChip(
                    icon: Icons.signal_cellular_alt,
                    label: 'Señal',
                    value: '${device['signalStrength']}/5',
                    color: _getSignalColor(device['signalStrength']),
                  ),
                  const SizedBox(width: 12),
                  _buildInfoChip(
                    icon: Icons.access_time,
                    label: 'Actualizado',
                    value: _formatTimeAgo(device['lastUpdate']),
                    color: Colors.grey,
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Datos de sensores principales
              if (sensors.containsKey('temperature')) ...[
                _buildSensorReading(
                  'Temperatura',
                  sensors['temperature'],
                  Icons.thermostat,
                  AppTheme.info,
                ),
                const SizedBox(height: 8),
              ],
              
              if (sensors.containsKey('humidity')) ...[
                _buildSensorReading(
                  'Humedad',
                  sensors['humidity'],
                  Icons.water_drop,
                  AppTheme.accent,
                ),
                const SizedBox(height: 8),
              ],
              
              if (sensors.containsKey('gps'))
                _buildGPSReading(sensors['gps']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorReading(
    String label,
    Map<String, dynamic> sensorData,
    IconData icon,
    Color baseColor,
  ) {
    final value = sensorData['value'];
    final unit = sensorData['unit'];
    final status = sensorData['status'];
    final statusColor = _getSensorStatusColor(status);

    return Row(
      children: [
        Icon(icon, size: 18, color: statusColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$value$unit',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGPSReading(Map<String, dynamic> gpsData) {
    final lat = gpsData['lat'] as double;
    final lng = gpsData['lng'] as double;
    final accuracy = gpsData['accuracy'] as double;

    return Row(
      children: [
        const Icon(Icons.location_on, size: 18, color: AppTheme.success),
        const SizedBox(width: 8),
        Text(
          'GPS',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryDark,
              ),
            ),
            Text(
              '±${accuracy.toStringAsFixed(1)}m',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectedDeviceDetails(AppLocalizations localizations, ThemeData theme) {
    if (_selectedDeviceIndex >= _devices.length) return const SizedBox();
    
    final device = _devices[_selectedDeviceIndex];
    final sensors = device['sensors'] as Map<String, dynamic>;
    final history = device['history'] as List<Map<String, dynamic>>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera del dispositivo seleccionado
          _buildDetailHeader(device, theme),
          
          const SizedBox(height: 24),
          
          // Lecturas actuales de todos los sensores
          _buildAllSensorReadings(sensors, localizations, theme),
          
          const SizedBox(height: 24),
          
          // Gráfico de historial
          if (history.isNotEmpty)
            _buildHistoryChart(history, theme),
          
          const SizedBox(height: 24),
          
          // Configuración de umbrales
          _buildThresholdSettings(sensors, localizations, theme),
        ],
      ),
    );
  }

  Widget _buildDetailHeader(Map<String, dynamic> device, ThemeData theme) {
    final statusConfig = _getDeviceStatusConfig(device['status']);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.sensors,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ID: ${device['id']}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  statusConfig['label'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildDetailStat('Batería', '${device['batteryLevel']}%', Icons.battery_std),
              _buildDetailStat('Señal', '${device['signalStrength']}/5', Icons.signal_cellular_alt),
              _buildDetailStat('Envío', device['shipmentId'], Icons.local_shipping),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailStat(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllSensorReadings(
    Map<String, dynamic> sensors,
    AppLocalizations localizations,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lecturas Actuales',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryDark,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            if (sensors.containsKey('temperature'))
              _buildSensorGauge(
                'Temperatura',
                sensors['temperature'],
                Icons.thermostat,
                AppTheme.error,
              ),
            if (sensors.containsKey('humidity'))
              _buildSensorGauge(
                'Humedad',
                sensors['humidity'],
                Icons.water_drop,
                AppTheme.info,
              ),
            if (sensors.containsKey('light'))
              _buildSensorGauge(
                'Luz',
                sensors['light'],
                Icons.wb_sunny,
                AppTheme.warning,
              ),
            if (sensors.containsKey('pressure'))
              _buildSensorGauge(
                'Presión',
                sensors['pressure'],
                Icons.compress,
                AppTheme.accent,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSensorGauge(
    String label,
    Map<String, dynamic> sensorData,
    IconData icon,
    Color color,
  ) {
    final value = sensorData['value'] as double;
    final unit = sensorData['unit'] as String;
    final status = sensorData['status'] as String;
    final statusColor = _getSensorStatusColor(status);

    return Container(
      padding: const EdgeInsets.all(16),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: statusColor, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${value.toStringAsFixed(1)}$unit',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryChart(List<Map<String, dynamic>> history, ThemeData theme) {
    return Container(
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
            'Historial de Lecturas',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: history.take(10).map((reading) {
                final temp = reading['temperature'] as double?;
                final height = temp != null ? (temp / 40) * 100 : 0.0;
                
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      height: height.clamp(10, 100),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppTheme.primaryMedium,
                            AppTheme.accent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThresholdSettings(
    Map<String, dynamic> sensors,
    AppLocalizations localizations,
    ThemeData theme,
  ) {
    return Container(
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
            localizations.thresholds,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 16),
          if (sensors.containsKey('temperature'))
            _buildThresholdRow(
              'Temperatura',
              sensors['temperature'],
              Icons.thermostat,
            ),
          if (sensors.containsKey('humidity'))
            _buildThresholdRow(
              'Humedad',
              sensors['humidity'],
              Icons.water_drop,
            ),
        ],
      ),
    );
  }

  Widget _buildThresholdRow(
    String label,
    Map<String, dynamic> sensorData,
    IconData icon,
  ) {
    final min = sensorData['min'] as int;
    final max = sensorData['max'] as int;
    final unit = sensorData['unit'] as String;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryMedium),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryDark,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$min$unit - $max$unit',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsAndSettings(AppLocalizations localizations, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.alerts,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 16),
          
          // Alertas activas
          _buildActiveAlerts(localizations, theme),
          
          const SizedBox(height: 24),
          
          Text(
            localizations.settings,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 16),
          
          // Configuraciones
          _buildSettingsOptions(localizations, theme),
        ],
      ),
    );
  }

  Widget _buildActiveAlerts(AppLocalizations localizations, ThemeData theme) {
    final activeAlerts = <Map<String, dynamic>>[];
    
    // Buscar dispositivos con alertas
    for (final device in _devices) {
      final sensors = device['sensors'] as Map<String, dynamic>;
      
      if (sensors.containsKey('temperature')) {
        final temp = sensors['temperature'] as Map<String, dynamic>;
        if (temp['status'] != 'normal') {
          activeAlerts.add({
            'device': device['name'],
            'type': 'Temperatura',
            'value': '${temp['value']}${temp['unit']}',
            'status': temp['status'],
            'icon': Icons.thermostat,
          });
        }
      }
      
      if (device['batteryLevel'] < 30) {
        activeAlerts.add({
          'device': device['name'],
          'type': 'Batería Baja',
          'value': '${device['batteryLevel']}%',
          'status': 'low',
          'icon': Icons.battery_alert,
        });
      }
    }

    if (activeAlerts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.success, size: 24),
            SizedBox(width: 12),
            Text(
              'No hay alertas activas',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.success,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: activeAlerts.map((alert) {
        final statusColor = _getSensorStatusColor(alert['status']);
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  alert['icon'],
                  color: statusColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert['type'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                    Text(
                      '${alert['device']} - ${alert['value']}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  // TODO: Marcar como vista
                },
                icon: const Icon(Icons.close),
                iconSize: 18,
                color: Colors.grey,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSettingsOptions(AppLocalizations localizations, ThemeData theme) {
    return Column(
      children: [
        _buildSettingsTile(
          icon: Icons.notifications,
          title: localizations.pushNotifications,
          subtitle: 'Recibir alertas en tiempo real',
          value: true,
          onChanged: (value) {
            // TODO: Actualizar configuración
          },
        ),
        _buildSettingsTile(
          icon: Icons.sync,
          title: 'Sincronización Automática',
          subtitle: 'Actualizar datos cada 5 segundos',
          value: true,
          onChanged: (value) {
            // TODO: Actualizar configuración
          },
        ),
        _buildSettingsTile(
          icon: Icons.bluetooth,
          title: 'Reconexión Automática',
          subtitle: 'Intentar reconectar dispositivos',
          value: false,
          onChanged: (value) {
            // TODO: Actualizar configuración
          },
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryMedium),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryDark,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryMedium,
        ),
      ),
    );
  }

  void _showAddDeviceModal(BuildContext context, AppLocalizations localizations) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
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
              Text(
                'Agregar Dispositivo',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 20),
              
              // Opciones de dispositivos
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildDeviceTypeCard(
                      'Sensor Multi',
                      'Temp, Humedad, GPS',
                      Icons.sensors,
                      AppTheme.primaryMedium,
                    ),
                    _buildDeviceTypeCard(
                      'Sensor Temp',
                      'Solo temperatura',
                      Icons.thermostat,
                      AppTheme.info,
                    ),
                    _buildDeviceTypeCard(
                      'GPS Tracker',
                      'Solo ubicación',
                      Icons.location_on,
                      AppTheme.success,
                    ),
                    _buildDeviceTypeCard(
                      'Acelerómetro',
                      'Movimiento',
                      Icons.vibration,
                      AppTheme.warning,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceTypeCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Dispositivo $title agregado'),
              backgroundColor: AppTheme.success,
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Métodos auxiliares
  Map<String, dynamic> _getDeviceStatusConfig(String status) {
    switch (status) {
      case 'connected':
        return {
          'color': AppTheme.success,
          'label': 'Conectado',
        };
      case 'warning':
        return {
          'color': AppTheme.warning,
          'label': 'Advertencia',
        };
      case 'disconnected':
        return {
          'color': AppTheme.error,
          'label': 'Desconectado',
        };
      default:
        return {
          'color': Colors.grey,
          'label': 'Desconocido',
        };
    }
  }

  Color _getBatteryColor(int batteryLevel) {
    if (batteryLevel > 60) return AppTheme.success;
    if (batteryLevel > 30) return AppTheme.warning;
    return AppTheme.error;
  }

  Color _getSignalColor(int signalStrength) {
    if (signalStrength >= 4) return AppTheme.success;
    if (signalStrength >= 2) return AppTheme.warning;
    return AppTheme.error;
  }

  Color _getSensorStatusColor(String status) {
    switch (status) {
      case 'normal':
        return AppTheme.success;
      case 'high':
        return AppTheme.error;
      case 'low':
        return AppTheme.warning;
      default:
        return Colors.grey;
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}