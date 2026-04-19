import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/gastos_viewmodel.dart';
import 'screens/pantalla_principal.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GastosViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Gastos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const PantallaPrincipal(),
    );
  }
}