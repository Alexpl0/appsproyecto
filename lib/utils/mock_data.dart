import 'package:rastreo_app/models/envio_model.dart';
import 'package:rastreo_app/utils/assets.dart';

/// Proporciona datos de ejemplo para la aplicación.
class MockData {
  static List<Envio> getMockEnvios() {
    return [
      Envio(
        id: '001',
        producto: 'Vino Tinto',
        cantidad: 50,
        nombrePropietario: 'Carlos Pérez',
        imagenUrl: AppAssets.vino,
        tipoTransporte: 'Aéreo',
        estado: 'En vuelo',
        destino: 'Seattle, WA',
        fechaEstimada: '2025-03-25',
        horaEstimada: '14:30',
      ),
      Envio(
        id: '002',
        producto: 'Tequila',
        cantidad: 30,
        nombrePropietario: 'Ana Gómez',
        imagenUrl: AppAssets.tequila,
        tipoTransporte: 'Aéreo',
        estado: 'Aterrizando',
        destino: 'Los Ángeles, CA',
        fechaEstimada: '2025-03-24',
        horaEstimada: '18:00',
      ),
      Envio(
        id: '007',
        producto: 'Mezcal',
        cantidad: 20,
        nombrePropietario: 'Fernando Cruz',
        imagenUrl: AppAssets.mezcal,
        tipoTransporte: 'Terrestre',
        estado: 'En ruta',
        destino: 'Guadalajara, MX',
        fechaEstimada: '2025-03-23',
        horaEstimada: '16:00',
      ),
      Envio(
        id: '008',
        producto: 'Vodka',
        cantidad: 100,
        nombrePropietario: 'Sofía Herrera',
        imagenUrl: AppAssets.vodka,
        tipoTransporte: 'Terrestre',
        estado: 'Entregado',
        destino: 'Monterrey, MX',
        fechaEstimada: '2025-03-22',
        horaEstimada: '12:00',
      ),
    ];
  }
}
