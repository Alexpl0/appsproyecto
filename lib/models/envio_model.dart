/// Representa un envío con todos sus detalles.
/// Este modelo unifica la información que antes estaba dispersa.
class Envio {
  final String id;
  final String producto;
  final int cantidad;
  final String nombrePropietario;
  final String imagenUrl;
  final String tipoTransporte; // 'Aéreo' o 'Terrestre'
  final String estado; // 'En vuelo', 'En ruta', 'Entregado', etc.
  final String destino;
  final String fechaEstimada;
  final String horaEstimada;

  Envio({
    required this.id,
    required this.producto,
    required this.cantidad,
    required this.nombrePropietario,
    required this.imagenUrl,
    required this.tipoTransporte,
    required this.estado,
    required this.destino,
    required this.fechaEstimada,
    required this.horaEstimada,
  });
}
