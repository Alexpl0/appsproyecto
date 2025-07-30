import 'package:flutter/material.dart';
import 'package:rastreo_app/l10n/app_localizations.dart';

class SummaryCard extends StatelessWidget {
  final int total;
  final int enTransito;
  final int entregados;

  const SummaryCard({
    super.key,
    required this.total,
    required this.enTransito,
    required this.entregados,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.shipmentsSummary,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(context, localizations.orders, total.toString(), Colors.blue),
                _buildSummaryItem(context, localizations.inTransit, enTransito.toString(), Colors.orange),
                _buildSummaryItem(context, localizations.delivered, entregados.toString(), Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String title, String value, Color color) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(color: color, fontWeight: FontWeight.bold),
        ),
        Text(title, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
