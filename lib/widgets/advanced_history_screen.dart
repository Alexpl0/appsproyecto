import 'package:flutter/material.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';
import 'package:rastreo_app/theme/app_theme.dart';
import 'dart:math' as math;

class AdvancedHistoryScreen extends StatefulWidget {
  const AdvancedHistoryScreen({super.key});

  @override
  State<AdvancedHistoryScreen> createState() => _AdvancedHistoryScreenState();
}

class _AdvancedHistoryScreenState extends State<AdvancedHistoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeRange = 'thisWeek';
  String _selectedMetric = 'deliveries';
  
  // Datos simulados para analytics
  final Map<String, List<Map<String, dynamic>>> _analyticsData = {
    'thisWeek': [
      {'day': 'Lun', 'deliveries': 15, 'onTime': 14, 'delayed': 1, 'revenue': 4500},
      {'day': 'Mar', 'deliveries': 18, 'onTime': 16, 'delayed': 2, 'revenue': 5400},
      {'day': 'Mié', 'deliveries': 22, 'onTime': 20, 'delayed': 2, 'revenue': 6600},
      {'day': 'Jue', 'deliveries': 19, 'onTime': 18, 'delayed': 1, 'revenue': 5700},
      {'day': 'Vie', 'deliveries': 25, 'onTime': 23, 'delayed': 2, 'revenue': 7500},
      {'day': 'Sáb', 'deliveries': 12, 'onTime': 11, 'delayed': 1, 'revenue': 3600},
      {'day': 'Dom', 'deliveries': 8, 'onTime': 8, 'delayed': 0, 'revenue': 2400},
    ],
    'thisMonth': [
      {'week': 'Sem 1', 'deliveries': 85, 'onTime': 78, 'delayed': 7, 'revenue': 25500},
      {'week': 'Sem 2', 'deliveries': 92, 'onTime': 86, 'delayed': 6, 'revenue': 27600},
      {'week': 'Sem 3', 'deliveries': 88, 'onTime': 82, 'delayed': 6, 'revenue': 26400},
      {'week': 'Sem 4', 'deliveries': 95, 'onTime': 90, 'delayed': 5, 'revenue': 28500},
    ],
  };

  final List<Map<String, dynamic>> _recentHistory = [
    {
      'id': 'SH001',
      'product': 'Vino Tinto Reserva',
      'status': 'delivered',
      'deliveryTime': '2 días',
      'customer': 'Juan Pérez',
      'value': 450.0,
      'rating': 5,
      'date': '2024-01-28',
      'route': 'GDL → CDMX',
      'driver': 'Carlos López',
      'category': 'premium',
    },
    {
      'id': 'SH002',
      'product': 'Tequila Premium',
      'status': 'delivered',
      'deliveryTime': '1.5 días',
      'customer': 'María González',
      'value': 320.0,
      'rating': 4,
      'date': '2024-01-27',
      'route': 'TEQ → MTY',
      'driver': 'Ana Ruiz',
      'category': 'standard',
    },
    {
      'id': 'SH003',
      'product': 'Whisky Escocés',
      'status': 'delayed',
      'deliveryTime': '3.2 días',
      'customer': 'Roberto Silva',
      'value': 890.0,
      'rating': 3,
      'date': '2024-01-26',
      'route': 'TIJ → CUN',
      'driver': 'Luis Mendoza',
      'category': 'premium',
    },
    {
      'id': 'SH004',
      'product': 'Cerveza Artesanal',
      'status': 'delivered',
      'deliveryTime': '1 día',
      'customer': 'Ana López',
      'value': 150.0,
      'rating': 5,
      'date': '2024-01-25',
      'route': 'PUE → QRO',
      'driver': 'Pedro Jiménez',
      'category': 'standard',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // 📊 Header con métricas principales
          _buildAnalyticsHeader(localizations, theme),
          
          // 📱 Tabs de navegación
          _buildTabBar(localizations, theme),
          
          // 📄 Contenido de las tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(localizations, theme),
                _buildChartsTab(localizations, theme),
                _buildHistoryTab(localizations, theme),
                _buildReportsTab(localizations, theme),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showExportModal(context, localizations),
        icon: const Icon(Icons.download),
        label: Text(localizations.export),
        backgroundColor: AppTheme.primaryMedium,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildAnalyticsHeader(AppLocalizations localizations, ThemeData theme) {
    final weekData = _analyticsData['thisWeek']!;
    final totalDeliveries = weekData.fold<int>(0, (sum, day) => sum + (day['deliveries'] as int));
    final totalOnTime = weekData.fold<int>(0, (sum, day) => sum + (day['onTime'] as int));
    final totalRevenue = weekData.fold<double>(0, (sum, day) => sum + (day['revenue'] as int));
    final onTimePercentage = totalDeliveries > 0 ? (totalOnTime / totalDeliveries * 100) : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryMedium.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.analytics,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Resumen de la semana',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              _buildTimeRangeSelector(),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildHeaderMetric(
                  icon: Icons.local_shipping,
                  label: 'Entregas',
                  value: totalDeliveries.toString(),
                  change: '+12%',
                  isPositive: true,
                ),
              ),
              Expanded(
                child: _buildHeaderMetric(
                  icon: Icons.schedule,
                  label: 'A Tiempo',
                  value: '${onTimePercentage.toInt()}%',
                  change: '+5%',
                  isPositive: true,
                ),
              ),
              Expanded(
                child: _buildHeaderMetric(
                  icon: Icons.attach_money,
                  label: 'Ingresos',
                  value: '\$${(totalRevenue / 1000).toStringAsFixed(1)}k',
                  change: '+8%',
                  isPositive: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTimeRange,
          dropdownColor: AppTheme.primaryDark,
          style: const TextStyle(color: Colors.white),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          items: const [
            DropdownMenuItem(value: 'thisWeek', child: Text('Esta Semana')),
            DropdownMenuItem(value: 'thisMonth', child: Text('Este Mes')),
            DropdownMenuItem(value: 'lastMonth', child: Text('Mes Pasado')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedTimeRange = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildHeaderMetric({
    required IconData icon,
    required String label,
    required String value,
    required String change,
    required bool isPositive,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: (isPositive ? Colors.green : Colors.red).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            change,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(AppLocalizations localizations, ThemeData theme) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppTheme.primaryMedium,
        labelColor: AppTheme.primaryMedium,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        tabs: [
          const Tab(text: 'Resumen'),
          const Tab(text: 'Gráficos'),
          Tab(text: localizations.history),
          Tab(text: localizations.reports),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(AppLocalizations localizations, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPIs principales
          _buildKPIGrid(localizations, theme),
          
          const SizedBox(height: 24),
          
          // Gráfico de tendencias
          _buildTrendsChart(localizations, theme),
          
          const SizedBox(height: 24),
          
          // Top productos
          _buildTopProducts(localizations, theme),
          
          const SizedBox(height: 24),
          
          // Rendimiento por ruta
          _buildRoutePerformance(localizations, theme),
        ],
      ),
    );
  }

  Widget _buildKPIGrid(AppLocalizations localizations, ThemeData theme) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildKPICard(
          title: 'Tiempo Promedio',
          value: '2.1',
          unit: 'días',
          icon: Icons.access_time,
          color: AppTheme.info,
          trend: -0.3,
        ),
        _buildKPICard(
          title: 'Satisfacción',
          value: '4.7',
          unit: '/5',
          icon: Icons.star,
          color: AppTheme.warning,
          trend: 0.2,
        ),
        _buildKPICard(
          title: 'Eficiencia',
          value: '94',
          unit: '%',
          icon: Icons.trending_up,
          color: AppTheme.success,
          trend: 2.1,
        ),
        _buildKPICard(
          title: 'Costo Promedio',
          value: '287',
          unit: '\$',
          icon: Icons.attach_money,
          color: AppTheme.accent,
          trend: -15.0,
        ),
      ],
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
    required double trend,
  }) {
    final isPositive = trend > 0;
    final isNeutral = trend == 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              if (!isNeutral)
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          if (!isNeutral) ...[
            const SizedBox(height: 4),
            Text(
              '${isPositive ? '+' : ''}${trend.toStringAsFixed(1)}% vs anterior',
              style: TextStyle(
                fontSize: 10,
                color: isPositive ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrendsChart(AppLocalizations localizations, ThemeData theme) {
    final data = _analyticsData[_selectedTimeRange]!;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Text(
                localizations.trends,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
              const Spacer(),
              _buildMetricSelector(),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((item) {
                final value = item[_selectedMetric] as int;
                final maxValue = data.map((e) => e[_selectedMetric] as int).reduce(math.max);
                final height = (value / maxValue) * 140;
                final label = _selectedTimeRange == 'thisWeek' 
                    ? item['day'] as String
                    : item['week'] as String;
                
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: height,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppTheme.primaryMedium,
                                AppTheme.accent,
                              ],
                            ),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              value.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedMetric,
          style: const TextStyle(color: AppTheme.primaryDark, fontSize: 12),
          items: const [
            DropdownMenuItem(value: 'deliveries', child: Text('Entregas')),
            DropdownMenuItem(value: 'onTime', child: Text('A Tiempo')),
            DropdownMenuItem(value: 'revenue', child: Text('Ingresos')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedMetric = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTopProducts(AppLocalizations localizations, ThemeData theme) {
    final products = [
      {'name': 'Vino Tinto Reserva', 'deliveries': 45, 'revenue': 20250, 'growth': 15.5},
      {'name': 'Tequila Premium', 'deliveries': 38, 'revenue': 12160, 'growth': 8.2},
      {'name': 'Whisky Escocés', 'deliveries': 22, 'revenue': 19580, 'growth': -2.1},
      {'name': 'Cerveza Artesanal', 'deliveries': 67, 'revenue': 10050, 'growth': 22.3},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Productos',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 16),
          ...products.map((product) => _buildProductRow(product)),
        ],
      ),
    );
  }

  Widget _buildProductRow(Map<String, dynamic> product) {
    final growth = product['growth'] as double;
    final isPositive = growth > 0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryMedium.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.inventory,
              color: AppTheme.primaryMedium,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryDark,
                  ),
                ),
                Text(
                  '${product['deliveries']} entregas • \$${product['revenue']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${isPositive ? '+' : ''}${growth.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutePerformance(AppLocalizations localizations, ThemeData theme) {
    final routes = [
      {'route': 'GDL → CDMX', 'avgTime': '2.1 días', 'onTime': 95, 'count': 28},
      {'route': 'TEQ → MTY', 'avgTime': '1.8 días', 'onTime': 87, 'count': 22},
      {'route': 'TIJ → CUN', 'avgTime': '3.2 días', 'onTime': 78, 'count': 15},
      {'route': 'PUE → QRO', 'avgTime': '1.2 días', 'onTime': 98, 'count': 35},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rendimiento por Ruta',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 16),
          ...routes.map((route) => _buildRouteRow(route)),
        ],
      ),
    );
  }

  Widget _buildRouteRow(Map<String, dynamic> route) {
    final onTime = route['onTime'] as int;
    Color performanceColor;
    
    if (onTime >= 90) {
      performanceColor = AppTheme.success;
    } else if (onTime >= 80) {
      performanceColor = AppTheme.warning;
    } else {
      performanceColor = AppTheme.error;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: performanceColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.route,
              color: performanceColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route['route'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryDark,
                  ),
                ),
                Text(
                  '${route['avgTime']} • ${route['count']} envíos',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$onTime%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: performanceColor,
                ),
              ),
              Text(
                'A tiempo',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartsTab(AppLocalizations localizations, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Gráfico circular de estados
          _buildStatusPieChart(localizations, theme),
          
          const SizedBox(height: 24),
          
          // Comparación mensual
          _buildMonthlyComparison(localizations, theme),
          
          const SizedBox(height: 24),
          
          // Heatmap de entregas por hora
          _buildDeliveryHeatmap(localizations, theme),
        ],
      ),
    );
  }

  Widget _buildStatusPieChart(AppLocalizations localizations, ThemeData theme) {
    final statusData = [
      {'status': 'Entregado', 'count': 142, 'color': AppTheme.success},
      {'status': 'En Tránsito', 'count': 28, 'color': AppTheme.info},
      {'status': 'Retrasado', 'count': 12, 'color': AppTheme.error},
      {'status': 'Procesando', 'count': 8, 'color': AppTheme.warning},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribución por Estado',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Simulación de gráfico circular
              Expanded(
                flex: 2,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.surface,
                              AppTheme.accent.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          '190\nTotal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: statusData.map((item) {
                    final percentage = (item['count'] as int) / 190 * 100;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: item['color'] as Color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item['status'] as String,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Text(
                            '${percentage.toInt()}%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyComparison(AppLocalizations localizations, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comparación Mensual',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 20),
          
          // Gráfico de barras comparativo
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'
              ].map((month) {
                final currentMonth = math.Random().nextInt(50) + 50;
                final previousMonth = math.Random().nextInt(40) + 40;
                
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: currentMonth * 2.0,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryMedium,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Container(
                                height: previousMonth * 2.0,
                                decoration: BoxDecoration(
                                  color: AppTheme.accent.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          month,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              _buildLegendItem('Este año', AppTheme.primaryMedium),
              const SizedBox(width: 20),
              _buildLegendItem('Año anterior', AppTheme.accent.withOpacity(0.6)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDeliveryHeatmap(AppLocalizations localizations, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mapa de Calor - Entregas por Hora',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 20),
          
          // Grid de horas
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 12,
              childAspectRatio: 1,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: 24,
            itemBuilder: (context, index) {
              final intensity = math.Random().nextDouble();
              final deliveries = (intensity * 20).toInt();
              
              Color cellColor;
              if (intensity < 0.2) {
                cellColor = AppTheme.surface;
              } else if (intensity < 0.5) {
                cellColor = AppTheme.accent.withOpacity(0.3);
              } else if (intensity < 0.8) {
                cellColor = AppTheme.primaryLight.withOpacity(0.6);
              } else {
                cellColor = AppTheme.primaryMedium;
              }
              
              return Container(
                decoration: BoxDecoration(
                  color: cellColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: intensity > 0.5 ? Colors.white : AppTheme.primaryDark,
                    ),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Text(
                'Menos',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
              ...List.generate(5, (index) {
                final opacity = (index + 1) / 5;
                return Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(right: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryMedium.withOpacity(opacity),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
              const SizedBox(width: 8),
              Text(
                'Más',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(AppLocalizations localizations, ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _recentHistory.length,
      itemBuilder: (context, index) {
        final shipment = _recentHistory[index];
        return _buildHistoryCard(shipment, localizations, theme);
      },
    );
  }

  Widget _buildHistoryCard(
    Map<String, dynamic> shipment,
    AppLocalizations localizations,
    ThemeData theme,
  ) {
    final status = shipment['status'] as String;
    final statusConfig = _getHistoryStatusConfig(status);
    final rating = shipment['rating'] as int;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
                    color: statusConfig['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    statusConfig['icon'],
                    color: statusConfig['color'],
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
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                      Text(
                        shipment['product'],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusConfig['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusConfig['label'],
                    style: TextStyle(
                      color: statusConfig['color'],
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(Icons.person, 'Cliente', shipment['customer']),
                ),
                Expanded(
                  child: _buildInfoRow(Icons.attach_money, 'Valor', '\$${shipment['value']}'),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(Icons.route, 'Ruta', shipment['route']),
                ),
                Expanded(
                  child: _buildInfoRow(Icons.access_time, 'Tiempo', shipment['deliveryTime']),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Icon(Icons.local_shipping, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Conductor: ${shipment['driver']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      size: 16,
                      color: index < rating ? AppTheme.warning : Colors.grey[400],
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
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
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildReportsTab(AppLocalizations localizations, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.reports,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 20),
          
          // Reportes disponibles
          _buildReportCard(
            'Reporte Semanal',
            'Resumen de actividades de los últimos 7 días',
            Icons.calendar_view_week,
            AppTheme.info,
            () {},
          ),
          _buildReportCard(
            'Reporte Mensual',
            'Análisis completo del mes actual',
            Icons.calendar_view_month,
            AppTheme.success,
            () {},
          ),
          _buildReportCard(
            'Reporte de Satisfacción',
            'Evaluaciones y comentarios de clientes',
            Icons.star,
            AppTheme.warning,
            () {},
          ),
          _buildReportCard(
            'Reporte Financiero',
            'Ingresos, costos y rentabilidad',
            Icons.attach_money,
            AppTheme.accent,
            () {},
          ),
          _buildReportCard(
            'Reporte de Eficiencia',
            'Métricas de rendimiento y optimización',
            Icons.trending_up,
            AppTheme.primaryMedium,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExportModal(BuildContext context, AppLocalizations localizations) {
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
              Text(
                'Exportar Datos',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 20),
              
              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: AppTheme.error),
                title: const Text('Exportar como PDF'),
                subtitle: const Text('Reporte completo con gráficos'),
                onTap: () {
                  Navigator.pop(context);
                  _showExportSuccess('PDF');
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.table_chart, color: AppTheme.success),
                title: const Text('Exportar como Excel'),
                subtitle: const Text('Datos tabulares para análisis'),
                onTap: () {
                  Navigator.pop(context);
                  _showExportSuccess('Excel');
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.code, color: AppTheme.info),
                title: const Text('Exportar como CSV'),
                subtitle: const Text('Datos en formato CSV'),
                onTap: () {
                  Navigator.pop(context);
                  _showExportSuccess('CSV');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExportSuccess(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reporte exportado como $format'),
        backgroundColor: AppTheme.success,
        action: SnackBarAction(
          label: 'Ver',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  Map<String, dynamic> _getHistoryStatusConfig(String status) {
    switch (status) {
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
}