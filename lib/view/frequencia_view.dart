import 'package:flutter/material.dart';
import '../controller/disciplinas_controller.dart';
import '../model/academico_model.dart';
import 'componentes.dart';

class FrequenciaView extends StatelessWidget {
  const FrequenciaView({super.key});

  static const double minimo = 0.75;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Frequência')),
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Frequência mínima exigida: 75%')),
        ),
        Expanded(
          child: StreamLista<Disciplina>(
            origem: DisciplinasController().listar,
            vazio: 'Cadastre disciplinas em "Notas" para ver a frequência.',
            item: (ctx, d) {
              final risco = d.frequencia < minimo;
              final cor = risco ? Colors.red : Colors.green;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(d.nome, style: Theme.of(ctx).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: d.frequencia.clamp(0.0, 1.0),
                      color: cor,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    Text('${(d.frequencia * 100).toStringAsFixed(0)}% de presença  •  '
                        '${d.faltas} faltas em ${d.totalAulas} aulas'),
                    if (risco)
                      const Text('Atenção: abaixo do mínimo exigido.',
                          style: TextStyle(color: Colors.red)),
                  ]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
