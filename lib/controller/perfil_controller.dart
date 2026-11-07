import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/usuario_model.dart';

class PerfilController {
  static const int minimoCaracteresNome = 3;

  String? validarNome(String? valor) {
    final nome = valor?.trim() ?? '';
    if (nome.isEmpty) return 'Informe o nome.';
    if (nome.length < minimoCaracteresNome) {
      return 'O nome deve ter ao menos $minimoCaracteresNome caracteres.';
    }
    return null;
  }

  // Atualiza o nome em usuarios/{uid}; a tela principal se atualiza sozinha
  // porque lê esse documento em tempo real.
  Future<UsuarioModel> atualizar(UsuarioModel atual, String novoNome) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .set({'nome': novoNome.trim()}, SetOptions(merge: true));
    return atual.copyWith(nome: novoNome.trim());
  }

  Future<void> sair() => FirebaseAuth.instance.signOut();
}