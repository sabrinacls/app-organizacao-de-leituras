// Integrante: Sabrina Clemente da Silva

import 'package:flutter/material.dart';
import 'screens/tela_inicial.dart';

void main() {
  runApp(const MeuAppLivros());
}

class MeuAppLivros extends StatelessWidget {
  const MeuAppLivros({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Lista de Livros',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TelaInicial(),
    );
  }
}