import 'package:firebase_auth/firebase_auth.dart';

// Traduz os códigos de erro do Firebase Auth (usado por login e cadastro).
String mensagemAuth(FirebaseAuthException e) => switch (e.code) {
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' =>
        'E-mail ou senha incorretos.',
      'invalid-email' => 'E-mail inválido.',
      'user-disabled' => 'Esta conta foi desativada.',
      'email-already-in-use' => 'Este e-mail já está cadastrado.',
      'weak-password' => 'Senha fraca. Escolha uma senha mais forte.',
      'network-request-failed' => 'Sem conexão com a internet.',
      'too-many-requests' => 'Muitas tentativas. Aguarde e tente novamente.',
      _ => 'Erro de autenticação (${e.code}).',
    };

class LoginController {
  String? validarEmail(String? valor) {
    final email = valor?.trim() ?? '';
    if (email.isEmpty) return 'Informe o e-mail.';
    final regex = RegExp(r'^[\w\.\-+]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    if (!regex.hasMatch(email)) return 'Informe um e-mail válido.';
    return null;
  }

  String? validarSenha(String? valor) {
    if (valor == null || valor.isEmpty) return 'Informe a senha.';
    return null;
  }

  // Retorna null em caso de sucesso, ou a mensagem de erro.
  // A navegação é feita pelo AuthGate (main.dart).
  Future<String?> entrar(String email, String senha) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: senha);
      return null;
    } on FirebaseAuthException catch (e) {
      return mensagemAuth(e);
    } catch (_) {
      return 'Não foi possível entrar. Tente novamente.';
    }
  }
}
