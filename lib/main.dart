import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart'; // gerado pelo comando `flutterfire configure`
import 'view/home_view.dart';
import 'view/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PortalApp());
}

// Em telas largas (navegador no computador), mostra o app dentro de uma
// moldura de celular. Em telas pequenas (celular de verdade), não muda nada.
Widget _moldura(BuildContext context, Widget? app) {
  final tela = MediaQuery.sizeOf(context);
  if (tela.width < 600) return app!;

  final altura = min(860.0, max(500.0, tela.height - 32));
  const largura = 400.0;
  return ColoredBox(
    color: const Color(0xFFDDE3EC),
    child: Center(
      child: SizedBox(
        width: largura,
        height: altura,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: const Color(0xFF1C1C1E), width: 8),
            boxShadow: const [BoxShadow(blurRadius: 28, color: Colors.black38)],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(size: Size(largura - 16, altura - 16)),
              child: app!,
            ),
          ),
        ),
      ),
    ),
  );
}

class PortalApp extends StatelessWidget {
  const PortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal Integrado',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B4F9C)),
        useMaterial3: true,
      ),
      builder: _moldura,
      // Permite rolar arrastando com o mouse, como o toque no celular.
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      // Porta de entrada: logado -> app; deslogado -> login.
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return snap.hasData ? const HomeView() : const LoginView();
        },
      ),
    );
  }
}