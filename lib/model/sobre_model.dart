class SobreModel {
  final String objetivo;
  final List<String> integrantes;
  final String disciplina;
  final String instituicao;
  final String professor;
  final String versao;

  const SobreModel({
    required this.objetivo,
    required this.integrantes,
    required this.disciplina,
    required this.instituicao,
    required this.professor,
    required this.versao,
  });

  static const projeto = SobreModel(
    objetivo: 'Reunir em um único aplicativo os serviços acadêmicos da '
        'faculdade, facilitando o acesso de alunos às informações e '
        'funcionalidades do portal.',
    integrantes: [
      'Nome do Integrante 1',
      'Nome do Integrante 2',
      'Nome do Integrante 3',
    ],
    disciplina: 'Nome da Disciplina',
    instituicao: 'Nome da Instituição',
    professor: 'Nome do Professor',
    versao: '1.0.0',
  );
}
