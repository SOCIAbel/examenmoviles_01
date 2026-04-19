class Gasto {
  final String nombre;
  final double monto;
  final String categoria;
  final String descripcion;
  final DateTime fechaRegistro;

  Gasto({
    required this.nombre,
    required this.monto,
    required this.categoria,
    this.descripcion = '',
    DateTime? fechaRegistro,
  }) : fechaRegistro = fechaRegistro ?? DateTime.now();
}
 