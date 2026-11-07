import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/academico_model.dart';

// RF005: consumo de API REST pública (BrasilAPI - feriados nacionais).
class FeriadosController {
  Future<List<Feriado>> buscar(int ano) async {
    final resp = await http
        .get(Uri.parse('https://brasilapi.com.br/api/feriados/v1/$ano'))
        .timeout(const Duration(seconds: 15));
    if (resp.statusCode != 200) {
      throw Exception('Erro ${resp.statusCode} ao consultar a API.');
    }
    return (jsonDecode(resp.body) as List)
        .map((e) => Feriado(e['name'], DateTime.parse(e['date'])))
        .toList();
  }
}
