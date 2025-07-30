/// Representa un punto de control en el historial de un envío.
class Checkpoint {
  final String nombre;
  final String status; // 'Completado', 'En Tránsito', 'Pendiente'
  final String hora;
  final String ubicacion;

  Checkpoint({
    required this.nombre,
    required this.status,
    required this.hora,
    required this.ubicacion,
  });
}

/// Representa el historial completo de un pedido, compuesto por varios checkpoints.
class HistorialPedido {
  final String id;
  final String propietario;
  final List<Checkpoint> checkpoints;

  HistorialPedido({
    required this.id,
    required this.propietario,
    required this.checkpoints,
  });
}
