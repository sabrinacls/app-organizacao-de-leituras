class Livro {
  final String titulo;
  final String autor;
  final String status;

  Livro({
    required this.titulo,
    required this.autor,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'autor': autor,
      'status': status,
    };
  }

  factory Livro.fromMap(Map<String, dynamic> map) {
    return Livro(
      titulo: map['titulo'] ?? '',
      autor: map['autor'] ?? '',
      status: map['status'] ?? 'Quero ler',
    );
  }
}
