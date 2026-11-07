import 'package:flutter/material.dart';
import '../model/sobre_model.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    const info = SobreModel.projeto;
    final texto = Theme.of(context).textTheme;
    final cor = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(Icons.school, size: 72, color: cor.primary),
          const SizedBox(height: 8),
          Text('Portal Integrado',
              textAlign: TextAlign.center, style: texto.headlineSmall),
          Text('Versão ${info.versao}',
              textAlign: TextAlign.center, style: texto.bodyMedium),
          const SizedBox(height: 24),
          _Secao(titulo: 'Objetivo', filhos: [Text(info.objetivo)]),
          _Secao(
            titulo: 'Equipe de desenvolvimento',
            filhos: [
              for (final nome in info.integrantes)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(nome)),
                    ],
                  ),
                ),
            ],
          ),
          _Secao(
            titulo: 'Informações acadêmicas',
            filhos: [
              Text('Instituição: ${info.instituicao}'),
              Text('Disciplina: ${info.disciplina}'),
              Text('Professor: ${info.professor}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Secao extends StatelessWidget {
  final String titulo;
  final List<Widget> filhos;
  const _Secao({required this.titulo, required this.filhos});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...filhos,
          ],
        ),
      ),
    );
  }
}
