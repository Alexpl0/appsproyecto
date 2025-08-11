import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import '../services/directions_service.dart' as directions; // Alias para evitar conflicto
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

class _InteractiveMapWidgetState extends State<InteractiveMapWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;

  double _mapCenterLat = 20.6597;
  double _mapCenterLng = -103.3496;
  double _zoomLevel = 8.0;

  String? _selectedShipmentId;
  directions.RouteInfo? _currentRoute;
  bool _isLoadingRoute = false;
  bool _showRouteSteps = false;

  final directions.DirectionsService _directionsService = directions.DirectionsService();

  final List<Map<String, dynamic>> _shipments = [
    {
      'id': 'SH001',
      'product': 'Vino Tinto Reserva',
      'status': 'En tránsito',
      'currentLat': 20.6597,
      'currentLng': -103.3496,
      'originLat': 20.6765,
      'originLng': -103.3475,
      'destLat': 19.4326,
      'destLng': -99.1332,
      'origin': 'Guadalajara, JAL',
      'destination': 'Ciudad de México, CDMX',
      'recipient': 'Juan Pérez',
      'estimatedDelivery': '29 Enero 2024',
      'statusColor': AppTheme.info,
      'temperature': 18.5,
      'humidity': 65.2,
      'lastUpdate': '2 min',
    },
    {
      'id': 'SH002',
      'product': 'Tequila Premium',
      'status': 'Entregado',
      'currentLat': 19.4326,
      'currentLng': -99.1332,
      'originLat': 20.6597,
      'originLng': -103.3496,
      'destLat': 19.4326,
      'destLng': -99.1332,
      'origin': 'Guadalajara, JAL',
      'destination': 'Ciudad de México, CDMX',
      'recipient': 'María González',
      'estimatedDelivery': '28 Enero 2024',
      'statusColor': AppTheme.success,
      'temperature': 20.1,
      'humidity': 58.7,
      'lastUpdate': '1 hora',
    },
    {
      'id': 'SH003',
      'product': 'Cerveza Artesanal',
      'status': 'En bodega',
      'currentLat': 25.6866,
      'currentLng': -100.3161,
      'originLat': 25.6866,
      'originLng': -100.3161,
      'destLat': 21.1619,
      'destLng': -86.8515,
      'origin': 'Monterrey, NL',
      'destination': 'Cancún, QR',
      'recipient': 'Hotel Paradise',
      'estimatedDelivery': '31 Enero 2024',
      'statusColor': AppTheme.warning,
      'temperature': 15.3,
      'humidity': 72.1,
      'lastUpdate': '5 min',
    },
  ];

  // Define el conjunto de marcadores
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    if (widget.shipmentId != null) {
      _selectedShipmentId = widget.shipmentId;
      _centerMapOnShipment(widget.shipmentId!);
      _loadRouteForShipment(widget.shipmentId!);
    }

    // Agrega marcadores basados en los datos de los envíos
    for (final shipment in _shipments) {
      _markers.add(
        Marker(
          markerId: MarkerId(shipment['id']),
          position: LatLng(shipment['currentLat'], shipment['currentLng']),
          infoWindow: InfoWindow(
            title: shipment['product'],
            snippet: shipment['status'],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _centerMapOnShipment(String shipmentId) {
    final shipment = _shipments.firstWhere((s) => s['id'] == shipmentId);
    setState(() {
      _mapCenterLat = shipment['currentLat'];
      _mapCenterLng = shipment['currentLng'];
      _zoomLevel = 10.0;
    });
  }

  Future<void> _loadRouteForShipment(String shipmentId) async {
    final shipment = _shipments.firstWhere((s) => s['id'] == shipmentId);
    
    setState(() {
      _isLoadingRoute = true;
      _currentRoute = null;
    });

    try {
      // Usa la API real o simulada según prefieras
      final route = await _directionsService.getSimulatedRoute(
        originLat: shipment['originLat'],
        originLng: shipment['originLng'],
        destLat: shipment['destLat'],
        destLng: shipment['destLng'],
      );

      // Para usar la API real de Google (necesitas API Key):
      // final route = await _directionsService.getRoute(
      //   originLat: shipment['originLat'],
      //   originLng: shipment['originLng'],
      //   destLat: shipment['destLat'],
      //   destLng: shipment['destLng'],
      // );

      setState(() {
        _currentRoute = route;
        _isLoadingRoute = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingRoute = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando ruta: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shipmentId != null 
            ? 'Rastreo ${widget.shipmentId}' 
            : 'Mapa de Envíos'),
        backgroundColor: AppTheme.primaryDark,
        foregroundColor: Colors.white,
        actions: [
          if (_selectedShipmentId != null) ...[
            IconButton(
              icon: Icon(_showRouteSteps ? Icons.map : Icons.list),
              onPressed: () {
                setState(() {
                  _showRouteSteps = !_showRouteSteps;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _loadRouteForShipment(_selectedShipmentId!),
            ),
          ],
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: _showLayersMenu,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Mapa principal
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(20.6597, -103.3496), // Coordenadas iniciales
              zoom: 10,
            ),
            markers: Set<Marker>.of(_markers), // Agrega marcadores si es necesario
          ),

          // Indicador de carga de ruta
          if (_isLoadingRoute)
            const Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Calculando ruta...'),
                    ],
                  ),
                ),
              ),
            ),

          // Panel de información de ruta
          if (_currentRoute != null && !_isLoadingRoute)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.route, color: AppTheme.primaryMedium),
                          SizedBox(width: 8),
                          Text(
                            'Ruta calculada',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.straighten, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(_currentRoute!.distance),
                          const SizedBox(width: 16),
                          Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(_currentRoute!.duration),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Panel de pasos de navegación
          if (_showRouteSteps && _currentRoute != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryMedium,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.directions, color: Colors.white),
                          const SizedBox(width: 8),
                          const Text(
                            'Instrucciones de navegación',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _showRouteSteps = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _currentRoute!.steps.length,
                        itemBuilder: (context, index) {
                          final step = _currentRoute!.steps[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppTheme.primaryMedium,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(step.instruction),
                              subtitle: Text('${step.distance} • ${step.duration}'),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Controles de zoom
          Positioned(
            right: 16,
            bottom: _showRouteSteps ? MediaQuery.of(context).size.height * 0.4 + 16 : 100,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: "zoom_in",
                  onPressed: () {
                    setState(() {
                      _zoomLevel = (_zoomLevel + 1).clamp(1.0, 18.0);
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
                      _zoomLevel = (_zoomLevel - 1).clamp(1.0, 18.0);
                    });
                  },
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryDark,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),

          // Detector de gestos para seleccionar envíos
          GestureDetector(
            onTapUp: (details) => _handleMapTap(details.localPosition),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
      floatingActionButton: widget.showAllShipments ? FloatingActionButton(
        onPressed: _centerMapOnAllShipments,
        backgroundColor: AppTheme.primaryMedium,
        child: const Icon(Icons.center_focus_strong, color: Colors.white),
      ) : null,
    );
  }

  void _handleMapTap(Offset localPosition) {
    final size = MediaQuery.of(context).size;
    final shipmentTapped = _getShipmentAtPosition(localPosition, size);
    
    if (shipmentTapped != null) {
      setState(() {
        _selectedShipmentId = shipmentTapped['id'];
      });
      _showShipmentDetails(shipmentTapped);
      _loadRouteForShipment(shipmentTapped['id']);
    }
  }

  Map<String, dynamic>? _getShipmentAtPosition(Offset position, Size screenSize) {
    for (final shipment in _shipments) {
      final screenPos = _latLngToScreen(
        shipment['currentLat'],
        shipment['currentLng'],
        screenSize,
      );
      
      final distance = (position - screenPos).distance;
      if (distance < 40) {
        return shipment;
      }
    }
    return null;
  }

  Offset _latLngToScreen(double lat, double lng, Size screenSize) {
    final double latRange = 180.0 / math.pow(2, _zoomLevel - 1);
    final double lngRange = 360.0 / math.pow(2, _zoomLevel - 1);
    
    final double x = ((lng - (_mapCenterLng - lngRange / 2)) / lngRange) * screenSize.width;
    final double y = (((_mapCenterLat + latRange / 2) - lat) / latRange) * screenSize.height;
    
    return Offset(x, y);
  }

  void _showShipmentDetails(Map<String, dynamic> shipment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: shipment['statusColor'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.local_shipping,
                            color: shipment['statusColor'],
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Envío ${shipment['id']}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryDark,
                                ),
                              ),
                              Text(
                                shipment['product'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: shipment['statusColor'],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            shipment['status'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    if (_currentRoute != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primaryLight),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.route, color: AppTheme.primaryMedium),
                                SizedBox(width: 8),
                                Text(
                                  'Información de ruta',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Distancia',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        _currentRoute!.distance,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tiempo estimado',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        _currentRoute!.duration,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    _buildDetailRow('Destinatario', shipment['recipient']),
                    _buildDetailRow('Origen', shipment['origin']),
                    _buildDetailRow('Destino', shipment['destination']),
                    _buildDetailRow('Entrega estimada', shipment['estimatedDelivery']),
                    _buildDetailRow('Temperatura', '${shipment['temperature']}°C'),
                    _buildDetailRow('Humedad', '${shipment['humidity']}%'),
                    _buildDetailRow('Última actualización', 'Hace ${shipment['lastUpdate']}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLayersMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Vista del mapa'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.satellite),
              title: const Text('Vista satelital'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.traffic),
              title: const Text('Mostrar tráfico'),
              trailing: Switch(
                value: true,
                onChanged: (value) => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _centerMapOnAllShipments() {
    if (_shipments.isEmpty) return;
    
    double minLat = _shipments.first['currentLat'];
    double maxLat = _shipments.first['currentLat'];
    double minLng = _shipments.first['currentLng'];
    double maxLng = _shipments.first['currentLng'];
    
    for (final shipment in _shipments) {
      minLat = math.min(minLat, shipment['currentLat']);
      maxLat = math.max(maxLat, shipment['currentLat']);
      minLng = math.min(minLng, shipment['currentLng']);
      maxLng = math.max(maxLng, shipment['currentLng']);
    }
    
    setState(() {
      _mapCenterLat = (minLat + maxLat) / 2;
      _mapCenterLng = (minLng + maxLng) / 2;
      _zoomLevel = 6.0;
    });
  }
}

class MapPainter extends CustomPainter {
  final double centerLat;
  final double centerLng;
  final double zoomLevel;
  final List<Map<String, dynamic>> shipments;
  final String? selectedShipmentId;
  final double animationValue;
  final double pulseValue;
  final directions.RouteInfo? routeInfo;

  MapPainter({
    required this.centerLat,
    required this.centerLng,
    required this.zoomLevel,
    required this.shipments,
    this.selectedShipmentId,
    required this.animationValue,
    required this.pulseValue,
    this.routeInfo,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawGrid(canvas, size);
    _drawRoute(canvas, size);
    _drawShipments(canvas, size);
    _drawLegend(canvas, size);
  }

  void _drawBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.blue[100]!,
          Colors.green[50]!,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    const gridSpacing = 50.0;
    
    for (double x = 0; x <= size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    for (double y = 0; y <= size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawRoute(Canvas canvas, Size size) {
    if (routeInfo == null) return;

    final routePaint = Paint()
      ..color = AppTheme.primaryMedium
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final routeBorderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path routePath = Path();
    bool isFirst = true;

    for (final point in routeInfo!.polylinePoints) {
      final screenPos = _latLngToScreen(point.latitude, point.longitude, size);
      
      if (isFirst) {
        routePath.moveTo(screenPos.dx, screenPos.dy);
        isFirst = false;
      } else {
        routePath.lineTo(screenPos.dx, screenPos.dy);
      }
    }

    // Dibujar borde blanco primero
    canvas.drawPath(routePath, routeBorderPaint);
    // Luego la línea de color
    canvas.drawPath(routePath, routePaint);

    // Dibujar puntos de inicio y fin
    if (routeInfo!.polylinePoints.isNotEmpty) {
      final startPoint = routeInfo!.polylinePoints.first;
      final endPoint = routeInfo!.polylinePoints.last;
      
      final startPos = _latLngToScreen(startPoint.latitude, startPoint.longitude, size);
      final endPos = _latLngToScreen(endPoint.latitude, endPoint.longitude, size);

      // Punto de inicio (verde)
      final startPaint = Paint()..color = AppTheme.success;
      canvas.drawCircle(Offset(startPos.dx, startPos.dy), 8, startPaint);
      
      // Punto final (rojo)
      final endPaint = Paint()..color = AppTheme.error;
      canvas.drawCircle(Offset(endPos.dx, endPos.dy), 8, endPaint);
    }
  }

  void _drawShipments(Canvas canvas, Size size) {
    for (final shipment in shipments) {
      final position = _latLngToScreen(
        shipment['currentLat'],
        shipment['currentLng'],
        size,
      );

      final isSelected = shipment['id'] == selectedShipmentId;
      final baseRadius = isSelected ? 20.0 : 15.0;
      final pulseRadius = baseRadius + (pulseValue * 10);

      // Efecto de pulso para envío seleccionado
      if (isSelected) {
        final pulsePaint = Paint()
          ..color = shipment['statusColor'].withOpacity(0.3 * (1 - pulseValue))
          ..style = PaintingStyle.fill;
        canvas.drawCircle(position, pulseRadius, pulsePaint);
      }

      // Círculo de fondo blanco
      final backgroundPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(position, baseRadius + 2, backgroundPaint);

      // Círculo principal
      final shipmentPaint = Paint()
        ..color = shipment['statusColor']
        ..style = PaintingStyle.fill;
      canvas.drawCircle(position, baseRadius, shipmentPaint);

      // Icono del envío
      _drawShipmentIcon(canvas, position, isSelected);

      // Etiqueta con ID
      _drawShipmentLabel(canvas, position, shipment['id'], baseRadius);
    }
  }

  void _drawShipmentIcon(Canvas canvas, Offset position, bool isSelected) {
    final iconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const iconSize = 8.0;
    final iconRect = Rect.fromCenter(
      center: position,
      width: iconSize * 2,
      height: iconSize,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(iconRect, const Radius.circular(2)),
      iconPaint,
    );
  }

  void _drawShipmentLabel(Canvas canvas, Offset position, String label, double radius) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: AppTheme.primaryDark,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    final labelPosition = Offset(
      position.dx - textPainter.width / 2,
      position.dy + radius + 8,
    );

    // Fondo semi-transparente para la etiqueta
    final labelBg = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;
    
    final labelRect = Rect.fromLTWH(
      labelPosition.dx - 4,
      labelPosition.dy - 2,
      textPainter.width + 8,
      textPainter.height + 4,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(labelRect, const Radius.circular(4)),
      labelBg,
    );
    
    textPainter.paint(canvas, labelPosition);
  }

  void _drawLegend(Canvas canvas, Size size) {
    final legendPaint = Paint()
      ..color = Colors.white.withOpacity(0.95)
      ..style = PaintingStyle.fill;

    const legendWidth = 160.0;
    const legendHeight = 120.0;
    const margin = 16.0;

    final legendRect = Rect.fromLTWH(
      margin,
      size.height - legendHeight - margin,
      legendWidth,
      legendHeight,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(legendRect, const Radius.circular(8)),
      legendPaint,
    );

    // Border
    final borderPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(
      RRect.fromRectAndRadius(legendRect, const Radius.circular(8)),
      borderPaint,
    );

    // Título de la leyenda
    final titlePainter = TextPainter(
      text: const TextSpan(
        text: 'Leyenda',
        style: TextStyle(
          color: AppTheme.primaryDark,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    titlePainter.layout();
    titlePainter.paint(canvas, Offset(margin + 8, legendRect.top + 8));

    // Elementos de la leyenda
    const itemHeight = 16.0;
    double currentY = legendRect.top + 28;

    _drawLegendItem(canvas, Offset(margin + 8, currentY), AppTheme.info, 'En tránsito');
    currentY += itemHeight;
    _drawLegendItem(canvas, Offset(margin + 8, currentY), AppTheme.success, 'Entregado');
    currentY += itemHeight;
    _drawLegendItem(canvas, Offset(margin + 8, currentY), AppTheme.warning, 'En bodega');
    currentY += itemHeight;
    _drawLegendItem(canvas, Offset(margin + 8, currentY), AppTheme.error, 'Retraso');
  }

  void _drawLegendItem(Canvas canvas, Offset position, Color color, String text) {
    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(position.dx + 6, position.dy + 6), 4, circlePaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: AppTheme.primaryDark,
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(position.dx + 18, position.dy + 2));
  }

  Offset _latLngToScreen(double lat, double lng, Size screenSize) {
    final double latRange = 180.0 / math.pow(2, zoomLevel - 1);
    final double lngRange = 360.0 / math.pow(2, zoomLevel - 1);
    
    final double x = ((lng - (centerLng - lngRange / 2)) / lngRange) * screenSize.width;
    final double y = (((centerLat + latRange / 2) - lat) / latRange) * screenSize.height;
    
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}