import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';
import 'package:rastreo_app/models/historial_model.dart';

/// Pantalla para mostrar y buscar el historial de pedidos.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Datos de ejemplo. En una app real, vendrían de una API.
  final List<HistorialPedido> _allPedidos = [
    HistorialPedido(
      id: '001',
      propietario: 'Carlos Pérez',
      checkpoints: [
        Checkpoint(nombre: 'Entrega al aeropuerto', status: 'Completado', hora: '10:30 AM', ubicacion: 'Aeropuerto JFK'),
        Checkpoint(nombre: 'En tránsito aéreo', status: 'Completado', hora: '12:00 PM', ubicacion: 'En Vuelo'),
        Checkpoint(nombre: 'Llegada a destino', status: 'En Tránsito', hora: '08:00 PM', ubicacion: 'Aeropuerto LAX'),
        Checkpoint(nombre: 'Entrega final', status: 'Pendiente', hora: 'N/A', ubicacion: 'Almacén LA'),
      ],
    ),
    HistorialPedido(
      id: '007',
      propietario: 'Fernando Cruz',
      checkpoints: [
        Checkpoint(nombre: 'Recolección en origen', status: 'Completado', hora: '09:00 AM', ubicacion: 'CDMX'),
        Checkpoint(nombre: 'En ruta terrestre', status: 'En Tránsito', hora: '11:00 AM', ubicacion: 'Carretera 57D'),
        Checkpoint(nombre: 'Llegada a almacén', status: 'Pendiente', hora: 'N/A', ubicacion: 'Guadalajara, MX'),
      ],
    ),
     HistorialPedido(
      id: '008',
      propietario: 'Sofía Herrera',
      checkpoints: [
        Checkpoint(nombre: 'Recolección', status: 'Completado', hora: '10:00 AM', ubicacion: 'Origen'),
        Checkpoint(nombre: 'Entrega', status: 'Completado', hora: '04:00 PM', ubicacion: 'Monterrey, MX'),
      ],
    ),
  ];

  late List<HistorialPedido> _filteredPedidos;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredPedidos = _allPedidos;
    _searchController.addListener(_filterPedidos);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterPedidos);
    _searchController.dispose();
    super.dispose();
  }

  void _filterPedidos() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPedidos = _allPedidos.where((pedido) {
        return pedido.id.toLowerCase().contains(query) ||
               pedido.propietario.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Barra de Búsqueda ---
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: localizations.searchByOrderId,
                prefixIcon: const Icon(Icons.search),
              ),
            ).animate().fadeIn(duration: 300.ms),

            const SizedBox(height: 20),

            // --- Lista de Pedidos ---
            Expanded(
              child: _filteredPedidos.isEmpty
                  ? Center(child: Text(localizations.noOrdersFound))
                  : ListView.builder(
                      itemCount: _filteredPedidos.length,
                      itemBuilder: (context, index) {
                        final pedido = _filteredPedidos[index];
                        return _buildHistoryCard(pedido, theme, localizations)
                            .animate()
                            .fadeIn(delay: (100 * index).ms)
                            .slideY(begin: 0.2);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye la tarjeta expandible para cada historial de pedido.
  Widget _buildHistoryCard(HistorialPedido pedido, ThemeData theme, AppLocalizations localizations) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          localizations.orderId(pedido.id),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(localizations.owner(pedido.propietario)),
        children: [
          const Divider(height: 1),
          ...pedido.checkpoints.map((cp) => _buildCheckpointTile(cp, theme)),
        ],
      ),
    );
  }

  /// Construye la fila para cada checkpoint dentro de la tarjeta.
  Widget _buildCheckpointTile(Checkpoint checkpoint, ThemeData theme) {
    final Color statusColor = _getStatusColor(checkpoint.status, theme);
    final IconData statusIcon = _getStatusIcon(checkpoint.status);

    return ListTile(
      leading: Icon(statusIcon, color: statusColor),
      title: Text(checkpoint.nombre),
      subtitle: Text("${checkpoint.ubicacion} - ${checkpoint.hora}"),
      trailing: Text(
        checkpoint.status,
        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Devuelve un color basado en el estado del checkpoint.
  Color _getStatusColor(String status, ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'completado':
        return Colors.green.shade600;
      case 'en tránsito':
        return Colors.orange.shade600;
      case 'pendiente':
        return Colors.grey.shade600;
      default:
        return theme.colorScheme.onSurface;
    }
  }

  /// Devuelve un ícono basado en el estado del checkpoint.
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completado':
        return Icons.check_circle;
      case 'en tránsito':
        return Icons.sync;
      case 'pendiente':
        return Icons.pending_actions;
      default:
        return Icons.help_outline;
    }
  }
}
