import 'package:flutter/material.dart';
import '../models/gasto.dart';

class PantallaDetalle extends StatelessWidget {
  final Gasto gasto;

  const PantallaDetalle({super.key, required this.gasto});

  @override
  Widget build(BuildContext context) {
    final fecha =
        '${gasto.fechaRegistro.day.toString().padLeft(2, '0')}/'
        '${gasto.fechaRegistro.month.toString().padLeft(2, '0')}/'
        '${gasto.fechaRegistro.year}  '
        '${gasto.fechaRegistro.hour.toString().padLeft(2, '0')}:'
        '${gasto.fechaRegistro.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Gasto'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _DetalleFila(icono: Icons.label, etiqueta: 'Nombre', valor: gasto.nombre),
                const Divider(),
                _DetalleFila(icono: Icons.category, etiqueta: 'Categoría', valor: gasto.categoria),
                const Divider(),
                _DetalleFila(
                  icono: Icons.attach_money,
                  etiqueta: 'Monto',
                  valor: 'S/. ${gasto.monto.toStringAsFixed(2)}',
                ),
                const Divider(),
                _DetalleFila(
                  icono: Icons.notes,
                  etiqueta: 'Descripción',
                  valor: gasto.descripcion.isNotEmpty
                      ? gasto.descripcion
                      : 'Sin descripción',
                ),
                const Divider(),
                _DetalleFila(
                  icono: Icons.calendar_today,
                  etiqueta: 'Fecha de registro',
                  valor: fecha,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetalleFila extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;

  const _DetalleFila({
    required this.icono,
    required this.etiqueta,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: Colors.indigo, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(etiqueta,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(valor,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}