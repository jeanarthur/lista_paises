import 'package:lista_paises/models/pais.dart';

abstract class IPaisesManager {
  Future<List<Pais>> obterPaises();
  Future<List<Pais>> obterPaisesPorNome(String nome);
}