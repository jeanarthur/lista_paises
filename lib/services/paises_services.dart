import 'package:lista_paises/models/pais.dart';
import 'package:lista_paises/services/paises_manager.dart';

class PaisesServices {
  final PaisesManager paisesManager;
  PaisesServices(this.paisesManager);

  Future<List<Pais>> obterPaises() async {
    return paisesManager.obterPaises();
  }

}