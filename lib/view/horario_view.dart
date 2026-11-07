import 'package:flutter/material.dart';
import '../model/academico_model.dart';

class HorarioView extends StatelessWidget {
  const HorarioView({super.key});

  static const _dias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex'];

  @override
  Widget build(BuildContext context) {
    final hoje = DateTime.now().weekday; // 1..7
    return DefaultTabController(
      length: 5,
      initialIndex: hoje <= 5 ? hoje - 1 : 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Horário de aulas'),
          bottom: TabBar(tabs: [for (final d in _dias) Tab(text: d)]),
        ),
        body: TabBarView(
          children: [
            for (var dia = 1; dia <= 5; dia++) _listaDoDia(dia),
          ],
        ),
      ),
    );
  }

  Widget _listaDoDia(int dia) {
    final aulas = aulasMock.where((a) => a.dia == dia).toList();
    if (aulas.isEmpty) {
      return const Center(child: Text('Sem aulas neste dia.'));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final a in aulas)
          Card(
            child: ListTile(
              leading: const Icon(Icons.schedule),
              title: Text(a.disciplina),
              subtitle: Text('${a.horario}  •  ${a.sala}'),
            ),
          ),
      ],
    );
  }
}
