import 'package:flutter/material.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class ModernShipmentsScreen extends StatefulWidget {
  const ModernShipmentsScreen({super.key});

  @override
  State<ModernShipmentsScreen> createState() => _ModernShipmentsScreenState();
}

class _ModernShipmentsScreenState extends State<ModernShipmentsScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  final String _selectedFilter = 'all';
  bool _showFilters = false;

  // Datos simulados de envíos mejorados
  final List<Map<String, dynamic>> _allShipments = [
    {
      'id': 'SH001',
      'product': 'Vino Tinto Reserva',
      'recipient': 'Juan Pérez',
      'trackingNumber': 'VTR-2024-001',
      'status': 'inTransit',
      'priority': 'high',
      'progress': 0.65,
      'origin': 'Guadalajara, JAL',
      'destination': 'Ciudad de México, CDMX',
      'estimatedDelivery': '29 Enero 2024',
      'currentLocation': 'En ruta - Querétaro',
      'temperature': '18.5°C',
      'humidity': '65%',
      'statusColor': Colors.orange,
      'statusText': 'En Tránsito',
      'deliveryInstructions': 'Entregar en recepción del edificio',
      'weight': '2.5 kg',
      'dimensions': '30x20x15 cm',
      'value': '\$1,250.00 MXN',
    },
    {
      'id': 'SH002',
      'product': 'Tequila Premium',
      'recipient': 'Ana López',
      'trackingNumber': 'TPR-2024-002',
      'status': 'delivered',
      'priority': 'medium',
      'progress': 1.0,
      'origin': 'Guadalajara, JAL',
      'destination': 'Ciudad de México, CDMX',
      'estimatedDelivery': '28 Enero 2024',
      'currentLocation': 'Entregado',
      'temperature': '20.1°C',
      'humidity': '58%',
      'statusColor': Colors.green,
      'statusText': 'Entregado',
      'deliveryInstructions': 'Entregado al destinatario',
      'weight': '1.8 kg',
      'dimensions': '25x15x30 cm',
      'value': '\$2,100.00 MXN',
    },
    {
      'id': 'SH003',
      'product': 'Cerveza Artesanal',
      'recipient': 'Hotel Paradise',
      'trackingNumber': 'CA-2024-003',
      'status': 'pending',
      'priority': 'low',
      'progress': 0.15,
      'origin': 'Monterrey, NL',
      'destination': 'Cancún, QR',
      'estimatedDelivery': '31 Enero 2024',
      'currentLocation': 'En bodega - Monterrey',
      'temperature': '15.3°C',
      'humidity': '72%',
      'statusColor': Colors.blue,
      'statusText': 'En Bodega',
      'deliveryInstructions': 'Coordinar con gerente del hotel',
      'weight': '12.0 kg',
      'dimensions': '40x30x25 cm',
      'value': '\$3,500.00 MXN',
    },
  ];

  List<Map<String, dynamic>> _filteredShipments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredShipments = _allShipments;
    _searchController.addListener(_filterShipments);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _filterShipments() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      _filteredShipments = _allShipments.where((shipment) {
        if (_selectedFilter != 'all' && shipment['status'] != _selectedFilter) {
          return false;
        }
        if (query.isEmpty) return true;
        return shipment['id'].toLowerCase().contains(query) ||
            shipment['product'].toLowerCase().contains(query) ||
            shipment['recipient'].toLowerCase().contains(query) ||
            shipment['trackingNumber'].toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.shipments),
        backgroundColor: AppTheme.primaryDark,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              // Navegar al mapa mostrando todos los envíos
              Navigator.pushNamed(
                context,
                '/map',
                arguments: {'showAllShipments': true},
              );
            },
          ),
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list : Icons.filter_list_outlined),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(localizations, theme),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildShipmentsList(localizations, theme),
                _buildFilteredShipmentsList('inTransit', localizations, theme),
                _buildFilteredShipmentsList('delivered', localizations, theme),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: AppTheme.primaryDark,
        child: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            const Tab(text: 'Todos'),
            Tab(text: localizations.inTransit),
            Tab(text: localizations.delivered),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(AppLocalizations localizations, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar envíos...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.primaryMedium),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          if (_showFilters) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.close, color: AppTheme.primaryMedium),
              onPressed: () {
                setState(() {
                  _showFilters = false;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShipmentsList(AppLocalizations localizations, ThemeData theme) {
    if (_filteredShipments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No se encontraron envíos',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _filteredShipments.length,
      itemBuilder: (context, index) {
        final shipment = _filteredShipments[index];
        return _buildShipmentCard(theme, shipment);
      },
    );
  }

  Widget _buildFilteredShipmentsList(String status, AppLocalizations localizations, ThemeData theme) {
    final filteredByStatus = _allShipments.where((s) => s['status'] == status).toList();
    
    if (filteredByStatus.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              status == 'delivered' ? Icons.check_circle : Icons.local_shipping,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              status == 'delivered' ? 'No hay envíos entregados' : 'No hay envíos en tránsito',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filteredByStatus.length,
      itemBuilder: (context, index) {
        final shipment = filteredByStatus[index];
        return _buildShipmentCard(theme, shipment);
      },
    );
  }

  Widget _buildShipmentCard(ThemeData theme, Map<String, dynamic> shipment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showEnhancedShipmentDetails(context, shipment),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: shipment['statusColor'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.local_shipping,
                      color: shipment['statusColor'],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shipment['id'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                        Text(
                          shipment['product'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
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
                      shipment['statusText'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(shipment['recipient']),
                  const Spacer(),
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(shipment['currentLocation']),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: shipment['progress'],
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(shipment['statusColor']),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Entrega: ${shipment['estimatedDelivery']}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  Text(
                    '${(shipment['progress'] * 100).toInt()}% completado',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: shipment['statusColor'],
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

  Widget _buildPriorityChip(String priority) {
    Color color;
    switch (priority) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'low':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(
        priority.toUpperCase(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  void _showEnhancedShipmentDetails(BuildContext context, Map<String, dynamic> shipment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: shipment['statusColor'].withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: shipment['statusColor'].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.local_shipping,
                      color: shipment['statusColor'],
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shipment['id'],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                        Text(
                          shipment['product'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: shipment['statusColor'],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      shipment['statusText'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Progress bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progreso del envío',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                      Text(
                        '${(shipment['progress'] * 100).toInt()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: shipment['statusColor'],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: shipment['progress'],
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(shipment['statusColor']),
                    minHeight: 8,
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Actions
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            'Ver en Mapa',
                            Icons.map,
                            AppTheme.primaryMedium,
                            () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                context,
                                '/map',
                                arguments: {'shipmentId': shipment['id']},
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            'Contactar',
                            Icons.phone,
                            AppTheme.accent,
                            () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/support-chat');
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Shipment Details
                    _buildDetailSection('Información del Envío', [
                      _buildDetailRow('Número de seguimiento', shipment['trackingNumber']),
                      _buildDetailRow('Destinatario', shipment['recipient']),
                      _buildDetailRow('Origen', shipment['origin']),
                      _buildDetailRow('Destino', shipment['destination']),
                      _buildDetailRow('Ubicación actual', shipment['currentLocation']),
                      _buildDetailRow('Entrega estimada', shipment['estimatedDelivery']),]
                    ),

                    const SizedBox(height: 16),

                    // Package Details
                    _buildDetailSection('Detalles del Paquete', [
                      _buildDetailRow('Peso', shipment['weight']),
                      _buildDetailRow('Dimensiones', shipment['dimensions']),
                      _buildDetailRow('Valor declarado', shipment['value']),
                      _buildDetailRow('Instrucciones', shipment['deliveryInstructions']),]
                    ),

                    const SizedBox(height: 16),

                    // Environmental Conditions
                    _buildDetailSection('Condiciones Ambientales', [
                      _buildDetailRow('Temperatura', shipment['temperature']),
                      _buildDetailRow('Humedad', shipment['humidity']),
                    ],),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> details) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 12),
          ...details,
        ],
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
            width: 140,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryDark,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}