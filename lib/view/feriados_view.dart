import 'package:flutter/material.dart';
import '../controller/feriados_controller.dart';
import '../model/academico_model.dart';

class FeriadosView extends StatefulWidget {
  const FeriadosView({super.key});

  @override
  State<FeriadosView> createState() => _FeriadosViewState();
}

class _FeriadosViewState extends State<FeriadosView> {
  final _ano = DateTime.now().year;
  late Future<List<Feriado>> _futuro = FeriadosController().buscar(_ano);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feriados $_ano')),
      body: FutureBuilder<List<Feriado>>(
        future: _futuro,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Não foi possível consultar os feriados.'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () =>
                      setState(() => _futuro = FeriadosController().buscar(_ano)),
                  child: const Text('Tentar novamente'),
                ),
              ]),
            );
          }
          return ListView(
            children: [
              for (final f in snap.data!)
                ListTile(
                  leading: const Icon(Icons.event),
                  title: Text(f.nome),
                  subtitle: Text(formatarData(f.data)),
                ),
            ],
          );
        },
      ),
    );
  }
}
