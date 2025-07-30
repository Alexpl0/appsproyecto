import 'package:flutter/material.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';
import 'package:rastreo_app/theme/app_theme.dart';
import 'dart:async';
import 'dart:math' as math;

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with TickerProviderStateMixin {
  late AnimationController _scanLineController;
  late AnimationController _cornerController;
  late Animation<double> _scanLineAnimation;
  late Animation<double> _cornerAnimation;
  
  bool _isScanning = true;
  bool _flashEnabled = false;
  String _scanResult = '';
  
  // Códigos QR simulados
  final List<Map<String, dynamic>> _mockQRCodes = [
    {
      'code': 'SH001-2024-VT-001',
      'type': 'shipment',
      'data': {
        'id': 'SH001',
        'product': 'Vino Tinto Reserva',
        'destination': 'Ciudad de México',
        'status': 'En tránsito',
        'temperature': '18°C',
        'humidity': '65%',
      }
    },
    {
      'code': 'SEN003-TEMP-HUM-GPS',
      'type': 'sensor',
      'data': {
        'sensorId': 'SEN003',
        'type': 'Multi-sensor',
        'battery': '87%',
        'lastReading': '2 min ago',
      }
    },
    {
      'code': 'https://rastreoapp.com/track/TN-2024-001',
      'type': 'url',
      'data': {
        'url': 'https://rastreoapp.com/track/TN-2024-001',
        'trackingNumber': 'TN-2024-001',
      }
    },
  ];

  @override
  void initState() {
    super.initState();
    
    _scanLineController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _cornerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scanLineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scanLineController,
      curve: Curves.easeInOut,
    ));
    
    _cornerAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _cornerController,
      curve: Curves.elasticOut,
    ));

    _startScanning();
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    _cornerController.dispose();
    super.dispose();
  }

  void _startScanning() {
    _scanLineController.repeat(reverse: true);
    
    // Simular detección de QR después de un tiempo aleatorio
    Timer(Duration(seconds: math.Random().nextInt(5) + 3), () {
      if (mounted && _isScanning) {
        _simulateQRDetection();
      }
    });
  }

  void _simulateQRDetection() {
    final mockCode = _mockQRCodes[math.Random().nextInt(_mockQRCodes.length)];
    
    setState(() {
      _isScanning = false;
      _scanResult = mockCode['code'];
    });
    
    _scanLineController.stop();
    _cornerController.forward();
    
    // Vibrar (simulado)
    _showScanResult(mockCode);
  }

  void _showScanResult(Map<String, dynamic> qrData) {
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
        child: _buildScanResultContent(qrData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.scanCode,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _flashEnabled ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _flashEnabled = !_flashEnabled;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Fondo de cámara simulado
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  Colors.grey[800]!,
                  Colors.black,
                ],
              ),
            ),
          ),
          
          // Overlay con área de escaneo
          _buildScanOverlay(localizations),
          
          // Controles inferiores
          _buildBottomControls(localizations),
          
          // Instrucciones
          if (_isScanning) _buildInstructions(localizations),
        ],
      ),
    );
  }

  Widget _buildScanOverlay(AppLocalizations localizations) {
    return Center(
      child: SizedBox(
        width: 250,
        height: 250,
        child: Stack(
          children: [
            // Marco de escaneo
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.8),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            
            // Esquinas animadas
            AnimatedBuilder(
              animation: _cornerAnimation,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Esquina superior izquierda
                    Positioned(
                      top: -2,
                      left: -2,
                      child: Transform.scale(
                        scale: _cornerAnimation.value,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppTheme.accent, width: 4),
                              left: BorderSide(color: AppTheme.accent, width: 4),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Esquina superior derecha
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Transform.scale(
                        scale: _cornerAnimation.value,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppTheme.accent, width: 4),
                              right: BorderSide(color: AppTheme.accent, width: 4),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Esquina inferior izquierda
                    Positioned(
                      bottom: -2,
                      left: -2,
                      child: Transform.scale(
                        scale: _cornerAnimation.value,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppTheme.accent, width: 4),
                              left: BorderSide(color: AppTheme.accent, width: 4),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Esquina inferior derecha
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Transform.scale(
                        scale: _cornerAnimation.value,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppTheme.accent, width: 4),
                              right: BorderSide(color: AppTheme.accent, width: 4),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            
            // Línea de escaneo
            if (_isScanning)
              AnimatedBuilder(
                animation: _scanLineAnimation,
                builder: (context, child) {
                  return Positioned(
                    top: 20 + (210 * _scanLineAnimation.value),
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppTheme.accent,
                            AppTheme.accent,
                            Colors.transparent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accent.withOpacity(0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls(AppLocalizations localizations) {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.photo_library,
            label: localizations.gallery,
            onTap: () => _simulateGalleryPicker(),
          ),
          if (_isScanning)
            _buildControlButton(
              icon: Icons.refresh,
              label: 'Reiniciar',
              onTap: () => _restartScanning(),
            )
          else
            _buildControlButton(
              icon: Icons.qr_code_scanner,
              label: 'Escanear',
              onTap: () => _restartScanning(),
            ),
          _buildControlButton(
            icon: Icons.history,
            label: 'Historial',
            onTap: () => _showScanHistory(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(30),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions(AppLocalizations localizations) {
    return Positioned(
      top: 120,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Coloca el código QR dentro del marco',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 60),
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.accent.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.qr_code,
                  color: AppTheme.accent,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  'Buscando código...',
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanResultContent(Map<String, dynamic> qrData) {
    final localizations = AppLocalizations.of(context)!;
    final type = qrData['type'] as String;
    final code = qrData['code'] as String;
    final data = qrData['data'] as Map<String, dynamic>;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
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
          
          // Título de éxito
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppTheme.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.codeScanned,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    Text(
                      _getTypeLabel(type),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Código escaneado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Código Detectado:',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  code,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryDark,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Información específica según el tipo
          _buildTypeSpecificInfo(type, data),
          
          const SizedBox(height: 24),
          
          // Botones de acción
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _restartScanning();
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Escanear Otro'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _handleScanAction(type, data),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Abrir'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSpecificInfo(String type, Map<String, dynamic> data) {
    switch (type) {
      case 'shipment':
        return _buildShipmentInfo(data);
      case 'sensor':
        return _buildSensorInfo(data);
      case 'url':
        return _buildUrlInfo(data);
      default:
        return const SizedBox();
    }
  }

  Widget _buildShipmentInfo(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.info.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_shipping, color: AppTheme.info, size: 20),
              SizedBox(width: 8),
              Text(
                'Información del Envío',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('ID', data['id']),
          _buildInfoRow('Producto', data['product']),
          _buildInfoRow('Destino', data['destination']),
          _buildInfoRow('Estado', data['status']),
          if (data['temperature'] != null)
            _buildInfoRow('Temperatura', data['temperature']),
          if (data['humidity'] != null)
            _buildInfoRow('Humedad', data['humidity']),
        ],
      ),
    );
  }

  Widget _buildSensorInfo(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.success.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.sensors, color: AppTheme.success, size: 20),
              SizedBox(width: 8),
              Text(
                'Información del Sensor',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('ID Sensor', data['sensorId']),
          _buildInfoRow('Tipo', data['type']),
          _buildInfoRow('Batería', data['battery']),
          _buildInfoRow('Última lectura', data['lastReading']),
        ],
      ),
    );
  }

  Widget _buildUrlInfo(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.link, color: AppTheme.accent, size: 20),
              SizedBox(width: 8),
              Text(
                'Enlace de Seguimiento',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('URL', data['url']),
          if (data['trackingNumber'] != null)
            _buildInfoRow('Número de seguimiento', data['trackingNumber']),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'shipment':
        return 'Código de Envío';
      case 'sensor':
        return 'Código de Sensor';
      case 'url':
        return 'Enlace Web';
      default:
        return 'Código QR';
    }
  }

  void _restartScanning() {
    setState(() {
      _isScanning = true;
      _scanResult = '';
    });
    _cornerController.reset();
    _startScanning();
  }

  void _simulateGalleryPicker() {
    // Simular selección desde galería
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Seleccionar de Galería'),
        content: const Text('Función de galería no implementada en la simulación.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showScanHistory() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
                'Historial de Escaneos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final historyItem = _mockQRCodes[index % _mockQRCodes.length];
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.qr_code,
                          color: AppTheme.accent,
                          size: 20,
                        ),
                      ),
                      title: Text(historyItem['code']),
                      subtitle: Text(_getTypeLabel(historyItem['type'])),
                      trailing: Text(
                        'Hace ${index + 1}h',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _showScanResult(historyItem);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleScanAction(String type, Map<String, dynamic> data) {
    Navigator.pop(context);
    Navigator.pop(context);
    
    switch (type) {
      case 'shipment':
        // Navegar a detalles del envío
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Abriendo detalles del envío ${data['id']}'),
            backgroundColor: AppTheme.info,
          ),
        );
        break;
      case 'sensor':
        // Navegar a detalles del sensor
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Conectando con sensor ${data['sensorId']}'),
            backgroundColor: AppTheme.success,
          ),
        );
        break;
      case 'url':
        // Abrir URL
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Abriendo enlace de seguimiento'),
            backgroundColor: AppTheme.accent,
          ),
        );
        break;
    }
  }
}