import 'package:flutter/material.dart';
import '../controller/perfil_controller.dart';
import '../model/usuario_model.dart';

class PerfilView extends StatefulWidget {
  final UsuarioModel usuario;
  final bool embutido; // true quando é uma aba da tela principal
  const PerfilView({super.key, required this.usuario, this.embutido = false});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  final _controller = PerfilController();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeCtrl;
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _nomeCtrl = TextEditingController(text: widget.usuario.nome);
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);
    try {
      final atualizado =
          await _controller.atualizar(widget.usuario, _nomeCtrl.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
      if (widget.embutido) {
        setState(() => _carregando = false);
      } else {
        Navigator.pop(context, atualizado);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível atualizar o perfil.')),
      );
    }
  }

  void _cancelar() {
    if (widget.embutido) {
      _nomeCtrl.text = widget.usuario.nome; // restaura o nome salvo
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu perfil')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Text(
                        widget.usuario.nome.trim().isEmpty
                            ? '?'
                            : widget.usuario.nome.trim()[0].toUpperCase(),
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nomeCtrl,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _salvar(),
                      validator: _controller.validarNome,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // E-mail somente leitura (não pode ser alterado aqui).
                    TextFormField(
                      initialValue: widget.usuario.email,
                      readOnly: true,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _carregando ? null : _salvar,
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: _carregando
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Salvar alterações'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed:
                          _carregando ? null : _cancelar,
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('Cancelar'),
                    ),
                    if (widget.embutido) ...[
                      const SizedBox(height: 24),
                      TextButton.icon(
                        onPressed: _controller.sair,
                        icon: const Icon(Icons.logout),
                        label: const Text('Sair da conta'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}