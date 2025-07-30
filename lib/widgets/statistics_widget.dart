import 'package:flutter/material.dart';
import 'package:rastreo_app/theme/app_theme.dart';
import 'dart:math' as math;

class StatisticsWidget extends StatefulWidget {
  final String title;
  final List<StatisticItem> statistics;
  final ChartData? chartData;
  final StatisticsType type;
  final VoidCallback? onTap;
  final bool showChart;
  final String? subtitle;

  const StatisticsWidget({
    super.key,
    required this.title,
    required this.statistics,
    this.chartData,
    this.type = StatisticsType.grid,
    this.onTap,
    this.showChart = true,
    this.subtitle,
  });

  @override
  State<StatisticsWidget> createState() => _StatisticsWidgetState();
}

class _StatisticsWidgetState extends State<StatisticsWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  String _selectedPeriod = 'week';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 20),
                        _buildContent(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
        if (widget.showChart && widget.chartData != null)
          _buildPeriodSelector(),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPeriod,
          style: const TextStyle(color: AppTheme.primaryDark, fontSize: 12),
          icon: const Icon(Icons.keyboard_arrow_down, size: 16),
          items: const [
            DropdownMenuItem(value: 'day', child: Text('Día')),
            DropdownMenuItem(value: 'week', child: Text('Semana')),
            DropdownMenuItem(value: 'month', child: Text('Mes')),
            DropdownMenuItem(value: 'year', child: Text('Año')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedPeriod = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (widget.type) {
      case StatisticsType.grid:
        return _buildGridLayout();
      case StatisticsType.list:
        return _buildListLayout();
      case StatisticsType.chart:
        return _buildChartLayout();
      case StatisticsType.mixed:
        return _buildMixedLayout();
    }
  }

  Widget _buildGridLayout() {
    return GridView.count(
      crossAxisCount: widget.statistics.length > 2 ? 2 : widget.statistics.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: widget.statistics.map((stat) => _buildStatisticCard(stat)).toList(),
    );
  }

  Widget _buildListLayout() {
    return Column(
      children: widget.statistics
          .map((stat) => _buildStatisticListItem(stat))
          .toList(),
    );
  }

  Widget _buildChartLayout() {
    return Column(
      children: [
        if (widget.chartData != null) ...[
          _buildChart(),
          const SizedBox(height: 20),
        ],
        _buildGridLayout(),
      ],
    );
  }

  Widget _buildMixedLayout() {
    return Column(
      children: [
        // Estadísticas principales en fila
        Row(
          children: widget.statistics.take(3).map((stat) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildCompactStatCard(stat),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 20),
        
        // Gráfico si está disponible
        if (widget.chartData != null && widget.showChart)
          _buildChart(),
      ],
    );
  }

  Widget _buildStatisticCard(StatisticItem stat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            stat.color.withOpacity(0.1),
            stat.color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: stat.color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: stat.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  stat.icon,
                  color: stat.color,
                  size: 20,
                ),
              ),
              const Spacer(),
              if (stat.trend != null)
                _buildTrendIndicator(stat.trend!),
            ],
          ),
          
          const Spacer(),
          
          Text(
            stat.label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 4),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  stat.value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (stat.unit != null) ...[
                const SizedBox(width: 4),
                Text(
                  stat.unit!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticListItem(StatisticItem stat) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: stat.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              stat.icon,
              color: stat.color,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryDark,
                  ),
                ),
                if (stat.description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    stat.description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    stat.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  if (stat.unit != null) ...[
                    const SizedBox(width: 2),
                    Text(
                      stat.unit!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
              if (stat.trend != null) ...[
                const SizedBox(height: 4),
                _buildTrendIndicator(stat.trend!),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatCard(StatisticItem stat) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: stat.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: stat.color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            stat.icon,
            color: stat.color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            stat.value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            stat.label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (stat.trend != null) ...[
            const SizedBox(height: 4),
            _buildTrendIndicator(stat.trend!, isCompact: true),
          ],
        ],
      ),
    );
  }

  Widget _buildTrendIndicator(TrendData trend, {bool isCompact = false}) {
    final isPositive = trend.value > 0;
    final isNeutral = trend.value == 0;
    final color = isNeutral 
        ? Colors.grey 
        : (isPositive ? Colors.green : Colors.red);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 4 : 6,
        vertical: isCompact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isCompact ? 6 : 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isNeutral 
                ? Icons.horizontal_rule
                : (isPositive ? Icons.trending_up : Icons.trending_down),
            color: color,
            size: isCompact ? 10 : 12,
          ),
          const SizedBox(width: 2),
          Text(
            '${isPositive ? '+' : ''}${trend.value.toStringAsFixed(1)}%',
            style: TextStyle(
              color: color,
              fontSize: isCompact ? 8 : 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    if (widget.chartData == null) return const SizedBox();
    
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: widget.chartData!.type == ChartType.line
          ? _buildLineChart()
          : widget.chartData!.type == ChartType.bar
              ? _buildBarChart()
              : _buildPieChart(),
    );
  }

  Widget _buildLineChart() {
    final data = widget.chartData!.data;
    if (data.isEmpty) return const Center(child: Text('No data'));
    
    return CustomPaint(
      painter: LineChartPainter(
        data: data,
        color: AppTheme.primaryMedium,
        backgroundColor: AppTheme.surface,
      ),
      size: Size.infinite,
    );
  }

  Widget _buildBarChart() {
    final data = widget.chartData!.data;
    if (data.isEmpty) return const Center(child: Text('No data'));
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.map((point) {
        final maxValue = data.map((p) => p.value).reduce(math.max);
        final height = (point.value / maxValue) * 150;
        
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
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
                ),
                const SizedBox(height: 8),
                Text(
                  point.label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPieChart() {
    final data = widget.chartData!.data;
    if (data.isEmpty) return const Center(child: Text('No data'));
    
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: AspectRatio(
            aspectRatio: 1,
            child: CustomPaint(
              painter: PieChartPainter(data: data),
              child: const Center(
                child: Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDark,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: data.map((point) {
              final total = data.fold<double>(0, (sum, p) => sum + p.value);
              final percentage = (point.value / total * 100).toInt();
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: point.color ?? _getChartColor(data.indexOf(point)),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        point.label,
                        style: const TextStyle(fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: const TextStyle(
                        fontSize: 11,
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
    );
  }

  Color _getChartColor(int index) {
    final colors = [
      AppTheme.primaryMedium,
      AppTheme.accent,
      AppTheme.success,
      AppTheme.warning,
      AppTheme.error,
      AppTheme.info,
    ];
    return colors[index % colors.length];
  }
}

// Custom Painters
class LineChartPainter extends CustomPainter {
  final List<ChartDataPoint> data;
  final Color color;
  final Color backgroundColor;

  LineChartPainter({
    required this.data,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.3),
          color.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final maxValue = data.map((p) => p.value).reduce(math.max);
    final minValue = data.map((p) => p.value).reduce(math.min);
    final range = maxValue - minValue;

    final points = <Offset>[];
    final fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - ((data[i].value - minValue) / range) * size.height;
      
      points.add(Offset(x, y));
      
      if (i == 0) {
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Dibujar área rellena
    canvas.drawPath(fillPath, fillPaint);

    // Dibujar línea
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        path.moveTo(points[i].dx, points[i].dy);
      } else {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }
    canvas.drawPath(path, paint);

    // Dibujar puntos
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
      canvas.drawCircle(point, 4, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PieChartPainter extends CustomPainter {
  final List<ChartDataPoint> data;

  PieChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;
    final total = data.fold<double>(0, (sum, point) => sum + point.value);

    double startAngle = -math.pi / 2;

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i].value / total) * 2 * math.pi;
      final paint = Paint()
        ..color = data[i].color ?? _getDefaultColor(i)
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Dibujar borde
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, borderPaint);
  }

  Color _getDefaultColor(int index) {
    final colors = [
      AppTheme.primaryMedium,
      AppTheme.accent,
      AppTheme.success,
      AppTheme.warning,
      AppTheme.error,
      AppTheme.info,
    ];
    return colors[index % colors.length];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Modelos de datos
class StatisticItem {
  final String label;
  final String value;
  final String? unit;
  final IconData icon;
  final Color color;
  final TrendData? trend;
  final String? description;

  StatisticItem({
    required this.label,
    required this.value,
    this.unit,
    required this.icon,
    required this.color,
    this.trend,
    this.description,
  });
}

class TrendData {
  final double value;
  final String period;

  TrendData({
    required this.value,
    required this.period,
  });
}

class ChartData {
  final List<ChartDataPoint> data;
  final ChartType type;
  final String? title;

  ChartData({
    required this.data,
    required this.type,
    this.title,
  });
}

class ChartDataPoint {
  final String label;
  final double value;
  final Color? color;

  ChartDataPoint({
    required this.label,
    required this.value,
    this.color,
  });
}

enum StatisticsType {
  grid,
  list,
  chart,
  mixed,
}

enum ChartType {
  line,
  bar,
  pie,
}