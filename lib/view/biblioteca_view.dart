import 'package:flutter/material.dart';
import '../controller/livros_controller.dart';
import '../model/academico_model.dart';
import 'componentes.dart';

class BibliotecaView extends StatelessWidget {
  const BibliotecaView({super.key});

  static const int _max = 2;

  @override
  Widget build(BuildContext context) {
    final c = LivrosController();
    return Scaffold(
      appBar: AppBar(title: const Text('Biblioteca')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Empréstimo'),
        onPressed: () => mostrarFormulario(
          context,
          titulo: 'Novo empréstimo',
          campos: const [Campo('Título'), Campo('Autor')],
          salvar: (v) => c.adicionar(v[0], v[1]),
        ),
      ),
      body: StreamLista<Livro>(
        origem: c.listar,
        vazio: 'Nenhum livro emprestado.\nToque em "Empréstimo" para adicionar.',
        item: (ctx, l) {
          final atrasado = l.devolucao.isBefore(DateTime.now());
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.titulo, style: Theme.of(ctx).textTheme.titleMedium),
                Text(l.autor),
                const SizedBox(height: 8),
                Text(
                  atrasado
                      ? 'Atrasado! Devolução era ${formatarData(l.devolucao)}'
                      : 'Devolução: ${formatarData(l.devolucao)}',
                  style: TextStyle(color: atrasado ? Colors.red : null),
                ),
                Text('Renovações: ${l.renovacoes}/$_max'),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                    onPressed: () => c.devolver(l.id),
                    child: const Text('Devolver'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonal(
                    onPressed:
                        atrasado || l.renovacoes >= _max ? null : () => c.renovar(l),
                    child: const Text('Renovar'),
                  ),
                ]),
              ]),
            ),
          );
        },
      ),
    );
  }
}
