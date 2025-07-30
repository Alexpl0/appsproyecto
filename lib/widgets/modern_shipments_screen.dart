import 'package:flutter/material.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';
import 'package:rastreo_app/theme/app_theme.dart';
import 'dart:math' as math;

class ModernShipmentsScreen extends StatefulWidget {
  const ModernShipmentsScreen({super.key});

  @override
  State<ModernShipmentsScreen> createState() => _ModernShipmentsScreenState();
}

class _ModernShipmentsScreenState extends State<ModernShipmentsScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String _selectedFilter = 'all';
  bool _showFilters = false;

  // Datos simulados de envíos
  final List<Map<String, dynamic>> _allShipments = [
    {
      'id': '1',
      'product': 'Vino Tinto Reserva',
      'recipient': 'Juan Pérez',
      'trackingNumber': 'ABC123',
      'status': 'inTransit',
      'priority': 'high',
      'progress': 0.5,
    },
    {
      'id': '2',
      'product': 'Tequila Premium',
      'recipient': 'Ana López',
      'trackingNumber': 'DEF456',
      'status': 'delivered',
      'priority': 'medium',
      'progress': 1.0,
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
        actions: [
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
                Center(child: Text(localizations.inTransit)),
                Center(child: Text(localizations.delivered)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: [
          Tab(text: 'All'), // Replace with a valid string or getter
          Tab(text: localizations.inTransit),
          Tab(text: localizations.delivered),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(AppLocalizations localizations, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search shipments', // Replace with a valid string or getter
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          if (_showFilters)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _showFilters = false;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildShipmentsList(AppLocalizations localizations, ThemeData theme) {
    if (_filteredShipments.isEmpty) {
      return Center(
        child: Text('No shipments found'), // Replace with a valid string or getter
      );
    }
    return ListView.builder(
      itemCount: _filteredShipments.length,
      itemBuilder: (context, index) {
        final shipment = _filteredShipments[index];
        return _buildShipmentCard(theme, shipment);
      },
    );
  }

  Widget _buildShipmentCard(ThemeData theme, Map<String, dynamic> shipment) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(shipment['product']),
        subtitle: Text('${shipment['recipient']} - ${shipment['trackingNumber']}'),
        trailing: _buildPriorityChip(shipment['priority']),
        onTap: () {
          _showShipmentDetails(context, shipment);
        },
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
      label: Text(priority),
      backgroundColor: color,
    );
  }

  void _showShipmentDetails(BuildContext context, Map<String, dynamic> shipment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(shipment['product']),
          content: Text('Detalles del envío: ${shipment['trackingNumber']}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}