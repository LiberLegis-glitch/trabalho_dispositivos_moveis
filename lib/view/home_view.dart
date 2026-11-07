import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/usuario_model.dart';
import 'biblioteca_view.dart';
import 'feriados_view.dart';
import 'frequencia_view.dart';
import 'horario_view.dart';
import 'notas_view.dart';
import 'perfil_view.dart';
import 'sobre_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _aba = 0;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser;
    if (auth == null) return const SizedBox();

    // Perfil lido em tempo real da coleção "usuarios": qualquer alteração
    // de nome aparece em todas as abas automaticamente.
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream:
          FirebaseFirestore.instance.collection('usuarios').doc(auth.uid).snapshots(),
      builder: (context, snap) {
        final dados = snap.data?.data();
        final usuario = dados != null
            ? UsuarioModel.fromMap(dados)
            : UsuarioModel(nome: 'Aluno', email: auth.email ?? '');

        return Scaffold(
          body: IndexedStack(
            index: _aba,
            children: [
              _Inicio(usuario: usuario),
              // A chave faz a aba recarregar o nome quando ele muda no banco.
              PerfilView(key: ValueKey(usuario.nome), usuario: usuario, embutido: true),
              const SobreView(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _aba,
            onDestinationSelected: (i) => setState(() => _aba = i),
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Início'),
              NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Perfil'),
              NavigationDestination(
                  icon: Icon(Icons.info_outline),
                  selectedIcon: Icon(Icons.info),
                  label: 'Sobre'),
            ],
          ),
        );
      },
    );
  }
}

// Aba "Início": saudação e atalhos das funcionalidades.
class _Inicio extends StatelessWidget {
  final UsuarioModel usuario;
  const _Inicio({required this.usuario});

  static const _atalhos = <(IconData, String, Widget)>[
    (Icons.grade_outlined, 'Notas', NotasView()),
    (Icons.calendar_month_outlined, 'Horário', HorarioView()),
    (Icons.fact_check_outlined, 'Frequência', FrequenciaView()),
    (Icons.event_outlined, 'Feriados', FeriadosView()),
    (Icons.local_library_outlined, 'Biblioteca', BibliotecaView()),
  ];

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme;
    final inicial = usuario.nome.isEmpty ? '?' : usuario.nome[0].toUpperCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal Integrado'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: cor.primaryContainer,
              child: Text(inicial,
                  style: TextStyle(fontSize: 22, color: cor.onPrimaryContainer)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Olá,', style: Theme.of(context).textTheme.bodyMedium),
                Text(usuario.nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge),
              ]),
            ),
          ]),
          const SizedBox(height: 20),
          Text('Acesso rápido', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                for (final a in _atalhos)
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context, MaterialPageRoute(builder: (_) => a.$3)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(a.$1, size: 44, color: cor.primary),
                          const SizedBox(height: 8),
                          Text(a.$2, style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}