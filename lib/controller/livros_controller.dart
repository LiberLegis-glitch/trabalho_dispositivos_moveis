import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/academico_model.dart';

class LivrosController {
  final _col = FirebaseFirestore.instance.collection('livros');
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Stream<List<Livro>> listar() => _col
      .where('usuarioId', isEqualTo: _uid)
      .snapshots()
      .map((s) => s.docs.map(Livro.fromDoc).toList()
        ..sort((a, b) => a.devolucao.compareTo(b.devolucao)));

  // Novo empréstimo: devolução em 14 dias.
  Future<void> adicionar(String titulo, String autor) => _col.add({
        'titulo': titulo,
        'autor': autor,
        'devolucao': Timestamp.fromDate(DateTime.now().add(const Duration(days: 14))),
        'renovacoes': 0,
        'usuarioId': _uid,
        'criadoEm': FieldValue.serverTimestamp(),
      });

  Future<void> renovar(Livro l) => _col.doc(l.id).update({
        'devolucao': Timestamp.fromDate(l.devolucao.add(const Duration(days: 7))),
        'renovacoes': FieldValue.increment(1),
      });

  Future<void> devolver(String id) => _col.doc(id).delete();
}
