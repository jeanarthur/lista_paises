import 'dart:convert' as convert;
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:lista_paises/models/pais.dart';
import 'package:lista_paises/services/ipaises_manager.dart';

class PaisesManager implements IPaisesManager {
  
  @override
  Future<List<Pais>> obterPaises() async {
    var url = Uri.https('restcountries.com', '/v3.1/all', {'fields': 'name,flags,capital,region,population'});

    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = convert.jsonDecode(response.body);
      log(parsedListJson.toString());
      List<Pais> itemsList = List<Pais>.from(parsedListJson.map<Pais>((dynamic i) => Pais.fromJson(i)));
      return itemsList;
    } else {
      log('Request failed with status: ${response.statusCode}.');
      return List.empty();
    }
  }
  
  @override
  Future<List<Pais>> obterPaisesPorNome(String nome) async {
    var url = Uri.https(
      'restcountries.com',
      '/v3.1/name/$nome',
      {'fields': 'name,flags,capital,region,population'},
    );

    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = convert.jsonDecode(response.body);
      List<Pais> itemsList = List<Pais>.from(
        parsedListJson.map<Pais>((dynamic i) => Pais.fromJson(i)),
      );
      return itemsList;
    } else if (response.statusCode == 404) {
      // Nenhum país encontrado com o nome
      return [];
    } else {
      throw Exception('Erro ao buscar país por nome: ${response.statusCode}');
    }
  }

}