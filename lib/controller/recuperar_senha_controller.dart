import 'package:firebase_auth/firebase_auth.dart';
import 'login_controller.dart';

class RecuperarSenhaController {
  String? validarEmail(String? v) => LoginController().validarEmail(v);

  // Envia o e-mail de redefinição pelo Firebase Auth (lança exceção em falha).
  Future<void> solicitarRecuperacao(String email) =>
      FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
}
