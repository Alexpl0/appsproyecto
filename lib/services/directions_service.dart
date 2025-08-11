import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importa dotenv

class DirectionsService {
  static final String _apiKey = dotenv.env['AIzaSyDR58usOw4ZjCjvn8d8UgVUcCDLORC_SOk'] ?? ''; // Carga la API Key
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';

  Future<RouteInfo> getRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String mode = 'driving',
    bool alternatives = false,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception('API Key no configurada. Verifica tu archivo .env');
    }

    try {
      final uri = Uri.parse(
        '$_baseUrl?origin=$originLat,$originLng&destination=$destLat,$destLng'
        '&mode=$mode&alternatives=$alternatives&key=$_apiKey&language=es',
      );

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Error API: ${response.statusCode}');
      }

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (data['status'] != 'OK') {
        throw Exception('Directions API Error: ${data['status']}');
      }

      final routes = data['routes'] as List;
      if (routes.isEmpty) {
        throw Exception('No se encontraron rutas');
      }

      final route = routes.first as Map<String, dynamic>;
      final leg = (route['legs'] as List).first as Map<String, dynamic>;

      return RouteInfo(
        polylinePoints: _decodePolyline(route['overview_polyline']['points']),
        distance: leg['distance']['text'],
        duration: leg['duration']['text'],
        distanceValue: leg['distance']['value'],
        durationValue: leg['duration']['value'],
        startAddress: leg['start_address'],
        endAddress: leg['end_address'],
        steps: (leg['steps'] as List).map((step) => RouteStep(
          instruction: step['html_instructions'].toString().replaceAll(RegExp(r'<[^>]*>'), ''),
          distance: step['distance']['text'],
          duration: step['duration']['text'],
          startLat: step['start_location']['lat'],
          startLng: step['start_location']['lng'],
          endLat: step['end_location']['lat'],
          endLng: step['end_location']['lng'],
        )).toList(),
      );
    } catch (e) {
      throw Exception('Error obteniendo ruta: $e');
    }
  }

  // Decodifica polyline de Google (algoritmo estándar)
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  // Método simulado para modo offline/testing
  Future<RouteInfo> getSimulatedRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) async {
    // Simula latencia de red
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Genera puntos intermedios simulados
    List<LatLng> points = [];
    int segments = 8;
    
    for (int i = 0; i <= segments; i++) {
      double ratio = i / segments;
      double lat = originLat + (destLat - originLat) * ratio;
      double lng = originLng + (destLng - originLng) * ratio;
      
      // Añade variación para simular carreteras reales
      if (i > 0 && i < segments) {
        lat += (Random().nextDouble() - 0.5) * 0.01;
        lng += (Random().nextDouble() - 0.5) * 0.01;
      }
      
      points.add(LatLng(lat, lng));
    }

    double distance = _calculateDistance(originLat, originLng, destLat, destLng);
    int estimatedMinutes = (distance * 60 / 50).round(); // ~50 km/h promedio

    return RouteInfo(
      polylinePoints: points,
      distance: '${distance.toStringAsFixed(1)} km',
      duration: '$estimatedMinutes min',
      distanceValue: (distance * 1000).round(),
      durationValue: estimatedMinutes * 60,
      startAddress: 'Punto de origen',
      endAddress: 'Punto de destino',
      steps: [
        RouteStep(
          instruction: 'Dirigirse hacia el destino',
          distance: '${distance.toStringAsFixed(1)} km',
          duration: '$estimatedMinutes min',
          startLat: originLat,
          startLng: originLng,
          endLat: destLat,
          endLng: destLng,
        ),
      ],
    );
  }

  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371; // Radio de la Tierra en km
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLng = _degreesToRadians(lng2 - lng1);
    
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
        sin(dLng / 2) * sin(dLng / 2);
    
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}

class RouteInfo {
  final List<LatLng> polylinePoints;
  final String distance;
  final String duration;
  final int distanceValue;
  final int durationValue;
  final String startAddress;
  final String endAddress;
  final List<RouteStep> steps;

  RouteInfo({
    required this.polylinePoints,
    required this.distance,
    required this.duration,
    required this.distanceValue,
    required this.durationValue,
    required this.startAddress,
    required this.endAddress,
    required this.steps,
  });
}

class RouteStep {
  final String instruction;
  final String distance;
  final String duration;
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;

  RouteStep({
    required this.instruction,
    required this.distance,
    required this.duration,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
  });
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);

  @override
  String toString() => 'LatLng($latitude, $longitude)';
}