import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_controller.dart';

class CadastroController {
  String? validarNome(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Informe o nome.' : null;

  String? validarCurso(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Informe o curso.' : null;

  String? validarEmail(String? v) => LoginController().validarEmail(v);

  String? validarTelefone(String? valor) {
    final digitos = valor?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (digitos.isEmpty) return 'Informe o telefone.';
    if (digitos.length < 10 || digitos.length > 11) {
      return 'Telefone inválido. Use DDD + número.';
    }
    return null;
  }

  // Senha segura: tamanho mínimo, maiúscula, minúscula, número e especial.
  String? validarSenha(String? v) {
    if (v == null || v.isEmpty) return 'Informe a senha.';
    if (v.length < 8) return 'A senha deve ter ao menos 8 caracteres.';
    if (!RegExp(r'[A-Z]').hasMatch(v) || !RegExp(r'[a-z]').hasMatch(v)) {
      return 'Use letras maiúsculas e minúsculas.';
    }
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Inclua ao menos um número.';
    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(v)) {
      return 'Inclua ao menos um caractere especial (!@#\$%...).';
    }
    return null;
  }

  String? validarConfirmacao(String? valor, String senha) {
    if (valor == null || valor.isEmpty) return 'Confirme a senha.';
    if (valor != senha) return 'As senhas não coincidem.';
    return null;
  }

  // Cria a conta no Auth e grava o perfil em usuarios/{uid}.
  // Retorna null em caso de sucesso, ou a mensagem de erro.
  Future<String?> cadastrar({
    required String nome,
    required String email,
    required String telefone,
    required String curso,
    required String senha,
  }) async {
    try {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email.trim(), password: senha);
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(cred.user!.uid)
          .set({
        'nome': nome.trim(),
        'email': email.trim(),
        'telefone': telefone.replaceAll(RegExp(r'\D'), ''),
        'curso': curso.trim(),
        'criadoEm': FieldValue.serverTimestamp(),
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return mensagemAuth(e);
    } catch (_) {
      return 'Não foi possível concluir o cadastro.';
    }
  }
}
