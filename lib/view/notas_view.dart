import 'package:flutter/material.dart';
import '../controller/disciplinas_controller.dart';
import '../model/academico_model.dart';
import 'componentes.dart';

const _decimal = TextInputType.numberWithOptions(decimal: true);
double _num(String s) => double.parse(s.replaceAll(',', '.'));

class NotasView extends StatelessWidget {
  const NotasView({super.key});

  Color _cor(String s) => switch (s) {
        'Aprovado' => Colors.green,
        'Recuperação' => Colors.orange,
        _ => Colors.red,
      };

  @override
  Widget build(BuildContext context) {
    final c = DisciplinasController();
    return Scaffold(
      appBar: AppBar(title: const Text('Notas')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Disciplina'),
        onPressed: () => mostrarFormulario(
          context,
          titulo: 'Nova disciplina',
          campos: [
            const Campo('Disciplina'),
            const Campo('Professor'),
            Campo('Nota 1 (0 a 10)', teclado: _decimal, validar: c.validarNota),
            Campo('Nota 2 (0 a 10)', teclado: _decimal, validar: c.validarNota),
            Campo('Faltas', teclado: TextInputType.number, validar: c.validarFaltas),
          ],
          salvar: (v) => c.adicionar(Disciplina(
            nome: v[0],
            professor: v[1],
            nota1: _num(v[2]),
            nota2: _num(v[3]),
            faltas: int.parse(v[4]),
          )),
        ),
      ),
      body: StreamLista<Disciplina>(
        origem: c.listar,
        vazio: 'Nenhuma disciplina cadastrada.\nToque em "Disciplina" para adicionar.',
        item: (ctx, d) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Text(d.nome, style: Theme.of(ctx).textTheme.titleMedium)),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Excluir',
                  onPressed: () => c.excluir(d.id!),
                ),
              ]),
              Text(d.professor),
              const SizedBox(height: 8),
              Text('N1: ${d.nota1.toStringAsFixed(1)}   '
                  'N2: ${d.nota2.toStringAsFixed(1)}   '
                  'Média: ${d.media.toStringAsFixed(1)}'),
              const SizedBox(height: 8),
              Chip(
                label: Text(d.situacao),
                backgroundColor: _cor(d.situacao).withValues(alpha: 0.15),
                side: BorderSide(color: _cor(d.situacao)),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
