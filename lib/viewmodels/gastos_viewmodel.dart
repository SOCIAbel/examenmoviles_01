import 'package:flutter/material.dart';
import '../models/gasto.dart';

class GastosViewModel extends ChangeNotifier {
  final List<Gasto> _gastos = [];

  List<Gasto> get gastos => List.unmodifiable(_gastos);

  double get totalGeneral =>
      _gastos.fold(0, (sum, g) => sum + g.monto);

  double totalPorCategoria(String categoria) =>
      _gastos
          .where((g) => g.categoria == categoria)
          .fold(0, (sum, g) => sum + g.monto);

  void agregarGasto(Gasto gasto) {
    _gastos.add(gasto);
    notifyListeners();
  }
}
