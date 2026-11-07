import 'package:cloud_firestore/cloud_firestore.dart';

String formatarData(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

// Coleção "disciplinas" (RF003: 8 campos, incluindo usuarioId e criadoEm).
class Disciplina {
  final String? id;
  final String nome, professor;
  final double nota1, nota2;
  final int faltas, totalAulas;

  const Disciplina({
    this.id,
    required this.nome,
    required this.professor,
    required this.nota1,
    required this.nota2,
    required this.faltas,
    this.totalAulas = 60,
  });

  factory Disciplina.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data()!;
    return Disciplina(
      id: d.id,
      nome: m['nome'],
      professor: m['professor'],
      nota1: (m['nota1'] as num).toDouble(),
      nota2: (m['nota2'] as num).toDouble(),
      faltas: (m['faltas'] as num).toInt(),
      totalAulas: (m['totalAulas'] as num).toInt(),
    );
  }

  Map<String, dynamic> toMap() => {
        'nome': nome,
        'professor': professor,
        'nota1': nota1,
        'nota2': nota2,
        'faltas': faltas,
        'totalAulas': totalAulas,
      };

  double get media => (nota1 + nota2) / 2;
  double get frequencia => 1 - faltas / totalAulas;
  String get situacao =>
      media >= 6 ? 'Aprovado' : (media >= 4 ? 'Recuperação' : 'Reprovado');
}

// Coleção "livros" (empréstimos da biblioteca).
class Livro {
  final String id, titulo, autor;
  final DateTime devolucao;
  final int renovacoes;

  const Livro(this.id, this.titulo, this.autor, this.devolucao, this.renovacoes);

  factory Livro.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data()!;
    return Livro(d.id, m['titulo'], m['autor'],
        (m['devolucao'] as Timestamp).toDate(), (m['renovacoes'] as num).toInt());
  }
}

// Retorno da API pública (BrasilAPI).
class Feriado {
  final String nome;
  final DateTime data;
  const Feriado(this.nome, this.data);
}

// Grade de horários fixa (não faz parte dos requisitos do Firebase).
class Aula {
  final int dia; // 1 = segunda ... 5 = sexta
  final String horario, disciplina, sala;
  const Aula(this.dia, this.horario, this.disciplina, this.sala);
}

const aulasMock = [
  Aula(1, '08:00 - 09:40', 'Programação Mobile', 'Lab 3'),
  Aula(1, '10:00 - 11:40', 'Banco de Dados', 'Sala 12'),
  Aula(2, '08:00 - 09:40', 'Engenharia de Software', 'Sala 8'),
  Aula(3, '08:00 - 09:40', 'Redes de Computadores', 'Lab 1'),
  Aula(3, '10:00 - 11:40', 'Programação Mobile', 'Lab 3'),
  Aula(4, '10:00 - 11:40', 'Banco de Dados', 'Sala 12'),
  Aula(5, '08:00 - 09:40', 'Engenharia de Software', 'Sala 8'),
];
