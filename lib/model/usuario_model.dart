class UsuarioModel {
  final String nome, email, telefone, curso;

  const UsuarioModel({
    required this.nome,
    required this.email,
    this.telefone = '',
    this.curso = '',
  });

  factory UsuarioModel.fromMap(Map<String, dynamic> m) => UsuarioModel(
        nome: m['nome'] ?? '',
        email: m['email'] ?? '',
        telefone: m['telefone'] ?? '',
        curso: m['curso'] ?? '',
      );

  UsuarioModel copyWith({String? nome}) => UsuarioModel(
      nome: nome ?? this.nome, email: email, telefone: telefone, curso: curso);
}
