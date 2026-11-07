import 'package:flutter/material.dart';

// Lista em tempo real (StreamBuilder + ListView) com carregamento,
// estado vazio e botão "Tentar novamente" em caso de erro (RF004).
class StreamLista<T> extends StatefulWidget {
  final Stream<List<T>> Function() origem;
  final Widget Function(BuildContext, T) item;
  final String vazio;

  const StreamLista(
      {super.key, required this.origem, required this.item, required this.vazio});

  @override
  State<StreamLista<T>> createState() => _StreamListaState<T>();
}

class _StreamListaState<T> extends State<StreamLista<T>> {
  late Stream<List<T>> _stream = widget.origem();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<T>>(
      stream: _stream,
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('Não foi possível carregar os dados.'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => setState(() => _stream = widget.origem()),
                child: const Text('Tentar novamente'),
              ),
            ]),
          );
        }
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final itens = snap.data!;
        if (itens.isEmpty) {
          return Center(child: Text(widget.vazio, textAlign: TextAlign.center));
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
          itemCount: itens.length,
          itemBuilder: (c, i) => widget.item(c, itens[i]),
        );
      },
    );
  }
}

class Campo {
  final String rotulo;
  final TextInputType teclado;
  final String? Function(String?)? validar;
  const Campo(this.rotulo, {this.teclado = TextInputType.text, this.validar});
}

// Formulário em diálogo para inserir dados, com mensagem de sucesso/erro (RF003).
Future<void> mostrarFormulario(
  BuildContext context, {
  required String titulo,
  required List<Campo> campos,
  required Future<void> Function(List<String> valores) salvar,
}) =>
    showDialog(
        context: context, builder: (_) => _Formulario(titulo, campos, salvar));

class _Formulario extends StatefulWidget {
  final String titulo;
  final List<Campo> campos;
  final Future<void> Function(List<String>) salvar;
  const _Formulario(this.titulo, this.campos, this.salvar);

  @override
  State<_Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<_Formulario> {
  final _form = GlobalKey<FormState>();
  late final _ctrls = [for (final _ in widget.campos) TextEditingController()];
  bool _salvando = false;

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _salvando = true);
    final msg = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    try {
      await widget.salvar([for (final c in _ctrls) c.text.trim()]);
      nav.pop();
      msg.showSnackBar(const SnackBar(content: Text('Dados salvos com sucesso!')));
    } catch (_) {
      if (mounted) setState(() => _salvando = false);
      msg.showSnackBar(
          const SnackBar(content: Text('Erro ao salvar os dados. Tente novamente.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titulo),
      content: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            for (var i = 0; i < widget.campos.length; i++)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextFormField(
                  controller: _ctrls[i],
                  keyboardType: widget.campos[i].teclado,
                  decoration: InputDecoration(
                    labelText: widget.campos[i].rotulo,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Campo obrigatório.'
                      : widget.campos[i].validar?.call(v),
                ),
              ),
          ]),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _salvando ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _salvando ? null : _salvar,
          child: _salvando
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Salvar'),
        ),
      ],
    );
  }
}
