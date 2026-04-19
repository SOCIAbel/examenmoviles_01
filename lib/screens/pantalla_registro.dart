import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/gasto.dart';
import '../viewmodels/gastos_viewmodel.dart';
import 'pantalla_principal.dart' show kCategorias;

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _formKey = GlobalKey<FormState>();

  final _nombreCtrl = TextEditingController();
  final _montoCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String? _categoriaSeleccionada;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _montoCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final gasto = Gasto(
      nombre: _nombreCtrl.text.trim(),
      monto: double.parse(_montoCtrl.text.trim()),
      categoria: _categoriaSeleccionada!,
      descripcion: _descCtrl.text.trim(),
    );

    context.read<GastosViewModel>().agregarGasto(gasto);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Gasto'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ── Nombre ──────────────────────────────────
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre del gasto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  if (value.trim().length < 3) {
                    return 'El nombre debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Monto ────────────────────────────────────
              TextFormField(
                controller: _montoCtrl,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Monto (S/.)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El monto es obligatorio';
                  }
                  final monto = double.tryParse(value.trim());
                  if (monto == null) {
                    return 'Ingresa un valor numérico válido';
                  }
                  if (monto <= 0) {
                    return 'El monto debe ser mayor a 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Categoría ────────────────────────────────
              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: kCategorias
                    .map((cat) =>
                    DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _categoriaSeleccionada = val),
                validator: (value) =>
                value == null ? 'Selecciona una categoría' : null,
              ),
              const SizedBox(height: 16),

              // ── Descripción (opcional) ───────────────────
              TextFormField(
                controller: _descCtrl,
                maxLength: 100,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != null && value.length > 100) {
                    return 'Máximo 100 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ── Botón guardar ────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _guardar,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar gasto'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
