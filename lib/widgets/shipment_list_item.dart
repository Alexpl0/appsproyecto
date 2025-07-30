import 'package:flutter/material.dart';
import 'package:rastreo_app/models/envio_model.dart';

class ShipmentListItem extends StatelessWidget {
  final Envio envio;
  const ShipmentListItem({super.key, required this.envio});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                envio.imagenUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.image_not_supported, size: 70),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(envio.producto, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text("ID: ${envio.id}", style: theme.textTheme.bodySmall),
                  Text(envio.nombrePropietario, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(envio.estado, style: TextStyle(color: envio.estado == 'Entregado' ? Colors.green : Colors.orange, fontWeight: FontWeight.bold)),
                Text(envio.destino, style: theme.textTheme.bodySmall),
              ],
            )
          ],
        ),
      ),
    );
  }
}
