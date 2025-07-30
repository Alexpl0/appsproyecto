import 'package:flutter/material.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';
import 'package:rastreo_app/theme/app_theme.dart';
import 'dart:math' as math;

class InteractiveMapWidget extends StatefulWidget {
  final String? shipmentId;
  final bool showAllShipments;
  
  const InteractiveMapWidget({
    super.key,
    this.shipmentId,
    this.showAllShipments = false,
  });

  @override
  State<InteractiveMapWidget> createState() => _InteractiveMapWidgetState();
}

class _InteractiveMapWidgetState extends State<InteractiveMapWidget> {
  String _mapType = 'normal';
  bool _showTraffic = false;
  bool _showRoute = true;
  double _zoom = 1.0;
  Offset _panOffset = Offset.zero;
  
  // Datos simulados de ubicaciones
  final List<Map<String, dynamic>> _shipmentLocations = [
    {
      'id': 'SH001',
      'product': 'Vino Tinto',
      'currentLat': 19.4326,
      'currentLng': -99.1332,
      'originLat': 20.6597,
      'originLng': -103.3496,
      'destLat': 19.4326,
      'destLng': -99.1332,
      'status': 'inTransit',
      'progress': 0.75,
      'speed': 85,
      'eta': '2 horas',
      'driver': 'Carlos López',
      'temperature': '18°C',
    },
    {
      'id': 'SH002',
      'product': 'Tequila Premium',
      'currentLat': 25.6866,
      'currentLng': -100.3161,
      'originLat': 20.9230,
      'originLng': -103.5810,
      'destLat': 25.6866,
      'destLng': -100.3161,
      'status': 'delivered',
      'progress': 1.0,
      'speed': 0,
      'eta': 'Entregado',
      'driver': 'Ana Ruiz',
      'temperature': '22°C',
    },
    {
      'id': 'SH003',
      'product': 'Whisky Escocés',
      'currentLat': 21.1619,
      'currentLng': -86.8515,
      'originLat': 32.5027,
      'originLng': -117.0041,
      'destLat': 21.1619,
      'destLng': -86.8515,
      'status': 'delayed',
      'progress': 0.6,
      'speed': 45,
      'eta': '4 horas',
      'driver': 'Luis Mendoza',
      'temperature': '28°C',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.map),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.layers),
            onSelected: (value) {
              setState(() {
                _mapType = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'normal', child: Text('Normal')),
              PopupMenuItem(value: 'satellite', child: Text(localizations.satellite)),
              PopupMenuItem(value: 'hybrid', child: Text(localizations.hybrid)),
              PopupMenuItem(value: 'terrain', child: Text(localizations.terrain)),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // Mapa principal
          _buildMapContainer(localizations),
          
          // Controles de zoom
          _buildZoomControls(),
          
          // Controles de capa
          _buildLayerControls(localizations),
          
          // Lista de envíos (si se muestran todos)
          if (widget.showAllShipments) _buildShipmentsList(localizations),
          
          // Información del envío específico
          if (widget.shipmentId != null) _buildShipmentInfo(localizations),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _centerOnCurrentLocation(),
        backgroundColor: AppTheme.primaryMedium,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildMapContainer(AppLocalizations localizations) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _panOffset += details.delta;
        });
      },
      onScaleUpdate: (details) {
        setState(() {
          _zoom = (_zoom * details.scale).clamp(0.5, 3.0);
        });
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: _getMapBackgroundColor(),
        ),
        child: Transform.scale(
          scale: _zoom,
          child: Transform.translate(
            offset: _panOffset,
            child: CustomPaint(
              painter: MapPainter(
                shipments: widget.showAllShipments 
                    ? _shipmentLocations 
                    : _shipmentLocations.where((s) => s['id'] == widget.shipmentId).toList(),
                mapType: _mapType,
                showTraffic: _showTraffic,
                showRoute: _showRoute,
                onMarkerTap: _showShipmentDetails,
              ),
              size: Size.infinite,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Positioned(
      right: 16,
      top: 100,
      child: Column(
        children: [
          FloatingActionButton.small(
            heroTag: "zoom_in",
            onPressed: () {
              setState(() {
                _zoom = (_zoom + 0.2).clamp(0.5, 3.0);
              });
            },
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.primaryDark,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: "zoom_out",
            onPressed: () {
              setState(() {
                _zoom = (_zoom - 0.2).clamp(0.5, 3.0);
              });
            },
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.primaryDark,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }

  Widget _buildLayerControls(AppLocalizations localizations) {
    return Positioned(
      left: 16,
      top: 100,
      child: Column(
        children: [
          _buildControlButton(
            icon: _showRoute ? Icons.route : Icons.route_outlined,
            label: 'Rutas',
            isActive: _showRoute,
            onTap: () {
              setState(() {
                _showRoute = !_showRoute;
              });
            },
          ),
          const SizedBox(height: 8),
          _buildControlButton(
            icon: _showTraffic ? Icons.traffic : Icons.traffic_outlined,
            label: 'Tráfico',
            isActive: _showTraffic,
            onTap: () {
              setState(() {
                _showTraffic = !_showTraffic;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryMedium : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isActive ? Colors.white : AppTheme.primaryDark,
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.white : AppTheme.primaryDark,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShipmentsList(AppLocalizations localizations) {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _shipmentLocations.length,
          itemBuilder: (context, index) {
            final shipment = _shipmentLocations[index];
            return Container(
              width: 280,
              margin: const EdgeInsets.only(right: 12),
              child: _buildShipmentCard(shipment, localizations),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShipmentCard(Map<String, dynamic> shipment, AppLocalizations localizations) {
    final status = shipment['status'] as String;
    final statusConfig = _getStatusConfig(status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: statusConfig['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  statusConfig['icon'],
                  color: statusConfig['color'],
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  shipment['id'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDark,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusConfig['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusConfig['label'],
                  style: TextStyle(
                    color: statusConfig['color'],
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            shipment['product'],
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.speed, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${shipment['speed']} km/h',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'ETA: ${shipment['eta']}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentInfo(AppLocalizations localizations) {
    final shipment = _shipmentLocations.firstWhere(
      (s) => s['id'] == widget.shipmentId,
      orElse: () => _shipmentLocations.first,
    );

    return Positioned(
      top: 20,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shipment['id'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                      Text(
                        shipment['product'],
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_shipping,
                    color: AppTheme.info,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Velocidad',
                    '${shipment['speed']} km/h',
                    Icons.speed,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'ETA',
                    shipment['eta'],
                    Icons.access_time,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Temp.',
                    shipment['temperature'],
                    Icons.thermostat,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: shipment['progress'],
              backgroundColor: AppTheme.surface,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.info),
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              'Conductor: ${shipment['driver']}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryMedium),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryDark,
            fontSize: 12,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Color _getMapBackgroundColor() {
    switch (_mapType) {
      case 'satellite':
        return const Color(0xFF2C5234);
      case 'hybrid':
        return const Color(0xFF3E4A3B);
      case 'terrain':
        return const Color(0xFFF5E6D3);
      default:
        return const Color(0xFFF0F8FF);
    }
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status) {
      case 'inTransit':
        return {
          'color': AppTheme.info,
          'icon': Icons.local_shipping,
          'label': 'En Tránsito',
        };
      case 'delivered':
        return {
          'color': AppTheme.success,
          'icon': Icons.check_circle,
          'label': 'Entregado',
        };
      case 'delayed':
        return {
          'color': AppTheme.error,
          'icon': Icons.schedule,
          'label': 'Retrasado',
        };
      default:
        return {
          'color': Colors.grey,
          'icon': Icons.help_outline,
          'label': 'Desconocido',
        };
    }
  }

  void _centerOnCurrentLocation() {
    setState(() {
      _panOffset = Offset.zero;
      _zoom = 1.5;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Centrando en ubicación actual'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showShipmentDetails(String shipmentId) {
    final shipment = _shipmentLocations.firstWhere((s) => s['id'] == shipmentId);
    
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
            mainAxisSize: MainAxisSize.min,
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
                'Detalles del Envío',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 16),
              
              ListTile(
                leading: const Icon(Icons.inventory, color: AppTheme.primaryMedium),
                title: Text(shipment['product']),
                subtitle: Text('ID: ${shipment['id']}'),
              ),
              
              ListTile(
                leading: const Icon(Icons.person, color: AppTheme.success),
                title: Text(shipment['driver']),
                subtitle: const Text('Conductor asignado'),
              ),
              
              ListTile(
                leading: const Icon(Icons.thermostat, color: AppTheme.warning),
                title: Text(shipment['temperature']),
                subtitle: const Text('Temperatura actual'),
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('Cerrar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navegar a detalles completos
                      },
                      icon: const Icon(Icons.info),
                      label: const Text('Ver Más'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  final List<Map<String, dynamic>> shipments;
  final String mapType;
  final bool showTraffic;
  final bool showRoute;
  final Function(String) onMarkerTap;

  MapPainter({
    required this.shipments,
    required this.mapType,
    required this.showTraffic,
    required this.showRoute,
    required this.onMarkerTap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Dibujar fondo del mapa
    _drawMapBackground(canvas, size, paint);
    
    // Dibujar rutas si están habilitadas
    if (showRoute) {
      _drawRoutes(canvas, size, paint);
    }
    
    // Dibujar tráfico si está habilitado
    if (showTraffic) {
      _drawTraffic(canvas, size, paint);
    }
    
    // Dibujar marcadores de envíos
    _drawShipmentMarkers(canvas, size, paint);
  }

  void _drawMapBackground(Canvas canvas, Size size, Paint paint) {
    // Dibujar grid del mapa
    paint.color = Colors.grey.withOpacity(0.2);
    paint.strokeWidth = 1;
    
    const gridSize = 50.0;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    
    // Dibujar algunas "carreteras" simuladas
    paint.color = Colors.grey[400]!;
    paint.strokeWidth = 3;
    
    // Carretera horizontal
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      paint,
    );
    
    // Carretera vertical
    canvas.drawLine(
      Offset(size.width * 0.6, 0),
      Offset(size.width * 0.6, size.height),
      paint,
    );
    
    // Carretera diagonal
    canvas.drawLine(
      Offset(0, size.height * 0.8),
      Offset(size.width, size.height * 0.2),
      paint,
    );
  }

  void _drawRoutes(Canvas canvas, Size size, Paint paint) {
    paint.strokeWidth = 4;
    paint.style = PaintingStyle.stroke;
    
    for (final shipment in shipments) {
      // Convertir coordenadas geográficas a posición en canvas
      final origin = _geoToCanvas(
        shipment['originLat'],
        shipment['originLng'],
        size,
      );
      final destination = _geoToCanvas(
        shipment['destLat'],
        shipment['destLng'],
        size,
      );
      final current = _geoToCanvas(
        shipment['currentLat'],
        shipment['currentLng'],
        size,
      );
      
      // Dibujar ruta completa (gris)
      paint.color = Colors.grey.withOpacity(0.5);
      canvas.drawLine(origin, destination, paint);
      
      // Dibujar ruta completada (azul)
      paint.color = AppTheme.info;
      canvas.drawLine(origin, current, paint);
    }
  }

  void _drawTraffic(Canvas canvas, Size size, Paint paint) {
    // Simular datos de tráfico
    final random = math.Random(42); // Seed fijo para consistencia
    paint.strokeWidth = 6;
    
    for (int i = 0; i < 10; i++) {
      final x1 = random.nextDouble() * size.width;
      final y1 = random.nextDouble() * size.height;
      final x2 = x1 + (random.nextDouble() - 0.5) * 100;
      final y2 = y1 + (random.nextDouble() - 0.5) * 100;
      
      // Color según nivel de tráfico
      final trafficLevel = random.nextDouble();
      if (trafficLevel < 0.3) {
        paint.color = Colors.green; // Tráfico ligero
      } else if (trafficLevel < 0.7) {
        paint.color = Colors.orange; // Tráfico moderado
      } else {
        paint.color = Colors.red; // Tráfico pesado
      }
      
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  void _drawShipmentMarkers(Canvas canvas, Size size, Paint paint) {
    for (final shipment in shipments) {
      final position = _geoToCanvas(
        shipment['currentLat'],
        shipment['currentLng'],
        size,
      );
      
      final status = shipment['status'] as String;
      Color markerColor;
      
      switch (status) {
        case 'inTransit':
          markerColor = AppTheme.info;
          break;
        case 'delivered':
          markerColor = AppTheme.success;
          break;
        case 'delayed':
          markerColor = AppTheme.error;
          break;
        default:
          markerColor = Colors.grey;
      }
      
      // Dibujar sombra del marcador
      paint.color = Colors.black.withOpacity(0.2);
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(position + const Offset(2, 2), 12, paint);
      
      // Dibujar marcador principal
      paint.color = markerColor;
      canvas.drawCircle(position, 10, paint);
      
      // Dibujar borde del marcador
      paint.color = Colors.white;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 2;
      canvas.drawCircle(position, 10, paint);
      
      // Dibujar icono en el marcador
      paint.style = PaintingStyle.fill;
      paint.color = Colors.white;
      canvas.drawCircle(position, 6, paint);
    }
  }

  Offset _geoToCanvas(double lat, double lng, Size size) {
    // Conversión simple de coordenadas geográficas a canvas
    // En una implementación real, se usaría una proyección cartográfica apropiada
    final x = ((lng + 180) / 360) * size.width;
    final y = ((90 - lat) / 180) * size.height;
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}