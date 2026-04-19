import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/gastos_viewmodel.dart';
import '../models/gasto.dart';
import 'pantalla_registro.dart';
import 'pantalla_detalle.dart';

const List<String> kCategorias = [
  'Alimentacion',
  'Transporte',
  'Entretenimiento',
  'Salud',
  'Otros',
];

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  String _filtro = 'Todos';

  final Map<String, String> categoriaEmoji = {
    'Todos': '✨',
    'Alimentacion': '🍔',
    'Transporte': '🚌',
    'Entretenimiento': '🎮',
    'Salud': '💊',
    'Otros': '📦',
  };

  final Map<String, IconData> categoriaIcono = {
    'Alimentacion': Icons.restaurant,
    'Transporte': Icons.directions_bus,
    'Entretenimiento': Icons.movie,
    'Salud': Icons.favorite,
    'Otros': Icons.category,
  };

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GastosViewModel>();

    final gastos = _filtro == 'Todos'
        ? vm.gastos
        : vm.gastos.where((g) => g.categoria == _filtro).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F4FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFFF6F4FB),
        title: const Text(
          '💸 Control de Gastos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          _TotalesCard(vm: vm, categoriaEmoji: categoriaEmoji),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: ['Todos', ...kCategorias].map((cat) {
                final seleccionado = _filtro == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    showCheckmark: false,
                    selectedColor: const Color(0xFFD9D6F8),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: seleccionado
                          ? const Color(0xFF7C6EE6)
                          : Colors.grey.shade300,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    label: Text(
                      '${categoriaEmoji[cat] ?? ''} $cat',
                      style: TextStyle(
                        fontWeight:
                        seleccionado ? FontWeight.bold : FontWeight.w500,
                        color: seleccionado
                            ? const Color(0xFF4B3FB5)
                            : Colors.black87,
                      ),
                    ),
                    selected: seleccionado,
                    onSelected: (_) => setState(() => _filtro = cat),
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: gastos.isEmpty
                ? const _EstadoVacio()
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 90),
              itemCount: gastos.length,
              itemBuilder: (context, index) {
                final gasto = gastos[index];
                return _GastoTile(
                  gasto: gasto,
                  icono: categoriaIcono[gasto.categoria] ??
                      Icons.attach_money,
                  emoji: categoriaEmoji[gasto.categoria] ?? '💰',
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFBFC4F7),
        foregroundColor: const Color(0xFF32408F),
        elevation: 6,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PantallaRegistro()),
          );
        },
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}

class _TotalesCard extends StatelessWidget {
  final GastosViewModel vm;
  final Map<String, String> categoriaEmoji;

  const _TotalesCard({
    required this.vm,
    required this.categoriaEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEAE7FF),
            Color(0xFFF8F7FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 Resumen',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Total general: S/. ${vm.totalGeneral.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF322E63),
            ),
          ),
          const SizedBox(height: 14),
          const Divider(),
          const SizedBox(height: 4),
          ...kCategorias.map((cat) {
            final total = vm.totalPorCategoria(cat);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${categoriaEmoji[cat] ?? ''} $cat',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: total > 0
                          ? const Color(0xFFDCD9FA)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'S/. ${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: total > 0
                            ? const Color(0xFF3C35A3)
                            : Colors.grey.shade700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _GastoTile extends StatelessWidget {
  final Gasto gasto;
  final IconData icono;
  final String emoji;

  const _GastoTile({
    required this.gasto,
    required this.icono,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PantallaDetalle(gasto: gasto),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAE7FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gasto.nombre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${emoji} ${gasto.categoria}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'S/. ${gasto.monto.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF2F3B87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EstadoVacio extends StatelessWidget {
  const _EstadoVacio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🧾',
              style: TextStyle(fontSize: 60),
            ),
            SizedBox(height: 14),
            Text(
              'Aún no hay gastos registrados',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Presiona el botón ➕ para agregar tu primer gasto.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}