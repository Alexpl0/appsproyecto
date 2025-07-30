import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';
import 'package:rastreo_app/models/sensor_model.dart';

class SensorDataScreen extends StatefulWidget {
  final BluetoothConnection connection;

  const SensorDataScreen({super.key, required this.connection});

  @override
  State<SensorDataScreen> createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  SensorData _sensorData = SensorData();

  @override
  void initState() {
    super.initState();
    widget.connection.input?.listen(_onDataReceived).onDone(() {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Conexión perdida")));
        Navigator.of(context).pop();
      }
    });
  }

  void _onDataReceived(Uint8List data) {
    final receivedString = utf8.decode(data);
    setState(() {
      _sensorData = SensorData.fromRawData(receivedString);
    });
  }

  void _requestData() {
    try {
      widget.connection.output.add(utf8.encode("D\n"));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al enviar comando: $e")));
    }
  }
  
  @override
  void dispose() {
    widget.connection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.sensorData),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSensorCard(Icons.thermostat, localizations.temperatureLM35, '${_sensorData.temperaturaLM35} °C'),
            _buildSensorCard(Icons.device_thermostat, localizations.temperatureDHT, '${_sensorData.temperaturaDHT} °C'),
            _buildSensorCard(Icons.water_drop_outlined, localizations.humidity, '${_sensorData.humedad} %'),
            _buildSensorCard(Icons.wb_sunny_outlined, localizations.light, '${_sensorData.luz} %'),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _requestData,
              icon: const Icon(Icons.refresh),
              label: Text(localizations.requestData),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ].animate(interval: 100.ms).fadeIn(duration: 400.ms).slideX(),
        ),
      ),
    );
  }

  Widget _buildSensorCard(IconData icon, String title, String value) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(value, style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}
