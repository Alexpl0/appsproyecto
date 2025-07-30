import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';
import 'package:rastreo_app/screens/sensors/sensor_data_screen.dart';

class DeviceSelectionScreen extends StatefulWidget {
  const DeviceSelectionScreen({super.key});

  @override
  State<DeviceSelectionScreen> createState() => _DeviceSelectionScreenState();
}

class _DeviceSelectionScreenState extends State<DeviceSelectionScreen> {
  final List<BluetoothDiscoveryResult> _foundDevices = [];
  bool _isDiscovering = false;

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndDiscover();
  }
  
  Future<void> _requestPermissionsAndDiscover() async {
    final statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    // Solo continúa si TODOS los permisos fueron concedidos
    if (statuses.values.every((status) => status.isGranted)) {
      _startDiscovery();
    } else {
      // Muestra un mensaje de error o solicita de nuevo
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permisos de Bluetooth requeridos')),
      );
    }
  }

  void _startDiscovery() {
    setState(() {
      _foundDevices.clear();
      _isDiscovering = true;
    });

    FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
      final existingIndex = _foundDevices.indexWhere(
        (r) => r.device.address == result.device.address,
      );
      if (existingIndex >= 0) {
        setState(() => _foundDevices[existingIndex] = result);
      } else {
        setState(() => _foundDevices.add(result));
      }
    }).onDone(() => setState(() => _isDiscovering = false));
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      final connection = await BluetoothConnection.toAddress(device.address);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SensorDataScreen(connection: connection),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.connectionError}: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: _isDiscovering
          ? const Center(child: CircularProgressIndicator())
          : _foundDevices.isEmpty
              ? Center(child: Text(localizations.noDevicesFound, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _foundDevices.length,
                  itemBuilder: (context, index) {
                    final device = _foundDevices[index].device;
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.bluetooth, color: Colors.blue),
                        title: Text(device.name ?? localizations.unnamedDevice),
                        subtitle: Text(device.address),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _connectToDevice(device),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startDiscovery,
        tooltip: localizations.searchDevices,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
