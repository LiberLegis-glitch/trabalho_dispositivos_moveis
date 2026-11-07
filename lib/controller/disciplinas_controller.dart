import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/academico_model.dart';

class DisciplinasController {
  final _col = FirebaseFirestore.instance.collection('disciplinas');
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  // RF004: tempo real, somente documentos do usuário logado.
  Stream<List<Disciplina>> listar() => _col
      .where('usuarioId', isEqualTo: _uid)
      .snapshots()
      .map((s) => s.docs.map(Disciplina.fromDoc).toList()
        ..sort((a, b) => a.nome.compareTo(b.nome)));

  // RF003: inserção com usuarioId (separação por usuário) e criadoEm.
  Future<void> adicionar(Disciplina d) => _col.add({
        ...d.toMap(),
        'usuarioId': _uid,
        'criadoEm': FieldValue.serverTimestamp(),
      });

  Future<void> excluir(String id) => _col.doc(id).delete();

  String? validarNota(String? v) {
    final n = double.tryParse((v ?? '').replaceAll(',', '.'));
    return (n == null || n < 0 || n > 10) ? 'Informe uma nota de 0 a 10.' : null;
  }

  String? validarFaltas(String? v) {
    final n = int.tryParse(v ?? '');
    return (n == null || n < 0) ? 'Informe um número inteiro.' : null;
  }
}
