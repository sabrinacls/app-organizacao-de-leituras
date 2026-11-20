import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/livro.dart';
import 'tela_cadastro.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  static const String _chaveStorage = 'lista_livros';
  final List<Livro> _livros = [];

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  Future<void> _carregarLivros() async {
    final prefs = await SharedPreferences.getInstance();
    final String? livrosJson = prefs.getString(_chaveStorage);

    if (livrosJson != null && livrosJson.isNotEmpty) {
      final List<dynamic> listaDecodificada = jsonDecode(livrosJson);
      setState(() {
        _livros.clear();
        _livros.addAll(
          listaDecodificada.map(
            (item) => Livro.fromMap(Map<String, dynamic>.from(item)),
          ),
        );
      });
    }
  }

Future<void> _salvarLivrosNoStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final listaMapeada = _livros.map((livro) => livro.toMap()).toList();
    final String livrosJson = jsonEncode(listaMapeada);
    await prefs.setString(_chaveStorage, livrosJson);
  }

  Future<void> _abrirTelaCadastro() async {
    final Livro? novoLivro = await Navigator.push<Livro>(
      context,
      MaterialPageRoute(
        builder: (context) => const TelaCadastro(),
      ),
    );

    if (novoLivro != null) {
      setState(() {
        _livros.add(novoLivro);
      });
      await _salvarLivrosNoStorage();

      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Livro "${novoLivro.titulo}" adicionado com sucesso!'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    }
  }

  Future<void> _removerLivro(int index) async {
    final livroRemovido = _livros[index];

    setState(() {
      _livros.removeAt(index);
    });
    await _salvarLivrosNoStorage();

    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Livro "${livroRemovido.titulo}" removido.'),
      ),
    );
  }

  Color _corDoStatus(String status) {
    switch (status) {
      case 'Lendo':
        return Colors.orange.shade700;
      case 'Concluído':
        return Colors.green.shade700;
      case 'Quero ler':
      default:
        return Colors.blue.shade700;
    }
  }

  IconData _iconeDoStatus(String status) {
    switch (status) {
      case 'Lendo':
        return Icons.menu_book;
      case 'Concluído':
        return Icons.check_circle;
      case 'Quero ler':
      default:
        return Icons.bookmark_border;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Minha Lista de Livros',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Sabrina Clemente da Silva',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: _livros.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.library_books, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Nenhum livro cadastrado ainda.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Toque no botão "+" abaixo para adicionar o seu primeiro livro.',
                      style: TextStyle(fontSize: 14, color: Colors.black45),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _livros.length,
              itemBuilder: (context, index) {
                final livro = _livros[index];
                final corStatus = _corDoStatus(livro.status);

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: corStatus.withValues(alpha: 0.15),
                      child: Icon(_iconeDoStatus(livro.status), color: corStatus),
                    ),
                    title: Text(
                      livro.titulo,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Autor: ${livro.autor}'),
                        const SizedBox(height: 4),
                        Text(
                          'Status: ${livro.status}',
                          style: TextStyle(
                            color: corStatus,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      tooltip: 'Remover livro',
                      onPressed: () => _removerLivro(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirTelaCadastro,
        tooltip: 'Adicionar livro',
        child: const Icon(Icons.add),
      ),
    );
  }
}
